### Scope and Usage

This simple extension specifies the messaging platform when `ContactPoint.system = other`.

---

### Purpose

Standard FHIR `ContactPoint.system` defines a fixed set of values (phone, email, sms, fax, etc.). Modern messaging platforms (WhatsApp, Telegram, Signal) are not included.

This extension allows explicit identification of non-standard platforms while maintaining compatibility with the FHIR specification.

---

### Binding

The extension value **MUST** be from [FMGMessagingChannelVS](ValueSet-FMGMessagingChannelVS.html).

---

### When to Use

Use this extension when `ContactPoint.system = other`:

```json
{
  "system": "other",
  "value": "+94771234567",
  "extension": [
    {
      "url": "https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition/FMGMessagingChannelExtension",
      "valueCode": "whatsapp"
    }
  ]
}
```

When `system` is a standard value (sms, email, phone, fax), this extension is **not needed** - the `system` itself identifies the channel.

See [FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html) profile for enforcement rules.
