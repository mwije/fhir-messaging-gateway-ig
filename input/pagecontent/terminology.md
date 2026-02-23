### Overview

This section details the terminology artifacts: CodeSystems, ValueSets, and ConceptMaps that define the messaging channel taxonomy.

> **Note:** For architectural overview, see the [Home](index.html) page. For message workflows and interaction patterns, see the [Workflow](workflow.html) page.

---

### CodeSystems

#### FMGMessagingChannelCS

The [FMGMessagingChannelCS](CodeSystem-FMGMessagingChannelCS.html) CodeSystem enumerates all messaging channels supported by the gateway:

| Code | Display | Description |
|------|---------|-------------|
| sms | SMS | Short Message Service, text messaging over cellular network |
| mms | MMS | Multimedia Message Service, supports images/video |
| phone | Phone Call | Voice telephone call |
| fax | Fax | Facsimile messaging |
| email | Email | Electronic mail |
| whatsapp | WhatsApp | WhatsApp messaging platform |
| telegram | Telegram | Telegram messaging platform |
| signal | Signal | Signal messaging platform |
| facebook-messenger | Facebook Messenger | Meta messaging platform |
| apple-imessage | Apple iMessage | Apple iMessage platform |
| ms-team | Microsoft Teams Chat | Microsoft Teams messaging |
| slack | Slack | Slack messaging platform |

**Channel Properties:**

| Property | Type | Description |
|----------|------|-------------|
| async | boolean | Indicates asynchronous communication |
| requires-msisdn | boolean | Requires a phone number for delivery |
| supports-media | boolean | Supports multimedia content |
| secure | boolean | End-to-end encrypted or HIPAA-compliant |

---

### ValueSets

#### FMGMessagingChannelVS

The **[FMGMessagingChannelVS](ValueSet-FMGMessagingChannelVS.html)** ValueSet includes all channels supported by the gateway. Used for binding when `ContactPoint.system = other`.

This ValueSet is also used for the `medium` element on outbound CommunicationRequest.

---

### ConceptMaps

#### FMGParticipationModeToMessagingChannel

Maps legacy HL7 v3 ParticipationMode codes to FMG messaging channels:

| Source (v3) | Target (FMG) | Relationship |
|-------------|--------------|--------------|
| PHONE | phone | equivalent |
| EMAILWRIT | email | equivalent |
| SMSWRIT | sms | equivalent |
| MMSWRIT | mms | equivalent |
| APPWRIT | (whatsapp, telegram, signal, etc.) | narrower |
| FAXWRIT | fax | equivalent |

> **Note:** `APPWRIT` maps to multiple granular channels (WhatsApp, Telegram, Signal, etc.). Systems SHALL resolve to the specific platform based on context.

#### FMGContactPointSystemToMessagingChannel

Maps standard FHIR ContactPoint.system values to FMG channels:

| Source (FHIR) | Target (FMG) | Relationship |
|---------------|--------------|--------------|
| sms | sms | equivalent |
| phone | phone | equivalent |
| fax | fax | equivalent |
| email | email | equivalent |

> **Note:** These ConceptMaps are **not executed by the IG itself**. Implementers and FHIR servers use them for code translation during routing and analytics.

---

### Delivery Policy

The gateway uses the **[FMGDeliveryPolicy](StructureDefinition-FMGDeliveryPolicy.html)** extension to control delivery orchestration behavior.

#### FMGDeliveryPolicy Extension

This extension is attached to `CommunicationRequest` and contains two sub-extensions:

| Sub-Extension | Purpose |
|--------------|---------|
| `channelSelectionPolicy` | Controls whether requested channels **MUST** be used or substitution is allowed |
| `deliveryMode` | Controls how compatible channels are attempted |

#### Channel Selection Policy

The **[FMGChannelSelectionPolicyVS](ValueSet-FMGChannelSelectionPolicyVS.html)** ValueSet defines:

| Code | Description |
|------|-------------|
| `requested-only` | Only requested channels are eligible. If unavailable, delivery fails. |
| `allow-substitution` | Gateway **MAY** select alternative compatible channels if requested are unavailable. |

#### Delivery Mode

The **[FMGDeliveryModeVS](ValueSet-FMGDeliveryModeVS.html)** ValueSet defines:

| Code | Description |
|------|-------------|
| `single` | Attempt delivery via the first compatible channel only. |
| `sequential` | Attempt delivery across compatible channels sequentially until success or exhaustion. |
| `multicast` | Deliver the message to all compatible channels. |

See the [Workflow](workflow.html) page for usage in message delivery orchestration.

---

### ContactPoint Extension

When `ContactPoint.system = other`, the **[FMGMessagingChannelExtension](StructureDefinition-FMGMessagingChannelExtension.html)** extension **SHALL** be present to identify the specific platform (WhatsApp, Telegram, Signal, etc.).

The **[FMGMessagingContactPoint](StructureDefinition-FMGMessagingContactPoint.html)** profile enforces this via invariant.

---

### Extending the CodeSystem

The [FMGMessagingChannelCS](CodeSystem-FMGMessagingChannelCS.html) CodeSystem is designed to be extended as new messaging platforms emerge. Implementers MAY request additions by:

1. **Opening an issue** in the [GitHub repository](https://github.com/mwije/fhir-messaging-gateway-ig/issues) with:
   - Proposed channel code (dash-case)
   - Display name
   - Description
   - Channel properties (async, requires-msisdn, supports-media, secure)
   - Use case justification

2. **Submitting a pull request** with:
   - Addition to the CodeSystem in `fmg-messaging-channel.fsh`
   - Addition to FMGMessagingChannelVS
   - Updated examples if applicable

All new channels SHALL be reviewed for:
- Governance approval
- Interoperability considerations
- Mapping to existing legacy codes (if any)

> **Note:** This IG follows FHIR's extensibility model. ValueSets use `extensible` binding to allow additional codes beyond those defined here, subject to implementation governance.
