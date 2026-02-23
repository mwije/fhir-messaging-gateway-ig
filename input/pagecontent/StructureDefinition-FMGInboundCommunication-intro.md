### Scope and Usage

This profile represents messages received by the gateway from external systems.

Inbound messages are immutable records that document the event:
"A message was received."

This resource SHALL NOT be used to initiate outbound delivery.

---

### Behavioral Model

- Exactly one recipient
- One or more payload attachments
- Required priority
- Business identifiers SHOULD be supplied to support external correlation.

Upon successful validation, the gateway SHALL:

1. Persist the message internally
2. Set status to completed
3. Preserve attachment integrity

---

### Status Binding

The `status` element is bound to **[FMGInboundCommunicationStatusVS](ValueSet-FMGInboundCommunicationStatusVS.html)**:

| Status | Description |
|--------|-------------|
| `completed` | Message successfully received and recorded |
| `entered-in-error` | Administrative correction; message should be ignored |

Inbound messages do not support intermediate delivery states. The only valid transition from `completed` is to `entered-in-error` for administrative correction.

---

### Constraints

This profile includes the **`ref-identifier-or-literal`** invariant:

**Expression:** `identifier.exists() or reference.exists()`

This enforces that both `sender` and `recipient` elements MUST have either:
- An `identifier` (business identifier), OR
- A `reference` (literal resource reference)
