# FHIR Messaging Gateway (FMG) - FHIR Implementation Guide

[![FHIR R4](https://img.shields.io/badge/FHIR-R4-blue)](https://hl7.org/fhir/R4/)
[![FHIR R4B Compatible](https://img.shields.io/badge/FHIR-R4B%20Compatible-lightblue)](https://hl7.org/fhir/R4B/)
[![FHIR R5 Compatible](https://img.shields.io/badge/FHIR-R5%20Compatible-lightgrey)](https://hl7.org/fhir/R5/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[![Pages](https://img.shields.io/badge/View-Implementation%20Guide-blue)
![IG Status](https://img.shields.io/badge/IG%20Status-Draft-lightgrey)](https://mwije.github.io/fhir-messaging-gateway-ig/)
[![IG Build & Validation](https://github.com/mwije/fhir-messaging-gateway-ig/actions/workflows/build.yml/badge.svg)](actions)

## Overview

This Implementation Guide defines a FHIR-based messaging gateway architecture 
for structured inbound and outbound message exchange.

The gateway models message flow using two distinct profiles:

- **[FMGInboundCommunication](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGInboundCommunication.html)** 
  A profile of Communication representing messages received by the gateway as immutable records.

- **[FMGOutboundCommunicationRequest](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGOutboundCommunicationRequest.html)**
  A profile of CommunicationRequest representing instructions to deliver a message to an external destination.

This separation enforces a clear architectural boundary:

- Inbound messages are factual records of what was received.
- Outbound messages are request-driven delivery actions initiated by the system.

The gateway avoids overloading a single resource with dual responsibilities, distinguishing reception from delivery intent.

### Architectural Principles

- Inbound messages are immutable records.
- Outbound messages are request-driven orchestration artifacts.
- Attachments are used as the message payload mechanism.

### Scope

This guide focuses exclusively on:

- Message transport modeling
- Payload handling
- Delivery tracking

It does **not** define:

- Clinical workflows
- Domain-specific content models


## FHIR Version Compatibility

Authored against **FHIR R4 (4.0.1)** and intentionally designed to remain compatible with **R4B and R5**. Validation is performed against FHIR R4.


## Build & Validation

This project leverages **SUSHI**, **FHIR IG Publisher**, and an IG template to generate and validate the Implementation Guide automatically.  

GitHub Actions CI workflow:

1. Runs **SUSHI** to generate FHIR artifacts from FSH files
2. Runs **FHIR IG Publisher** for validation and site generation
3. Deploys the published IG to **GitHub Pages**  

You can trigger the workflow by pushing changes to the `main` branch. The **Build badge** above reflects the current CI status.

> Note: Only source files (`*.fsh`, `*.md`, examples) should be edited. Generated output is handled automatically.


## Profiles Overview

| Profile | Base Resource | Purpose |
|---------|---------------|---------|
| [FMGInboundCommunication](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGInboundCommunication.html) | Communication | Messages received by the gateway as immutable records |
| [FMGOutboundCommunicationRequest](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGOutboundCommunicationRequest.html) | CommunicationRequest | Instructions to deliver a message to an external destination |
| [FMGPatient](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGPatient.html) | Patient | Patient with messaging-capable contact points |
| [FMGMessagingContactPoint](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGMessagingContactPoint.html) | ContactPoint | ContactPoint with required channel extension when system = other |
| [FMGOutboundTransactionBundle](https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGOutboundTransactionBundle.html) | Bundle | Transaction bundle for batch outbound submissions |

Additional participant profiles: FMGPractitioner, FMGRelatedPerson, FMGCareTeam.


## Contributing

Contributions are welcome via pull requests. Please:

- Fork the repository
- Update FSH source files (`input/*.fsh`) or documentation
- Ensure CI validation passes before merging

The **published IG** is automatically generated from the source files and updated via GitHub Pages.


## Resources & Tools

- [SUSHI](https://fshschool.org/) – FHIR Shorthand compiler
- [FHIR IG Publisher](https://github.com/HL7/fhir-ig-publisher) – Validation and IG generation
- [IG Template Guidance](https://build.fhir.org/ig/FHIR/ig-guidance/using-templates.html) – HL7 FHIR templating guidance

