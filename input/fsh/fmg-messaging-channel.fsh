CodeSystem: FMGMessagingChannelCS
Id: FMGMessagingChannelCS
Title: "Messaging Channel"
Description: "Messaging channels supported by the FMG messaging gateway, including traditional and app-based platforms."

// Traditional channels
* #sms "SMS" "Short Message Service, text messaging over cellular network."
* #mms "MMS" "Multimedia Message Service, supports images/video over cellular network."
* #phone "Phone Call" "Voice telephone call."
* #fax "Fax" "Facsimile messaging."
* #email "Email" "Electronic mail messaging."

// Popular messaging services
* #whatsapp "WhatsApp" "WhatsApp messaging platform."
* #telegram "Telegram" "Telegram messaging platform."
* #signal "Signal" "Signal messaging platform."
* #facebook-messenger "Facebook Messenger" "Meta messaging platform."
* #apple-imessage "Apple iMessage" "Apple iMessage platform."
* #ms-teams "Microsoft Teams Chat" "Microsoft Teams messaging platform."
* #slack "Slack" "Slack messaging platform."

// Optional properties for future-proofing
* ^property[0].code = #async
* ^property[0].type = #boolean
* ^property[0].description = "Indicates asynchronous communication channel."
* ^property[1].code = #requires-msisdn
* ^property[1].type = #boolean
* ^property[1].description = "Indicates the channel requires a phone number to reach the recipient."
* ^property[2].code = #supports-media
* ^property[2].type = #boolean
* ^property[2].description = "Indicates the channel supports multimedia messages."
* ^property[3].code = #secure
* ^property[3].type = #boolean
* ^property[3].description = "Indicates whether the channel is end-to-end encrypted or HIPAA-compliant."


// Full valueset
ValueSet: FMGMessagingChannelVS
Title: "Messaging Channel ValueSet"
Description: "All messaging channels supported by the FMG messaging gateway."
* include codes from system FMGMessagingChannelCS


// Mapping with HL7 FHIR ParticipationMode CS
Instance: FMGParticipationModeToMessagingChannel
InstanceOf: ConceptMap
Usage: #definition
Title: "Map v3 ParticipationMode to FMG Messaging Channels"
Description: "Maps HL7 v3 ParticipationMode codes to FMG messaging channel codes where semantically appropriate."
* status = #active

* group[0].source = "http://terminology.hl7.org/CodeSystem/v3-ParticipationMode"
* group[0].target = "http://mwije.github.io/fhir-messaging-gateway-ig/CodeSystem/FMGMessagingChannelCS"

* group[0].element[0].code = #PHONE
* group[0].element[0].target[0].code = #phone
* group[0].element[0].target[0].relationship = #equivalent

* group[0].element[1].code = #EMAILWRIT
* group[0].element[1].target[0].code = #email
* group[0].element[1].target[0].relationship = #equivalent

* group[0].element[2].code = #SMSWRIT
* group[0].element[2].target[0].code = #sms
* group[0].element[2].target[0].relationship = #equivalent

* group[0].element[3].code = #MMSWRIT
* group[0].element[3].target[0].code = #mms
* group[0].element[3].target[0].relationship = #equivalent

* group[0].element[4].code = #APPWRIT
* group[0].element[4].target[0].code = #whatsapp
* group[0].element[4].target[0].relationship = #narrower
* group[0].element[4].target[1].code = #telegram
* group[0].element[4].target[1].relationship = #narrower
* group[0].element[4].target[2].code = #signal
* group[0].element[4].target[2].relationship = #narrower
* group[0].element[4].target[3].code = #facebook-messenger
* group[0].element[4].target[3].relationship = #narrower
* group[0].element[4].target[4].code = #apple-imessage
* group[0].element[4].target[4].relationship = #narrower
* group[0].element[4].target[5].code = #ms-teams
* group[0].element[4].target[5].relationship = #narrower
* group[0].element[4].target[6].code = #slack
* group[0].element[4].target[6].relationship = #narrower
  
* group[0].element[5].code = #FAXWRIT
* group[0].element[5].target[0].code = #fax
* group[0].element[5].target[0].relationship = #equivalent

// Mapping with HL7 FHIR contact-point-system CS
Instance: FMGContactPointSystemToMessagingChannel
InstanceOf: ConceptMap
Usage: #definition
Title: "Map FHIR contact-point-system to FMG Messaging Channels"
Description: "Maps FHIR contact-point-system codes to FMG transport-level messaging channels."
* status = #active

* group[0].source = "http://hl7.org/fhir/contact-point-system"
* group[0].target = "http://mwije.github.io/fhir-messaging-gateway-ig/CodeSystem/FMGMessagingChannelCS"

* group[0].element[0].code = #sms
* group[0].element[0].target[0].code = #sms
* group[0].element[0].target[0].relationship = #equivalent

* group[0].element[1].code = #phone
* group[0].element[1].target[0].code = #phone
* group[0].element[1].target[0].relationship = #equivalent

* group[0].element[2].code = #fax
* group[0].element[2].target[0].code = #fax
* group[0].element[2].target[0].relationship = #equivalent

* group[0].element[3].code = #email
* group[0].element[3].target[0].code = #email
* group[0].element[3].target[0].relationship = #equivalent