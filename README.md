# FMG FHIR Messaging Gateway IG

![Build](https://github.com/mwije/fhir-messaging-gateway-ig/actions/workflows/build.yml/badge.svg)
![FHIR R4](https://img.shields.io/badge/FHIR-R4-blue)
![FHIR R5](https://img.shields.io/badge/FHIR-R5-lightblue)
![FHIR R6](https://img.shields.io/badge/FHIR-R6-lightgrey)

## Overview

This Implementation Guide defines a FHIR-based messaging gateway architecture 
for structured inbound and outbound message exchange.

The gateway distinguishes between:

- **[InboundMessage](docs/StructureDefinition-FMGInboundCommunication.html)** (Profile of Communication)
- **[OutboundMessageRequest](docs/StructureDefinition-FMGOutboundCommunicationRequest.html)** (Profile of CommunicationRequest)

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

It does **not** define:

- Clinical workflows
- Domain-specific content models

## Status

Draft (validated via CI build)

## FHIR Version Compatibility

Authored against **FHIR R4 (4.0.1)** and intentionally designed to remain compatible with **R4B, R5, and R6**. Validation is performed against FHIR R4.

---

## Build & Validation

This project leverages **SUSHI**, **FHIR IG Publisher**, and an IG template to generate and validate the Implementation Guide automatically.  

GitHub Actions CI workflow:

1. Runs **SUSHI** to generate FHIR artifacts from FSH files
2. Runs **FHIR IG Publisher** for validation and site generation
3. Deploys the published IG to **GitHub Pages**  

You can trigger the workflow by pushing changes to the `main` branch. The **Build badge** above reflects the current CI status.

> Note: Only source files (`*.fsh`, `*.md`, examples) should be edited. Generated output is handled automatically.

---

## Profiles Overview

| Profile | Base Resource | Purpose |
|---------|---------------|---------|
| InboundMessage | Communication | Represents messages received by the gateway |
| OutboundMessageRequest | CommunicationRequest | Represents outbound delivery requests |

---

## Contributing

Contributions are welcome via pull requests. Please:

- Fork the repository
- Update FSH source files (`input/*.fsh`) or documentation
- Ensure CI validation passes before merging

The **published IG** is automatically generated from the source files and updated via GitHub Pages.

---

## License

This project is licensed under **[MIT License](LICENSE)**:

- You are free to **share, adapt, and reuse** the content
- Please credit the original repository and author

---

## Resources & Tools

- [SUSHI](https://fshschool.org/) – FHIR Shorthand compiler
- [FHIR IG Publisher](https://github.com/HL7/fhir-ig-publisher) – Validation and IG generation
- [IG Template Guidance](https://build.fhir.org/ig/FHIR/ig-guidance/using-templates.html) – HL7 FHIR templating guidance

---

## Published IG

The latest published version of this IG is available at:  
[https://mwije.github.io/fhir-messaging-gateway-ig/](https://mwije.github.io/fhir-messaging-gateway-ig/)