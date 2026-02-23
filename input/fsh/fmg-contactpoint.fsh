
Profile: FMGMessagingContactPoint
Parent: ContactPoint
Description: "ContactPoint with required messaging channel extension when system = other"

* extension contains FMGMessagingChannelExtension named messagingChannel 0..1
* obeys gp-1


Invariant: gp-1
Description: "If system is 'other', fmg-channel-extension must be present"
Expression: "system = 'other' implies extension.exists(url = 'http://mwije.github.io/messaging-gateway-ig/StructureDefinition/fmg-channel-extension')"
Severity: #error


// Messaging Channel Extension
Extension: FMGMessagingChannelExtension
Title: "Messaging Channel Extension"
Description: "Specifies the messaging platform when ContactPoint.system = other"
* value[x] only code
* valueCode from FMGMessagingChannelVS (required)