Instance: GroupOrIdentifier
InstanceOf: SearchParameter
Usage: #definition

* id = "group-or-identifier"
* status = #active
* name = "GroupOrIdentifier"
* description = "Single search that includes both request.identifier and groupIdentifier (or requisition for ServiceRequest)"
* code = #group-or-identifier
* base[0] = #Appointment
* base[+] = #CarePlan
* base[+] = #Claim
* base[+] = #CommunicationRequest
* base[+] = #CoverageEligibilityRequest
* base[+] = #DeviceRequest
* base[+] = #EnrollmentRequest
* base[+] = #MedicationRequest
* base[+] = #NutritionOrder
* base[+] = #RequestGroup
* base[+] = #ServiceRequest
* base[+] = #VisionPrescription
* type = #token
* expression = "Appointment.identifier | CarePlan.identifier | Claim.identifier | CommunicationRequest.groupIdentifier | CommunicationRequest.identifier | CoverageEligibilityRequest.identifier | DeviceRequest.groupIdentifier | DeviceRequest.identifier | EnrollmentRequest.identifier | MedicationRequest.groupIdentifier | MedicationRequest.identifier | NutritionOrder.identifier | RequestGroup.groupIdentifier | RequestGroup.identifier | ServiceRequest.requisition | ServiceRequest.identifier | VisionPrescription.identifier"
//* processingMode = #normal
