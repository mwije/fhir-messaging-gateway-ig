
Profile: FMGInboundCommunication
Parent: Communication
Description: "Incoming Message"
* priority 1..1 SU
* payload 1..*
* payload.content[x] only Attachment
* payload.contentAttachment 1..1
* sender 0..1
* sender.identifier 0..1 MS
* sender.reference 0..1
* sender obeys ref-identifier-or-literal

* status from FMGInboundCommunicationStatusVS (required)
* received 1..1
* recipient 1..*
* recipient.identifier 0..1 MS
* recipient.reference 0..1
* recipient obeys ref-identifier-or-literal

* medium from FMGMessagingChannelVS (extensible)
