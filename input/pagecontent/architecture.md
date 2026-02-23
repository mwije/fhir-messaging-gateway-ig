### Overview

The gateway distinguishes between two distinct message directions:

- **Inbound Messages** - [FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html)
  (Profile of [Communication]({{site.data.fhir.path | append: 'communication.html'}}))

- **Outbound Messages** - [FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html)
   (Profile of [CommunicationRequest]({{site.data.fhir.path | append: 'communicationrequest.html'}}))

This separation enforces clear semantic boundaries:

- Inbound messages represent facts.
- Outbound messages represent intent.

The IG also includes ConceptMaps for translating legacy v3 ParticipationMode and standard ContactPoint.system codes to FMG messaging channels.

---

### Architectural Model

#### External System → Gateway (Inbound)

External systems submit messages to the gateway.

These are recorded as:

- [Communication]({{site.data.fhir.path | append: 'communication.html'}}) resources
- Conforming to the FMGInboundCommunication profile
- Immutable after successful persistence

Inbound messages represent the event:

> “A message was received by the gateway.”

They SHALL NOT be used to initiate outbound delivery.

---

#### Internal Processing

Upon reception, the gateway SHALL persist the message in an internal database.

The internal storage model is implementation-specific and outside the scope of this guide.

FHIR resources represent the integration boundary only.

---

#### Outbound Scheduling Semantics

Outbound delivery may occur:

- **Immediate Delivery**  
  `occurrenceDateTime` not specified.

- **Scheduled Delivery**  
  `occurrenceDateTime` specifies when the gateway may initiate delivery.

This element represents the earliest allowed dispatch time.

---

#### Gateway → External System (Outbound)

Outbound messages are modeled as:

- [CommunicationRequest]({{site.data.fhir.path | append: 'communicationrequest.html'}})
- Conforming to the FMGOutboundCommunicationRequest profile

These represent the directive:

> “A message must be delivered.”

They undergo lifecycle transitions reflecting delivery orchestration.

---

### Design Principles

#### Directional Exclusivity

| Direction | Resource Type |
|------------|----------------|
| Inbound | Communication |
| Outbound | CommunicationRequest |

Rules:

- Communication SHALL NOT be used for outbound delivery.
- CommunicationRequest SHALL NOT be used for inbound recording.

---

#### Identifier Policy

Business identifiers SHALL be used for external correlation.

FHIR resource `id` values are considered technical identifiers 
and SHALL NOT be relied upon for cross-system reconciliation.

Within transaction Bundles, `urn:uuid` MAY be used for intra-Bundle referencing.

---

#### Payload Strategy

Payload SHALL be represented using `Attachment`.

Supported content includes:

- Structured JSON
- XML
- Binary documents (PDF, images, etc.)
- Encrypted payloads

The gateway does not constrain attachment content semantics.

---

#### Lifecycle Separation

Inbound and outbound flows have independent lifecycle models.

##### Inbound (Communication.status)

- completed
- entered-in-error

Inbound messages do not support intermediate delivery states.

##### Outbound (CommunicationRequest.status)

- draft
- active (**eligible for delivery**)
- on-hold (temporarily suspended)
- revoked (delivery cancelled or was unsuccessful)
- completed (successfully dispatched)
- entered-in-error (technical error)

Status transitions reflect delivery control, not payload mutation.

---

#### Messaging Channel Modeling

FHIR `ContactPoint.system` defines a fixed set of transport mechanisms.  
Modern messaging gateways often require support for additional platforms (e.g., WhatsApp) that are not represented in the standard value set.

Rather than redefining or extending the core `ContactPointSystem` terminology, this guide introduces a governed messaging channel taxonomy:

- A dedicated CodeSystem **[FMGMessagingChannel](StructureDefinition-FMGMessagingChannel.html)** defining all transport channels supported by the gateway.
- A corresponding ValueSet, applied conditionally when beyond the standard [ContactPointSystem]({{site.data.fhir.path | append: 'valueset-contact-point-system.html' }}) value set
- A contextual extension to qualify non-standard transport channels when `ContactPoint.system = other`.

