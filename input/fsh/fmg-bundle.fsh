
Profile: FMGOutboundTransactionBundle
Id: FMGOutboundTransactionBundle
Title: "Outbound Transaction Bundle"
Parent: Bundle
Description: "Bundle profile for submitting multiple outbound message requests in a single transaction."
* type = #transaction (exactly)
* entry ^slicing.discriminator.type = #type
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry contains
    message 1..* and
    entity 0..*
* entry[message].resource only FMGOutboundCommunicationRequest
* entry[entity].resource only Patient or Practitioner or Group
