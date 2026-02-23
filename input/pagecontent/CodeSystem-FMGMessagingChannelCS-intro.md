### Scope and Usage

This CodeSystem defines all messaging channels supported by the FMG messaging gateway.

---

### Why a Separate CodeSystem?

Standard FHIR `ContactPoint.system` defines a fixed set of values (phone, email, sms, fax). Modern messaging platforms (WhatsApp, Telegram, Signal) are not represented.

This CodeSystem provides a governed taxonomy for:
- All traditional channels (SMS, email, phone, fax)
- Modern app-based platforms (WhatsApp, Telegram, Signal, etc.)

The ValueSet [FMGMessagingChannelVS](ValueSet-FMGMessagingChannelVS.html) includes these codes for use in:
- `ContactPoint.system = other` with [FMGMessagingChannelExtension](StructureDefinition-FMGMessagingChannelExtension.html)
- `CommunicationRequest.medium` for outbound delivery

---

### Channel Properties

Each channel includes properties for routing and operational logic:

| Property | Type | Description |
|----------|------|-------------|
| async | boolean | Indicates asynchronous communication (most messaging apps) |
| requires-msisdn | boolean | Requires a phone number for delivery |
| supports-media | boolean | Supports multimedia (images, video, documents) |
| secure | boolean | End-to-end encrypted or HIPAA-compliant channel |

**Usage Example:**

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

See the [Terminology](terminology.html) page for the full list of channels.
