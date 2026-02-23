### Overview

This section describes the message workflows, interaction patterns, and operational semantics of the FMG messaging gateway.

> **Note:** For architectural overview and profiles, see the [Home](index.html) and [Architecture](architecture.html) pages. For terminology, see the [Terminology](terminology.html) page.

---

### Message Flows

The gateway handles two distinct message directions:

```
External System          Gateway              Client System
       |                    |                      |
       |---[Inbound]------->|------[Inbound]------>|
       |   (non-FHIR)       |        (GET)         |
       |                    |                      |
       |<-------------------|<-----[Outbound]------|
       |                    |   (POST/PUT/DELETE)  |
       |                    |                      |
```

---

### Identifier Policy

The gateway distinguishes between two identifier types:

| Type | Usage | Examples |
|------|-------|----------|
| **Business Identifier** | Used in POST (create) operations to correlate messages externally | `identifier.system`, `recipient.identifier` |
| **Resource Identifier** | Used in PUT (update) and DELETE operations to address specific instances | `/CommunicationRequest/123` |

- POST (create) requests **SHALL NOT** include resource IDs in the URL
- PUT (update) and DELETE requests **SHALL** include the resource ID in the URL
- The gateway assigns resource IDs; clients **SHALL NOT** assume or pre-assign them

---

### Inbound Message Workflow

#### Message Submission

External systems submit messages to the gateway via non-FHIR protocols (SMSC, WhatsApp Business API, email gateways, etc.). These are presented as FHIR resources by the gateway.

The gateway:
1. Persists the message as immutable (status = `completed`)
2. Ensures the message data conforms to [FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html)

> **Note:** FHIR clients **MAY** create inbound messages via POST, but this is not the primary ingestion path. External system integration is the expected mainstay.

Inbound messages **SHALL NOT** be modified by clients. The gateway is the authoritative source.

#### Message Discovery (Polling)

Recipients discover inbound messages by polling with their business identifier:

```
GET /Communication?recipient.identifier=http://example.org/client-id|xxxx&_lastupdated=gt2026-01-01
```

---

### Authorization Model

The gateway **SHALL** enforce access control on **all** operations:

**Query Operations (GET):**
- Clients **MAY** only query resources where `recipient` or `sender` matches their authorized identity
- Business identifiers **MUST** be validated against the client's claims
- Resource IDs alone are insufficient for authorization

**Create Operations (POST):**
- Clients **MAY** only create resources within their authorized scope
- Recipient business identifiers **MUST** be validated against the client's claims

**Update Operations (PUT):**
- Clients **MAY** only update resources they are authorized to access
- The gateway **SHALL** verify the client has rights to modify the specific resource
- Updates are only permitted when the resource is not in a terminal state

**Patch Operations (PATCH):**
- Gateway **MAY** support PATCH for partial updates
- Same authorization and terminal state restrictions as PUT apply

**Delete Operations (DELETE):**
- Clients may only delete resources they are authorized to access

> **Security Note:** Authorization is enforced server-side. Clients cannot bypass restrictions by omitting filters. The gateway **MUST** reject unauthorized requests with appropriate error codes (403 Forbidden).

---

### Outbound Message Workflow

#### Creating Outbound Requests

Clients create outbound message requests via HTTP POST:

```
POST /CommunicationRequest
```

**Required Elements:**
- `status` - Initially `draft` or `active`
- `medium` - At least one channel from [FMGMessagingChannelVS](ValueSet-FMGMessagingChannelVS.html)
- `recipient` - Target recipient(s) referenced by **business identifier**
- `payload` - Message content as Attachment

> **Important:** POST requests **SHALL NOT** include a resource ID. The gateway assigns the ID upon successful creation.

#### Updating Outbound Requests

Clients update outbound message requests via HTTP PUT:

```
PUT /CommunicationRequest/{id}
```

> **Important:** PUT requests **SHALL** include the resource ID in the URL to identify the specific instance.

**Terminal States:**
Updates (PUT/PATCH) are only allowed when status is not in a terminal state:

| Terminal States | Description |
|-----------------|-------------|
| `completed` | Successfully delivered |
| `revoked` | Cancelled or delivery failed permanently |
| `entered-in-error` | Technical error; resource should not have been created |

Attempting to update a resource in a terminal state SHALL result in an error response.

#### Partial Updates (PATCH)

The gateway **MAY** support HTTP PATCH for partial updates:

```
PATCH /CommunicationRequest/{id}
```

If supported, the same terminal state restrictions apply as for PUT.

#### Immediate vs Scheduled Delivery

