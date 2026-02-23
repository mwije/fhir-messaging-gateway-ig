### Scope and Usage

This profile represents the intent to deliver a message to an external recipient.

It models outbound orchestration and delivery lifecycle control.

This resource SHALL NOT be used to record inbound messages.

---

### Behavioral Model

Outbound delivery may be:

- Immediate (`occurrenceDateTime` not specified)
- Scheduled (`occurrenceDateTime` specifies earliest dispatch time)

Status transitions reflect delivery control and SHALL NOT modify payload content.

---

### Status Binding

The `status` element is bound to **[FMGOutboundCommunicationRequestStatusVS](ValueSet-FMGOutboundCommunicationRequestStatusVS.html)**:

| Status | Description |
|--------|-------------|
| `draft` | Request created but not yet submitted for delivery |
| `active` | Eligible for delivery orchestration |
| `on-hold` | Temporarily suspended |
| `revoked` | Cancelled or delivery failed permanently |
| `completed` | Successfully delivered |
| `entered-in-error` | Technical error; resource should not have been created |

See the [Workflow](workflow.html) page for detailed status transition diagrams.

---

### Delivery Policy

This profile includes the **[FMGDeliveryPolicy](StructureDefinition-FMGDeliveryPolicy.html)** extension which controls delivery orchestration behavior:

- `channelSelectionPolicy` - Whether requested channels **MUST** be used or substitution is allowed
- `deliveryMode` - How compatible channels are attempted (single, sequential, multicast)

See the [Terminology](terminology.html) page for detailed delivery policy semantics.

---

### Constraints

This profile includes the **`ref-identifier-or-literal`** invariant:

**Expression:** `identifier.exists() or reference.exists()`

This enforces that the `recipient` element MUST have either:
- An `identifier` (business identifier), OR
- A `reference` (literal resource reference)