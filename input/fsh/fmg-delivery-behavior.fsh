CodeSystem: FMGDeliveryMode
Title: "FMG Delivery Mode"
Description: "Defines how the gateway executes delivery attempts across candidate channels."
* ^status = #active
* ^caseSensitive = true
* ^content = #complete

* #single "Single"
  "The gateway SHALL attempt delivery via the first compatible channel only."

* #sequential "Sequential"
  "The gateway SHALL attempt delivery across compatible channels sequentially until success or exhaustion."

* #broadcast "Broadcast"
  "The gateway SHALL deliver the message to all compatible channels."


ValueSet: FMGDeliveryModeVS
Title: "FMG Delivery Mode ValueSet"
Description: "Allowed execution modes for the FMG messaging gateway."
* ^status = #active
* include codes from system FMGDeliveryMode


CodeSystem: FMGChannelSelectionPolicy
* #requested-only "Requested Only"
* #allow-substitution "Allow Substitution"

ValueSet: FMGChannelSelectionPolicyVS
Description: "Allowed channel selection mode for the FMG messaging gateway."
* ^status = #active
* include codes from system FMGChannelSelectionPolicy

Extension: FMGDeliveryPolicy
Title: "FMG Delivery Policy"
Description: "Defines delivery orchestration behavior for a CommunicationRequest."
* ^status = #active
* ^context.type = #element
* ^context.expression = "CommunicationRequest"

* value[x] 0..0

* extension contains
    channelSelectionPolicy 1..1 and
    deliveryMode 1..1

* extension[channelSelectionPolicy].value[x] only code
* extension[channelSelectionPolicy].valueCode from FMGChannelSelectionPolicyVS (required)
* extension[channelSelectionPolicy] ^short = "Policy governing whether requested channels must be enforced or substitution is allowed"

* extension[deliveryMode].value[x] only code
* extension[deliveryMode].valueCode from FMGDeliveryModeVS (required)
* extension[deliveryMode] ^short = "Execution mode governing how compatible channels are attempted"