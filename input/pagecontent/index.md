## FHIR Messaging Gateway Implementation Guide

### Overview

This Implementation Guide defines a FHIR-based messaging gateway architecture 
for structured inbound and outbound message exchange.

The gateway distinguishes between:

- **[InboundMessage]({{site.data.fhir.path}} + 'StructureDefinition-FMGInboundCommunication.html')** (Profile of Communication)
- **[OutboundMessageRequest]({{site.data.fhir.path}} + 'StructureDefinition-FMGOutboundCommunicationRequest.html')** (Profile of CommunicationRequest)

The design intentionally separates:
- Messages received by the gateway
- Messages to be delivered externally

### Architectural Principles

- Inbound messages are immutable records.
- Outbound messages are request-driven orchestration artifacts.
- Attachments are used as the message payload mechanism.

### Scope

This guide focuses exclusively on:
- Message transport modeling
- Payload handling
- Delivery tracking

It does not define:
- Clinical workflows
- Domain-specific content models

### Status

Draft (CI Build)