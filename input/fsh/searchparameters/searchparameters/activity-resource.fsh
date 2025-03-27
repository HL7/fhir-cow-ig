Instance: activity-resource
InstanceOf: SearchParameter
Usage: #definition
* status = #active
* name = "ActivityResource"
* description = "Search on the resources that are linked to a RequestGroup - important to allow for example _revInclude"
* code = #activity-resource
* base = #RequestGroup
* type = #reference
* expression = "RequestGroup.action.resource"
//* processingMode = #normal
