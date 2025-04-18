Alias: $backport-subscription-status-r4 = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-status-r4

Profile: COWSubscriptionStatus
Parent: $backport-subscription-status-r4
Id: cow-subscription-status
Title: "COW Subscription Status"
Description: "Minimum expectations for a SubscriptionStatus resource when used for Clinical Order Workflow. This profile is used to describe the use of administrative (pre-coordinated) subscription notifications for RESTful-based exchange between the Placer and the Fulfiller. The purpose of the constraints for the SubscriptionStatus resource is to make sure that additional requirements, which may be relevant to a particular implementation or national/regional implementation guides, are compatible with the RESTful-based exchange patterns."
* ^experimental = false
* ^date = "2025-03-03"
* parameter[subscription].valueReference.identifier 1..1 MS SU
* parameter[subscription].valueReference.identifier ^short = "Reference to the Subscription responsible for this notification. Logical reference is the only one supported"
* parameter[subscription].valueReference.identifier ^definition = "The reference to the Subscription which generated this notification, using a logical reference"
* parameter[subscription].valueReference.identifier ^base.path = "Parameters.parameter.valueReference"
* parameter[subscription].valueReference.identifier ^base.min = 0
* parameter[subscription].valueReference.identifier ^base.max = "1"
* parameter[subscription].valueReference.identifier ^isModifier = false
* parameter[notificationEvent].part[eventFocus] ^short = "Parameter pointing to the task which is the event focus"
* parameter[notificationEvent].part[eventFocus].name = "focus" (exactly)
* parameter[notificationEvent].part[eventFocus].name ^short = "Slice discriminator: the event focus"
* parameter[notificationEvent].part[eventFocus].value[x] 1..1 MS
* parameter[notificationEvent].part[eventFocus].value[x] only Reference (CoordinationTask)
* parameter[type].valueCode from OrderNotificationStatusType




CodeSystem: SubscriptionNotificationStatusTypes
Id: subscription-notification-status-type
Title: "Subscription Notification Type"
Description: "The type of notification represented by the status message."
* ^status = #active
* ^experimental = false
* ^url = "http://hl7.org/fhir/ValueSet/subscription-notification-type"
* ^caseSensitive = true
* ^content = #complete
* #handshake "Handshake" "The status was generated as part of the setup or verification of a communications channel."
* #heartbeat "Heartbeat" "The status was generated to perform a heartbeat notification to the subscriber."
* #event-notification "Event Notification" "The status was generated for an event to the subscriber."
* #query-status "Query Status" "The status was generated in response to a status query/request."
* #query-event "Query Event" "The status was generated in response to an event query/request."



ValueSet: OrderNotificationStatusType
Id: order-notification-status-type
Title: "Order Notification Status Type"
Description: "The type of notification represented by the status message."
* ^experimental = false
* ^immutable = true
//* SubscriptionNotificationStatusTypes#event-notification 
* include codes from system SubscriptionNotificationStatusTypes
//* include codes from system http://hl7.org/fhir/subscription-notification-type


Alias: $backport-subscription-notification-r4 = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-notification-r4

Profile:     COWSubscriptionNotification
Parent:      $backport-subscription-notification-r4
Id:          cow-subscription-notification
Title:       "COW Subscription Notification"
Description: "The backported SubscriptionNotification bundle shall contain the backported SubscriptionStatus resource"
* entry[subscriptionStatus].resource only COWSubscriptionStatus

Alias: $placer-task = http://hl7.org/fhir/uv/cow/StructureDefinition/placer-task

