ValueSet: FMGInboundCommunicationStatusVS
Id: fmg-inbound-communication-status
Title: "FMG Inbound Communication Status"
Description: "Permitted status values for inbound messages"

* include http://hl7.org/fhir/event-status#completed
* include http://hl7.org/fhir/event-status#entered-in-error



ValueSet: FMGOutboundCommunicationRequestStatusVS
Title: "FMG Outbound CommunicationRequest Status"
Description: "Permitted status values for outbound delivery"

* include http://hl7.org/fhir/request-status#draft
* include http://hl7.org/fhir/request-status#active
* include http://hl7.org/fhir/request-status#on-hold
* include http://hl7.org/fhir/request-status#revoked
* include http://hl7.org/fhir/request-status#completed
* include http://hl7.org/fhir/request-status#entered-in-error

