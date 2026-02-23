### Scope and Usage

This extension defines delivery orchestration behavior for a `CommunicationRequest`. It controls how the gateway selects and attempts delivery channels.

---

### Structure

The extension contains two sub-extensions:

| Sub-Extension | Required | Purpose |
|--------------|----------|---------|
| `channelSelectionPolicy` | Yes | Controls whether requested channels **MUST** be used or substitution is allowed |
| `deliveryMode` | Yes | Controls how compatible channels are attempted |

---

### Channel Selection Policy

| Code | Description |
|------|-------------|
| `requested-only` | Only channels explicitly listed in `medium` are eligible. If none are available, delivery fails. |
| `allow-substitution` | Gateway **MAY** select alternative compatible channels if requested channels are unavailable. |

---

### Delivery Mode

| Code | Description |
|------|-------------|
| `single` | Attempt delivery via the first compatible channel only. |
| `sequential` | Attempt delivery across compatible channels sequentially until success or exhaustion. |
| `multicast` | Attempt delivery on all compatible channels. Success on any channel satisfies the request. |

---

### Example

```json
{
  "extension": [
    {
      "url": "https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGDeliveryPolicy.html",
      "extension": [
        {
          "url": "channelSelectionPolicy",
          "valueCode": "allow-substitution"
        },
        {
          "url": "deliveryMode", 
          "valueCode": "sequential"
        }
      ]
    }
  ]
}
```

See the [Workflow](workflow.html) page for detailed delivery orchestration semantics.
