
Instance: ExamplePatientWhatsApp
InstanceOf: FMGPatient
Usage: #example
Title: "Patient with WhatsApp Contact"
Description: "Demonstrates ContactPoint.system = other with messaging channel extension"

* identifier.system = "http://example.org/mrn"
* identifier.value = "MRN-10001"

* name.family = "Perera"
* name.given[0] = "Nimal"

* telecom[0].system = #other
* telecom[0].value = "+94771234567"

* telecom[0].extension[0].url = "https://mwije.github.io/fhir-messaging-gateway-ig/StructureDefinition-FMGMessagingChannelExtension.html"
* telecom[0].extension[0].valueCode = #whatsapp

Instance: ExamplePatientSMS
InstanceOf: FMGPatient
Usage: #example
Title: "Patient with SMS Contact"
Description: "Demonstrates ContactPoint.system = sms"

* identifier.system = "http://example.org/mrn"
* identifier.value = "MRN-20001"

* name.family = "Silva"
* name.given[0] = "Anjali"

* telecom[0].system = #sms
* telecom[0].value = "+94770001122"


Instance: FMGExampleOutboundReminder
InstanceOf: FMGOutboundCommunicationRequest
Usage: #example
Title: "Scheduled WhatsApp Reminder"
Description: "Outbound reminder message to a patient via WhatsApp"

* status = #active
* priority = #routine
* occurrenceDateTime = "2026-02-20T09:00:00+05:30"
* medium = #whatsapp

* recipient.identifier.system = "http://example.org/mrn"
* recipient.identifier.value = "MRN-10001"

* payload[0].contentAttachment.contentType = #text/plain
* payload[0].contentAttachment.data = "QVBQT0lOVE1FTlQgUkVNSU5ERVI6IFBsZWFzZSBhdHRlbmQgeW91ciBjbGluaWMgYXQgOSBBTSAoMjB0aCBGZWJydWFyeSk="


Instance: FMGExampleTransactionBundle
InstanceOf: FMGOutboundTransactionBundle
Usage: #example
Title: "Outbound Transaction Bundle"
Description: "Transaction bundle submitting message and included patient resource"

* type = #transaction

// --- OutboundCommunication entry ---
* entry[0].fullUrl = "urn:uuid:msg-1"
* entry[0].resource = FMGExampleOutboundReminder
* entry[0].request.method = #POST
* entry[0].request.url = "CommunicationRequest"

// --- Patient entry ---
* entry[1].fullUrl = "urn:uuid:patient-1"
* entry[1].resource = ExamplePatientWhatsApp
* entry[1].request.method = #POST
* entry[1].request.url = "Patient"

Instance: FMGExampleInboundConfirmation
InstanceOf: FMGInboundCommunication
Usage: #example
Title: "Incoming SMS Response"
Description: "Message received from patient confirming appointment"

* status = #completed
* priority = #routine
* received = "2026-02-19T18:45:00+05:30"
* medium = #sms

* sender.identifier.system = "http://example.org/mrn"
* sender.identifier.value = "MRN-10001"

* recipient.identifier.system = "http://example.org/system"
* recipient.identifier.value = "MSG-GATEWAY"

* payload[0].contentAttachment.contentType = #text/plain
* payload[0].contentAttachment.data = "Q29uZmlybWVkLiBJIHdpbGwgYXR0ZW5kLg=="
