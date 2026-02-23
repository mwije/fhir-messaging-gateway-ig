### Overview

> **Note:** For introduction, profiles, scope, and architectural principles, see the [Home](index.html) page.

This section provides detailed architectural model, design principles, and technical implementation guidance.

The gateway distinguishes between two message directions:

- **Inbound** – [FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html) (profile of Communication)
- **Outbound** – [FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html) (profile of CommunicationRequest)

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

> **Note:** For identifier usage in API operations, see the [Workflow](workflow.html) page.

#### Directional Exclusivity

| Direction | Resource Type |
|------------|----------------|
| Inbound | Communication |
| Outbound | CommunicationRequest |

Rules:

- Communication SHALL NOT be used for outbound delivery.
- CommunicationRequest SHALL NOT be used for inbound recording.

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

Inbound and outbound flows have independent lifecycle models:

- **Inbound** - Uses [FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html) profile. Status is bound to [FMGInboundCommunicationStatusVS](ValueSet-FMGInboundCommunicationStatusVS.html). See profile page for details.

- **Outbound** - Uses [FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html) profile. Status is bound to [FMGOutboundCommunicationRequestStatusVS](ValueSet-FMGOutboundCommunicationRequestStatusVS.html). See profile page for details.

Status transitions reflect delivery control, not payload mutation.

---

### Workflow

Message flows, interaction patterns, delivery orchestration, and status transitions are detailed in the [Workflow](workflow.html) page.

---

### Terminology

CodeSystems, ValueSets, and ConceptMaps are documented in the [Terminology](terminology.html) page.

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
