Instance:    CowNotificationStatusExample
InstanceOf:  COWSubscriptionStatus
Usage:       #example
Title:       "COW Notification Status"
Description: "Example of a COW subscription notification status"
* id       = "cow-notification-status-example"
* parameter[subscription].name = "subscription"
* parameter[subscription].valueReference.identifier.value = "77240214"
* parameter[subscription].valueReference.identifier.system = "https://placer.example.org/cow-subscrition/orders"
* parameter[status].name = "status"
* parameter[status].valueCode = #active
* parameter[type].name = "type"
* parameter[type].valueCode = #event-notification
* parameter[notificationEvent].name = "notification-event"
* parameter[notificationEvent].part[eventNumber].name = "event-number"
* parameter[notificationEvent].part[eventNumber].valueString = "3323"
* parameter[notificationEvent].part[eventFocus].valueReference = Reference(COWCoordinationTask)
* parameter[notificationEvent].part[eventTimestamp].valueInstant = "2025-03-28T15:44:18.1882432-05:00"

Instance:    COWCoordinationTask
InstanceOf:  CoordinationTask
Usage:       #example
Title:       "COW Coordination Task"
Description: "Example of a COW 'please fullfil' coordination task"
* id                  = "cow-coordination-task-example"
* identifier.value    = "f085e001-2e55-4ae0-aa1b-f5e17ec42d91"
* identifier.system   = "https://placer.example.org/cpoe"
* status              = #in-progress
* intent              = #order
* code.coding.code    = #fulfill
* code.coding.system  = "http://hl7.org/fhir/CodeSystem/task-code"
* focus               = Reference(COWServiceRequest)


Instance:    COWServiceRequest
InstanceOf:  ServiceRequest
Usage:       #example
Title:       "COW Service Request"
Description: "Example of a COW ServiceRequest for a Glucose lab test designated by https://loinc.org/2345-7"
* id            = "cow-service-request-example"
* identifier.value    = "5f8b4be6-9484-449d-a217-7472a0389899"
* identifier.system   = "https://placer.example.org/ehr"
* status          = #active
* intent          = #order
* code.coding.code = #2345-7
* code.coding.system = "http://loinc.org"
* subject.identifier.value = "553242"
* subject.identifier.type.coding.code = #MR
* subject.identifier.type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* subject.identifier.system = "https://placer.example.org/ehr"
* subject.type = #Patient
* subject.display = "Mr. John Doe"

Instance:    COWCancellationTask
InstanceOf:  CancellationRequestTask
Usage:       #example
Title:       "COW Cancellation Task"
Description: "Example of a COW cancellation task created by the placer"
* id                  = "cow-cancellation-task-example"
* identifier.value    = "e5ffec7e-4b00-4a9b-88db-e9c848aed46c"
* identifier.system   = "https://placer.example.org/cpoe"
* status              = #requested
* intent              = #order
* code                = http://hl7.org/fhir/CodeSystem/task-code#abort
* focus               = Reference(COWCoordinationTask)


Alias: $COWSubStatus = https://example.org/fhir/Subscription/COW/$status

Instance:    COWNotificationExampleStatusOnly
InstanceOf:  COWSubscriptionNotification
Usage:       #example
Title:       "COW Notification: Status with Focus only"
Description: "COW example of a Subscription Notification, where the status only points to the focal Task"
* id        = "cow-notification-status-only-example"
* timestamp = "2025-03-28T19:44:13-05:00"
* entry[0].fullUrl = "urn:uuid:58c593d1-df96-4000-b1c3-d9fdcac876d7"
* entry[0].resource = CowNotificationStatusExample
* entry[0].request.method = #GET
* entry[0].request.url = $COWSubStatus
* entry[0].response.status = "200"

Instance:    COWMessageHeaderExample
InstanceOf:  COWMessageHeader
Usage:       #example
Title:       "COW MessageHeader Example"
Description: "COW example of a message header for an order update"
* id       = "cow-message-header-example"
* eventCoding       = http://hl7.org/fhir/uv/cow/CodeSystem/temp#order-update
* source.endpoint   = "https://placer.example.org/fhir/$processAck"
* focus = Reference(COWCoordinationTask)