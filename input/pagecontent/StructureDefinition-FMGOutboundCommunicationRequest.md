### Scope and Usage

This profile represents the intent to deliver a message to an external recipient.

It models outbound orchestration and delivery lifecycle control.

This resource SHALL NOT be used to record inbound messages.

---

### Behavioral Model

Outbound delivery may be:

- Immediate (occurrenceDateTime not specified)
- Scheduled (occurrenceDateTime specifies earliest dispatch time)

Status transitions reflect delivery control and SHALL NOT modify payload content. The following statuses are permitted:

- draft
- active
- on-hold
- revoked
- completed
- entered-in-error


