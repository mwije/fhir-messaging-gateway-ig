
Profile: FMGOutboundCommunicationRequest
Id: FMGOutboundCommunicationRequest
Title: "Outbound CommunicationRequest"
Parent: CommunicationRequest
Description: "CommunicationRequest profile for outbound message delivery orchestration."
* priority 1..1 SU
* payload 1..*
  * content[x] only Attachment
* recipient 1..*
* recipient.identifier 0..1 MS
* recipient.reference 0..1
* recipient obeys ref-identifier-or-literal

* occurrence[x] only dateTime
* occurrenceDateTime 0..1
* status 1..1
* status from FMGOutboundCommunicationRequestStatusVS (required)

* medium from FMGMessagingChannelVS (extensible)
* extension contains FMGDeliveryPolicy named fmgDeliveryPolicy 0..1