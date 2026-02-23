### Overview

This Implementation Guide defines a FHIR-based messaging gateway architecture for structured inbound and outbound message exchange.

The gateway models message flow using two distinct profiles:

- **[FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html)** – a profile of Communication representing messages received by the gateway as immutable records.
- **[FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html)** – a profile of CommunicationRequest representing delivery intent toward external systems.

Reception and delivery are modeled separately to preserve semantic clarity, traceability, and alignment with FHIR's event vs request pattern.

### Architectural Principles

- Inbound messages are immutable event records.
- Outbound messages represent explicit delivery intent.
- Payloads are conveyed using attachments to preserve transport neutrality.
- Transport channels are extensible beyond the base FHIR `ContactPoint` value set through governed terminology.

  When `ContactPoint.system = other`, the **[FMGMessagingChannelExtension](StructureDefinition-FMGMessagingChannelExtension.html)** extension **MUST** be present to identify the non-standard platform (e.g., WhatsApp, Telegram, Signal) and is bound to the **[FMGMessagingChannelVS](ValueSet-FMGMessagingChannelVS.html)** ValueSet.

  If `ContactPoint.system` uses a standard value, the extension **MAY** be present but is **ignored** for routing; the `system` itself determines the channel.

  Legacy v3 ParticipationMode codes and standard ContactPoint.system codes are mapped to FMG messaging channels via ConceptMaps to enable consistent routing and interoperability.

---

### Profiles Overview

| Profile | Base Resource | Purpose |
|---------|---------------|---------|
| [FMGInboundCommunication](StructureDefinition-FMGInboundCommunication.html) | Communication | Messages received by the gateway as immutable records |
| [FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html) | CommunicationRequest | Instructions to deliver a message to an external destination |
| [FMGPatient](StructureDefinition-FMGPatient.html) | Patient | Patient with messaging-capable contact points |
| [FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html) | ContactPoint | ContactPoint with required channel extension when system = other |
| [FMGOutboundTransactionBundle](StructureDefinition-FMGOutboundTransactionBundle.html) | Bundle | Transaction bundle for batch outbound submissions |

There are also participant profiles for [Practitioner](StructureDefinition-FMGPractitioner.html), [RelatedPerson](StructureDefinition-FMGRelatedPerson.html), and [CareTeam](StructureDefinition-FMGCareTeam.html) that require messaging-capable contact points.

### Scope

This guide focuses exclusively on:

- Message transport modeling
- Payload encapsulation
- Delivery orchestration and tracking

It intentionally does not define:

- Clinical workflows
- Domain-specific content models
- Business process semantics beyond message transport

### How to Read This Guide

- **[Home](index.html)**: Introduction and overview (this page)
- **[Architecture](architecture.html)**: Detailed architectural model and design principles
- **[Workflow](workflow.html)**: Message flows, interaction patterns, and operational semantics
- **[Terminology](terminology.html)**: Messaging channel code systems, ValueSets, and ConceptMaps
- **[Artifacts](artifacts.html)**: FHIR profiles, extensions, ValueSets, and CodeSystems defined in this guide

### FHIR Version Compatibility

This guide is authored against **FHIR R4 (4.0.1)** and designed to remain structurally compatible with R4B and R5 where alignment permits. Validation for this publication is performed against FHIR R4.
