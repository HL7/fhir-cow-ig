ValueSet: COWTaskCodeVS
Id: cow-task-code
Title: "Clinical Orders Workflow Task Codes"
Description: "Task codes for use in Task.code within Clinical Orders Workflow, combining the FHIR-defined task codes with codes defined by this IG. This value set can be used in any Task, but the codes defined by this IG are typically intended for use in dedicated Tasks that support specific workflow steps such as bidding for fulfilment of a request, rather than in the general-purpose Coordination Task."
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #oo
* ^status = #active
* ^experimental = false
* include codes from system http://hl7.org/fhir/CodeSystem/task-code
* include codes from system COWTaskCodeCS
