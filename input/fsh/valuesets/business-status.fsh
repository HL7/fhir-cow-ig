ValueSet: BusinessStatus
Title: "Clinical Orders Workflow Business Status Codes"
Description: "This value set contains the COW business status codes, for use in Task.businessStatus."
* ^id = "business-status"
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #oo
* ^status = #active
* ^experimental = false
* COWTempCodeSystem#visit-scheduled
* COWTempCodeSystem#specimen-collected 
* COWTempCodeSystem#awaiting-interpretation 
* COWTempCodeSystem#preliminary-outcome 
* COWTempCodeSystem#awaiting-information
* COWTempCodeSystem#patient-contacted
* COWTempCodeSystem#scheduled
* COWTempCodeSystem#patient-arrived
* COWTempCodeSystem#exam-begun
* COWTempCodeSystem#exam-complete
* COWTempCodeSystem#waiting-for-info
* COWTempCodeSystem#result-started
* COWTempCodeSystem#complete
* COWTempCodeSystem#bid-submitted
* COWTempCodeSystem#bid-accepted
* COWTempCodeSystem#service-approved
