Alias: $m49.htm = http://unstats.un.org/unsd/methods/m49/m49.htm

CodeSystem: Clinical_Order_Workflow_MHEvent_Codes
Id: message-header-event
Title: "Clinical Order Workflow MessageHeaderEvent Codes"
Description: "The Event codes for the MessageHeader.event element needed for the order workflow"
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #oo
* ^version = "0.5.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
//* ^valueSet = "http://hl7.org/fhir/uv/cow/ValueSet/cow-message-header-event"
* ^content = #complete
* #new-order "The message is about a new order being placed" "This code is to be used when a new order is communicated for fulfillment for the first time. Any subsequent messages about this order will use the order-update code."
* #order-update "The message is an update to an existing order" "The state of the order fulfillment is tracked via the Task resource. This value indicates that this message is an update (including completion) for an already existing order."
