Instance: GroupOrIdentifier
InstanceOf: SearchParameter
Usage: #definition

* id = "group-or-identifier"
* status = #active
* name = "GroupOrIdentifier"
* description = "Single search that incides on both request.identifier or groupIdentifier"
* code = #group-or-identifier
* base = #MedicationRequest
* type = #token
* expression = "MedicationRequest.groupIdentifier | MedicationRequest.identifier"
//* processingMode = #normal
