
Profile: FMGOutboundCommunicationRequest
Parent: CommunicationRequest
Description: "Outgoing Message"
* priority 1..1 SU
* payload 1..*
  * content[x] only Attachment
* recipient 1..*
* recipient.identifier 0..1 MS
* recipient.reference 0..1
* recipient obeys ref-identifier-or-literal

* occurrence[x] only dateTime
* occurrenceDateTime 1..1
* status 1..1
* status from FMGOutboundCommunicationRequestStatusVS (required)

* medium only FMGMessagingChannelVS 1..* (extensible)
* extension contains fmgDeliveryPolicy 1..1
* extension[fmgDeliveryPolicy].description = "Controls delivery orchestration behavior (channel selection & execution mode)."

* extension[fmgDeliveryPolicy].value[x] 0..0

* extension[fmgDeliveryPolicy].extension contains
    channelSelectionPolicy 1..1 and
    deliveryMode 1..1

* extension[fmgDeliveryPolicy].extension[channelSelectionPolicy].value[x] only code
* extension[fmgDeliveryPolicy].extension[channelSelectionPolicy].valueCode from FMGChannelSelectionPolicyVS (required)
* extension[fmgDeliveryPolicy].extension[channelSelectionPolicy] ^short = "Policy governing whether requested channels must be enforced or substituted"

* extension[fmgDeliveryPolicy].extension[deliveryMode].value[x] only code
* extension[fmgDeliveryPolicy].extension[deliveryMode].valueCode from FMGDeliveryModeVS (required)
* extension[fmgDeliveryPolicy].extension[deliveryMode] ^short = "Execution mode governing how compatible channels are attempted"