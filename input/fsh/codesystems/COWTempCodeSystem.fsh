CodeSystem: COWTempCodeSystem
Id: temp
Title: "Temp Clinical Order Workflow Business Status Codes"
Description: "This code system contains example codes for Task.businessStatus. These are example codes, not intended to be used as is. Message header event codes are in a separate code system (cow-message-header-event)."
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
* #awaiting-information "The Fulfiller needs more information in order to proceed with the fulfillment of the request" "This code may be appropriate when the Fulfiller needs more information in order to accept the request, or in order to take the next step for a request which in progress."
* #patient-contacted "Patient contacted" "The Fulfiller has contacted the patient about the requested service, for example to arrange an appointment."
* #scheduled "Scheduled" "The requested service has been scheduled."
* #patient-arrived "Patient arrived" "The patient has arrived for the requested service."
* #exam-begun "Exam begun" "The examination or procedure for the requested service has begun."
* #exam-complete "Exam complete" "The examination or procedure for the requested service has been completed."
* #waiting-for-info "Waiting for Info" "The Fulfiller is waiting for information that is needed to proceed with the fulfillment of the request."
* #result-started "Result started" "Work on the results of the requested service has started, for example the report is being prepared."
* #complete "Complete" "The fulfillment of the request is complete from the Fulfiller's perspective."
* #bid-submitted "Bid Submitted" "A potential Fulfiller has submitted a bid to fulfill the request."
* #bid-accepted "Bid Accepted" "The bid of a potential Fulfiller has been accepted."
* #service-approved "Service Approved" "The requested service has been approved, so that its fulfillment can proceed."