This guide defines **[FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html)**, a constrained profile of [ContactPoint]({{site.data.fhir.path | append: 'datatypes.html#ContactPoint' }}).

- When `ContactPoint.system = other`, a **required extension** SHALL specify the messaging channel from the defined ValueSet.  
- An invariant enforces this rule at validation time to ensure consistency and interoperability.

Both `CommunicationRequest.medium` and `ContactPoint.system` are constrained to the gateway’s **FMGOutboundMediumVS** ValueSet, which is a union of:

- Standard FHIR CommunicationRequest medium codes (excluding `other`) that are directly actionable by the gateway (e.g., SMS, email, phone, pager, fax), and  
- Gateway-specific messaging channels defined in **FMGMessagingChannelVS** (e.g., WhatsApp, Telegram, Signal).  

This ensures all mediums in the ValueSet are actionable while preserving compatibility with standard FHIR codes. The `other` code from the base FHIR ContactPoint system is excluded from medium binding because it is only meaningful when used with **FMGMessagingChannelExtension** on `ContactPoint.system = other`.

The base `ParticipationMode` is illustrative and not enforced; the gateway relies exclusively on this authoritative transport taxonomy for precise orchestration.

#### Outbound Message Channel Resolution

When a `CommunicationRequest` contains multiple `medium` entries, the gateway interprets them as an **ordered set of candidate channels**. The gateway determines delivery according to both the requested media and the **FMGDeliveryPolicy** extension.

**Deterministic processing rules:**

1. **Candidate determination**

   * The gateway constructs the set of candidate channels by intersecting the `medium` array with the recipient’s available contact points (`FMGMessagingContactPoint`).
   * Channels absent from the recipient’s contact points are considered unavailable.

2. **Channel selection policy** (`extension[channelSelectionPolicy]`)

   * `requested-only`: Only channels explicitly listed in `medium` are eligible. If no requested channels are available, the request fails.
   * `allow-substitution`: The gateway may select alternative compatible channels defined in `FMGMessagingChannelVS` if requested channels are unavailable.

3. **Execution mode** (`extension[deliveryMode]`)

   * `single`: Attempt delivery on the first available candidate channel only.
   * `sequential`: Attempt delivery across candidate channels in order until a successful delivery occurs or all channels are exhausted.
   * `broadcast`: Attempt delivery on all candidate channels; success on any channel is sufficient to consider the message delivered.

4. **Priority and ordering**

   * Candidate channels are attempted in the order specified in the `medium` array unless the gateway configuration overrides ordering for sequential or broadcast execution.

5. **Delivery outcome**

   * If no candidate channels are available and the policy forbids substitution (`requested-only`), the request fails.
   * If substitution is allowed, the gateway selects the first compatible alternative according to configuration.
   * Partial success (some channels succeed, others fail) is reported according to gateway operational rules; at minimum, success on one channel satisfies `broadcast` mode.

| Extension                | Values               | Description                                                                                                          |
| ------------------------ | -------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `channelSelectionPolicy` | `requested-only`     | Only channels explicitly listed in `medium` are eligible. If none are available, the request fails.                  |
|                          | `allow-substitution` | Gateway may select alternative compatible channels from FMGMessagingChannelVS if requested channels are unavailable. |
| `deliveryMode`           | `single`             | Attempt delivery on the first available candidate channel only.                                                      |
|                          | `sequential`         | Attempt delivery across candidate channels in order until a successful delivery occurs or all are exhausted.         |
|                          | `broadcast`          | Attempt delivery on all candidate channels; success on any channel is sufficient to consider the message delivered.  |

**Note:** The `medium` array **guides the gateway** but does not guarantee delivery; the actual channels used depend on the recipient’s contact points and the FMGDeliveryPolicy. Implementers **must handle unavailable channels gracefully** and respect the deterministic semantics of channel selection and execution mode.

> Note: The gateway will only attempt delivery on channels that are both present in `medium` and available on the recipient’s contact points unless policy allows substitution. Channels not supported by the gateway or represented only as `other` without the messaging channel extension are ignored.


This approach ensures the IG remains flexible for a variety of gateway behaviors while maintaining deterministic, interoperable messaging semantics.

