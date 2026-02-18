//gatewaycontactpoint.fsh
Profile: FMGMessagingContactPoint
Parent: ContactPoint
Id: fmg-contactpoint
Description: "ContactPoint with required messaging channel extension when system = other"

* extension contains MessagingChannelExtension named messagingChannel 0..1
* obeys gp-1


Invariant: gp-1
Description: "If system is 'other', messagingChannel extension must be present"
Expression: "system = 'other' implies extension.exists(url = 'http://mwije.github.io/messaging-gateway-ig/StructureDefinition/messaging-channel-extension')"
Severity: #error