Profile: COWMessageHeader
Parent: MessageHeader
Id: cow-message-header
Title: "COW Message Header"
Description: "Minimum expectations for a MessageHeader resource when used for Clinical Order Workflow. This profile is used to describe the use of FHIR Messaging when RESTful-based exchange is not possible between the Placer and the Fulfiller. The purpose of the constraints for the MessageHeader resource is to make sure that the rest of the CLinical Workflow requirements that may be relevant to a particular implementation or national/regional implementation guides are compatible with the RESTful-based exchange patterns."
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension[=].valueCode = #oo
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status"
* ^extension[=].valueCode = #trial-use
* ^url = "http://hl7.org/fhir/uv/cow/StructureDefinition/cow-message-header"
* ^status = #active
* ^experimental = false
* ^date = "2025-03-03"
* focus 1..1 MS
* focus only Reference(coordination-task)
* eventCoding from MessageHeaderEventCodes (extensible)


Profile: CoordinationTask
Parent: Task
Id: coordination-task
Title: "Coordination Task"
Description: "Minimum expectations for a Task resource when created or updated for the purpose of managing the workflow for performing a request. This profile is used to describe the 'please fullfil' request from either a known performer, or by one who is yet to be determined. The information is obtained RESTfully by the recipient either via polling, or as the result of a subscription notification about the existence of the Task resource"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-03-03"
* identifier 1.. MS
  * ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/obligation"
  * ^extension[=].extension[0].url = "code"
  * ^extension[=].extension[=].valueCode = #SHALL:populate
  * ^extension[=].extension[+].url = "actor"
  * ^extension[=].extension[=].valueCanonical = "http://hl7.org/fhir/uv/cow/ActorDefinition/placer"
  * ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/obligation"
  * ^extension[=].extension[0].url = "code"
  * ^extension[=].extension[=].valueCode = #SHALL:handle
  * ^extension[=].extension[+].url = "actor"
  * ^extension[=].extension[=].valueCanonical = "http://hl7.org/fhir/uv/cow/ActorDefinition/filler"
* businessStatus MS
* businessStatus from BusinessStatus (example)
  * ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/obligation"
  * ^extension[=].extension[0].url = "code"
  * ^extension[=].extension[=].valueCode = #SHALL:populate-if-known
  * ^extension[=].extension[+].url = "actor"
  * ^extension[=].extension[=].valueCanonical = "http://hl7.org/fhir/uv/cow/ActorDefinition/placer"
  * ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/obligation"
  * ^extension[=].extension[0].url = "code"
  * ^extension[=].extension[=].valueCode = #SHALL:handle
  * ^extension[=].extension[+].url = "actor"
  * ^extension[=].extension[=].valueCanonical = "http://hl7.org/fhir/uv/cow/ActorDefinition/placer"
  * ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/obligation"
  * ^extension[=].extension[0].url = "code"
  * ^extension[=].extension[=].valueCode = #SHALL:handle
  * ^extension[=].extension[+].url = "actor"
  * ^extension[=].extension[=].valueCanonical = "http://hl7.org/fhir/uv/cow/ActorDefinition/filler"
  * ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/obligation"
  * ^extension[=].extension[0].url = "code"
  * ^extension[=].extension[=].valueCode = #SHALL:populate-if-known
  * ^extension[=].extension[+].url = "actor"
  * ^extension[=].extension[=].valueCanonical = "http://hl7.org/fhir/uv/cow/ActorDefinition/filler"
* code 1.. MS
* focus 1.. MS
  * ^short = "This can only reference a Request resource."
  * ^definition = "This is a reference to the Request resource that is being fulfilled."
* focus only Reference(ServiceRequest)





Profile: CancellationRequestTask
Parent: Task
Id: cancellation-request-task
Title: "Cancellation Request Task"
Description: "A task to indicate a placer-initiated cancellation of a request fulfillment."
* code = http://hl7.org/fhir/CodeSystem/task-code#abort
//* status = #requested
* focus 1..1 MS 
  * ^short = "This can only reference the CoordinationTask or a Request resource"
  * ^definition = "If the Placer requests from the Filler to cancel a Coordination Task, then the focus is a reference to the Coordination Task. If the Fulfiller requests from the Placer to cancel a Request resource that authorizes a particular service, then the focus is a reference that Request resource."