| Scenario | `occurrenceDateTime` | Behavior |
|----------|---------------------|----------|
| Immediate | Not present | Gateway attempts delivery as soon as request becomes `active` |
| Scheduled | Present | Gateway delays delivery until the specified time |

`occurrenceDateTime` **SHALL NOT** be in the past. Gateway SHALL reject such requests with an error response.

---

### Broadcast (Multiple Recipients)

For sending the same message to multiple recipients, use a **FMGOutboundTransactionBundle**:

**Alternative: Group Recipient**
A gateway MAY support Group resource

When a defined group should receive the message, The gateway SHALL expand the group and creates individual delivery requests for each member, while ensuring auditability and traceability.

---

### Message Delivery Channel Determination

When the same message should be attempted across multiple channels (e.g., try WhatsApp first, then SMS fallback), the gateway executes delivery based on:

1. **Channel Selection** - Intersect requested `medium` with recipient's available channels
2. **Selection Policy** - `requested-only` or `allow-substitution`
3. **Execution Mode** - `single`, `sequential`, or `multicast`

See [Terminology](terminology.html) page for detailed channel resolution semantics.

---

### Status Transitions

#### Inbound (Communication.status)

```
[completed] ---(correct error)--> [entered-in-error]
```

Inbound messages are immutable once completed. The only valid transition is to `entered-in-error` for administrative correction.

#### Outbound (CommunicationRequest.status)

```
                         +-----------+
                         |   draft   |
                         +-----------+
                               |
                               | activate
                               v
                         +-----------+
                         |  active   |
                         +-----------+
                               |
                  +------------+-------------+
                  |                          |
                  | hold                     | success
                  v                          v
            +-----------+              +-------------+
            |  on-hold  |              |  completed  |
            +-----------+              +-------------+
                  |
                  | resume
                  +-----------------> (back to active)


--------------------------------------------------------

From ANY non-terminal state (draft, active, on-hold):

        cancel / failure  ----------->  +-----------+
                                        |  revoked  |
                                        +-----------+

        technical correction  ------> +------------------+
                                      | entered-in-error |
                                      +------------------+
```

| Status | Description |
|--------|-------------|
| `draft` | Request created but not yet submitted for delivery |
| `active` | Eligible for delivery orchestration |
| `on-hold` | Temporarily suspended |
| `revoked` | Cancelled or delivery failed permanently |
| `completed` | Successfully delivered |
| `entered-in-error` | Technical error; resource should not have been created |

---

### Revocation / Cancellation

To cancel a pending delivery, **update** the status to `revoked` via HTTP PUT. DELETE method is also supported but discouraged.

---

### Query Patterns

#### Check Delivery Status

Clients query outbound message status:

```
GET /CommunicationRequest?identifier=http://example.org/msg-id|xxxx
```

#### List Messages by Status

```
GET /CommunicationRequest?status=active
GET /Communication?status=completed&recipient.identifier=...
```

---

### Future: Push Notifications

The current design relies on polling for message discovery. Future versions may support:

- **FHIR Subscriptions** - Clients subscribe to receive notifications when messages arrive
- **Webhooks** - Push delivery status changes to registered endpoints

Until then, clients **SHALL** poll periodically to detect new inbound messages.

---

### Security Considerations

The gateway implements defense-in-depth across all operations:

1. **Authentication** - All endpoints require valid authentication (OAuth2, API key, mutual TLS, etc.)
2. **Authorization** - The gateway enforces scope on **all** HTTP methods:
   - **GET**: Clients **MAY** only read resources scoped to their authorized identity
   - **POST**: Clients **MAY** only create resources within their authorized scope
   - **PUT/PATCH**: Clients **MAY** only update resources they are authorized to access, and only when not in a terminal state
   - **DELETE**: Clients **MAY** only delete resources they are authorized to access
3. **Transport** - All traffic over TLS/HTTPS (mutual TLS recommended)
4. **Input Validation** - All inbound content validated before persistence
5. **Audit Logging** - All operations logged with client identity, timestamp, and action

> **Privacy Critical:** The gateway **SHALL NOT** allow clients to access resources outside their authorized scope, regardless of how the request is formulated. Server-side enforcement is mandatory - relying on clients to filter their own queries is insufficient.

---

### Privacy Considerations

1. **Data Minimization** - Queries return only resources within the client's authorized scope
2. **No Resource Enumeration** - Clients cannot discover other clients' resources through brute-force or iteration
3. **Business Identifiers** - Primary addressing mechanism; resource IDs are opaque
4. **Provenance** - Optional provenance tracking for audit trail