---

#### Messaging Channel Concept Modeling

Modern messaging gateways require precise identification of transport channels, including platforms not represented in standard FHIR `ContactPoint.system` (e.g., WhatsApp, Telegram, Signal). To support this, the IG defines a governed terminology:

* **CodeSystem:** `FMGMessagingChannelCS` – enumerates all supported messaging channels, including traditional (SMS, email, phone, fax) and app-based platforms.
* **ValueSets:**

  * `FMGMessagingChannelVS` – all channels supported by the gateway.
  * `FMGOutboundMediumVS` – union of actionable FHIR Communication.medium codes and FMG channels.
* **Profile:** `FMGMessagingContactPoint` – constrains `ContactPoint.system = other` to require an extension specifying a channel from `FMGMessagingChannelVS`.

##### ConceptMaps for Interoperability

This IG publishes two ConceptMaps to enable consistent routing across legacy and standard systems:

| ConceptMap                              | Source Codes             | Target Codes           | Purpose                                                                                                     |
| --------------------------------------- | ------------------------ | ---------------------- | ----------------------------------------------------------------------------------------------------------- |
| FMGParticipationModeToMessagingChannel  | v3 ParticipationMode     | FMG Messaging Channels | Maps legacy HL7 v3 participation codes (e.g., SMSWRIT, APPWRIT) to FMG channels for backward compatibility. |
| FMGContactPointSystemToMessagingChannel | FHIR ContactPoint.system | FMG Messaging Channels | Maps standard ContactPoint.system values (sms, email, phone) to FMG channels for routing and delivery.      |

> **Note:** These mappings are **not executed by the IG itself**. Implementers and FHIR servers use the ConceptMaps to perform code translation for routing, reporting, and analytics in a standards-compliant manner.

##### ConceptMap Usage Flow

```
[Legacy/Standard Code]
        |
        | (ConceptMap lookup)
        v
[FMGMessagingChannelCS code]
        |
        | (Gateway routing & policy evaluation)
        v
[Delivery via FMGOutboundMediumVS / FMGMessagingContactPoint]
```

* Incoming messages or integration points may carry codes from legacy v3 systems or standard ContactPoint.system values.
* The gateway resolves these codes to actionable FMG messaging channels using the ConceptMaps.
* This ensures deterministic delivery while preserving semantic clarity and backward compatibility.

##### FMGMessagingChannel Properties

Each FMG channel includes properties to guide routing and operational logic:

| Property        | Type    | Description                                             |
| --------------- | ------- | ------------------------------------------------------- |
| async           | boolean | Indicates asynchronous communication.                   |
| requires-msisdn | boolean | Requires a phone number for delivery.                   |
| supports-media  | boolean | Supports multimedia content (images, video, documents). |
| secure          | boolean | End-to-end encrypted or HIPAA-compliant channel.        |

* Implementers may use these properties programmatically to filter, prioritize, or select channels during delivery orchestration.

##### Integration Guidance

* **Candidate channel determination:** Intersect the requested `medium` array with the recipient’s available `FMGMessagingContactPoint`s.
* **Substitution policy:** Use ConceptMaps to identify alternative channels if `medium` entries are unavailable, respecting `channelSelectionPolicy`.
* **Reporting:** Use ConceptMaps to normalize codes for analytics and audit logs.

This approach preserves FHIR model integrity, enables controlled terminology expansion, and provides a deterministic framework for gateway messaging orchestration.


### Design Rationale

- Preserves the integrity of the base FHIR model
- Avoids modification of standard value sets
- Ensures explicit and unambiguous identification of non-standard channels
- Enforces semantic clarity through invariant-based validation
- Enables controlled future expansion through terminology governance

---

### Conformance Expectations

Implementations SHALL:

- Conform to the defined profiles
- Preserve attachment integrity
- Support Bundle-based submission
- Ensure idempotent processing
- Prefer business identifiers over literal resource IDs  
  (Exception: intra-Bundle referencing via `urn:uuid`)

---

### Out of Scope

This guide does not define:

- Clinical workflows
- Business payload schemas
- Transport-layer security
- Endpoint discovery mechanisms
