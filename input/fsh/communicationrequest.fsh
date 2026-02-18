//communicationrequest.fsh
Profile: OutboundCommunication
Parent: CommunicationRequest
Description: "Messages to be delivered"
* priority 1..1 SU
* payload 1..*
  * content[x] only Attachment
* recipient 1..*
* recipient.identifier 1..1
* recipient.reference 0..0
* occurrence[x] only dateTime
* occurrenceDateTime 1..1
* status 1..1


