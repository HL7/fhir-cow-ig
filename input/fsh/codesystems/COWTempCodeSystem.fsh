CodeSystem: COWTempCodeSystem
Id: temp
Title: "Temp Clinical Order Workflow Example Codes"
Description: "This code system contains codes for Task.businessStatus and MessageHeader event code. These are example codes, not intended to be used as is"
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #oo
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
//* ^valueSet = "http://hl7.org/fhir/uv/cow/ValueSet/cow-businessStatus"
* ^content = #complete
* #visit-scheduled "The patient is scheduled for the requested consultation or procedure" "The patient visit that is the (partial) fulfillment of the request has been scheduled"
* #visit-complete "The visit with the patient for the requested consultation or procedure is complete" "The patient visit that is the (partial) fulfillment of the request has been completed"
* #specimen-collected "The required specimen has been collected" "The specimen required to fulfil the order has been collected."
* #awaiting-interpretation "The observations for the requested consultation or procedure is awaiting interpretation" "This code may be appropriate when the fulfillment of the request involves interpretation step that is shifted in time."
* #preliminary-outcome "The initial outcome of the request fulfillment" "This code may be appropriate when there are preliminary results or when more than one of the requested services need to be performed."
* #awaiting-information "The fulfiller needs more information in order to proceed with the fulfillment of the request" "This code may be appropriate when the fulfiller needs more information in order to accept the request, or in order to take the next step for a request which in progress."
* #new-order "The message is about a new order being placed" "This code is to be used when a new order is communicated for fulfillment for the first time. Any subsequent messages about this order will use the order-update code."
* #order-update "The message is an update to an existing order" "The state of the order fulfillment is tracked via the Task resource. This value indicates that this message is an update (including completion) for an already existing order."
