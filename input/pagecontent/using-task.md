
### Tracking business status
`Task.businessStatus` is the 


### ...



### Coordinating several requests
The Task resource can be used to coordinate several requests, when they are grouped but not orchestrated (i.e. they are part of the same group, but are not interdependent). 

In future releases of FHIR, `Task.focus` is being considered to expand to 0..* in support of the cases where there is a need to coordinate several requests. For supporting this in R4 and R5, implementers can use a built-in extension mechanism that "imports" an element as an extension. In this case, the task.focus element is imported as an additional extension on Task, thus allowing task.focus to effectively point to several requests.

See the example of [grouped dispense](ex3-grouped-dispense.html)

```
Profile: GroupCoordinationTask
Parent: Task
* extension contains http://hl7.org/fhir/4.0/StructureDefinition/extension-Task.focus named focus 0..* MS
```

<div markdown="1">
Implementers are invited to provide feedback on the expansion of Task.focus, and point to use cases or needs - or alternatives - to addressing the coordination of several requests.
</div>
{:.stu-note}

