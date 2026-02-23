### Scope and Usage

This profile constrains the Patient resource to require messaging-capable contact points.

All `telecom` elements MUST use the [FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html) datatype, which enforces proper channel identification for non-standard platforms.

---

### Why This Profile?

Standard FHIR `ContactPoint` cannot distinguish between specific messaging platforms (WhatsApp, Telegram, Signal, etc.) when `system = other`.

This profile ensures patients in the gateway system always have properly typed contact information, enabling:
- Correct channel resolution for delivery
- Interoperability with legacy systems via ConceptMaps
- Clear semantics for routing decisions
