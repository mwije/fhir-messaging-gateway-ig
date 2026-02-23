### Scope and Usage

This profile constrains the ContactPoint datatype to require explicit messaging channel identification when `system = other`.

---

### Invariant

The profile enforces the rule via invariant `gp-1`:

**If `system = 'other'`, then the messaging channel extension MUST be present.**

This ensures non-standard platforms (WhatsApp, Telegram, Signal, etc.) are always explicitly identified.

---

### Extension Usage

When `ContactPoint.system = other`:

1. The `messagingChannel` extension **SHALL** be present
2. The extension value **MUST** be from [FMGMessagingChannelVS](ValueSet-FMGMessagingChannelVS.html)

When `ContactPoint.system` is a standard value (sms, email, phone, fax), the extension MAY be present but is ignored for routing purposes.

---

### Example

```json
{
  "system": "other",
  "value": "+94771234567",
  "extension": [
    {
      "url": "http://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition/FMGMessagingChannelExtension",
      "valueCode": "whatsapp"
    }
  ]
}
```
