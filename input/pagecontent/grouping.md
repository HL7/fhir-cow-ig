It is common for orders to be groups of requests: 
* Lab requests ....
* In some jurisdictions, medication prescriptions can have more than one medication. 

The meaning of grouping determines how to implement such grouping in FHIR:

* If the ordered items are functional separate, they are individual, separate Requests.

|Scenario|Item id| Order id||Description|
|---|---|----|----|---|
| Separate orders |Request.identifier|Request.identifier|||
| Single ordering session,<br>independent items|Request.identifier |Request.groupIdentifier ||| 
| Single ordering session,<br>tightly related or<br>interdependent items|Request.identifier |Request..groupIdentifier<br>RequestOrchestration.identifier<br>RequestOrchestration.groupIdentifier ||| 
||.| | | | 



* If the ordered items are authored in one single action, and they are not interdependent but share a same "entry action" or origin, they should have a common .requisition (for ServiceRequest) or .groupIdentifier (for all other Request resources). For these, the "prescription" may have one ID 
  * single-item orders MAY have the .groupIdentifier filled in, for consistency. The searchparameter .group-or-identifier allows searching  implementers may choose whether 
{: .stu-note}


This allows an evolution: 