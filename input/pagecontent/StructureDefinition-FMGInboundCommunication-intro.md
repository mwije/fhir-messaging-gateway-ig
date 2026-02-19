### Scope and Usage

This profile represents messages received by the gateway from external systems.

Inbound messages are immutable records that document the event:
“A message was received.”

This resource SHALL NOT be used to initiate outbound delivery.

---

### Behavioral Model

- Exactly one recipient
- One or more payload attachments
- Required priority
- Status SHALL be either:
  - completed
  - entered-in-error
- Business identifiers SHOULD be supplied to support external correlation.

Upon successful validation, the gateway SHALL:

1. Persist the message internally
2. Set status to completed
3. Preserve attachment integrity
