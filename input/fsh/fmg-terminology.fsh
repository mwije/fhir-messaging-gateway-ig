//messagingchannel.fsh
CodeSystem: FMGMessagingChannelCS
Id: fmg-channel
Title: "Messaging Channel"
* #sms
* #whatsapp
* #telegram
* #signal
* #email
* #voice


ValueSet: FMGMessagingChannelVS
Id: fmg-channel-vs
Title: "Messaging Channel ValueSet"
* include codes from system FMGMessagingChannelCS


Extension: FMGMessagingChannelExtension
Id: fmg-channel-extension
Title: "Messaging Channel Extension"
Description: "Specifies the messaging platform when ContactPoint.system = other"
* value[x] only code
* valueCode from FMGMessagingChannelVS (required)
