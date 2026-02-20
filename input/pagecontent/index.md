### Overview

This Implementation Guide defines a FHIR-based messaging gateway architecture for structured inbound and outbound message exchange.

The gateway models message flow using two distinct profiles:

- **[InboundCommunication](StructureDefinition-FMGInboundCommunication.html)** – a profile of Communication representing messages received by the gateway as immutable records.
- **[OutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html)** – a profile of CommunicationRequest representing delivery intent toward external systems.

Reception and delivery are modeled separately to preserve semantic clarity, traceability, and alignment with FHIR’s event vs. request pattern.

### Architectural Principles

- Inbound messages are immutable event records.
- Outbound messages represent explicit delivery intent.
- Payloads are conveyed using attachments to preserve transport neutrality.
- Transport channels are extensible beyond the base FHIR `ContactPoint` value set through governed terminology and invariant enforcement.
- Transport channels are extensible via the **[FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html)** profile, which enforces explicit identification of non-standard messaging platforms (like WhatsApp) when `ContactPoint.system = other`.

### Scope

This guide focuses exclusively on:

- Message transport modeling
- Payload encapsulation
- Delivery orchestration and tracking

It intentionally does not define:

- Clinical workflows
- Domain-specific content models
- Business process semantics beyond message transport

### Status

Draft (CI Build)

### FHIR Version Compatibility

This guide is authored against **FHIR R4 (4.0.1)** and designed to remain structurally compatible with R4B and R5 where alignment permits. Validation for this publication is performed against FHIR R4.