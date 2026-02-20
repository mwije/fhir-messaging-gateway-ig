### Overview

The gateway distinguishes between two distinct message directions:

- **Inbound Messages** - [FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html)
  (Profile of [Communication]({{site.data.fhir.path | append: 'communication.html'}}))

- **Outbound Messages** - [FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html)
   (Profile of [CommunicationRequest]({{site.data.fhir.path | append: 'communicationrequest.html'}}))

This separation enforces clear semantic boundaries:

- Inbound messages represent facts.
- Outbound messages represent intent.

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

- A dedicated CodeSystem **[FMGMessagingChannel](StructureDefinition-FMGMessagingChannel.html)**
- A required ValueSet binding applied conditionally when extending beyond the standard [ContactPointSystem]({{site.data.fhir.path | append: 'valueset-contact-point-system.html' }}) value set
- A contextual extension to qualify non-standard transport channels

This guide defines **[FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html)**, a constrained profile of [ContactPoint]({{site.data.fhir.path | append: 'datatypes.html#ContactPoint' }}).

When `ContactPoint.system = other`, a required extension SHALL specify the messaging channel from the defined ValueSet.  
An invariant enforces this rule at validation time.

##### Design Rationale

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
