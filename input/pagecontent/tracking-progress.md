
In general progress is tracked via **Task.status**, **Task.businessStatus**, and **Task.statusReason**.  

### Task.businessStatus

In cases where the progress can be "coded", systems should use the `.businessStatus` element in the Coordination Task to represent that progress status e.g. `collection-complete` or `mandatory-program-complete`.  

If further detail on progress is needed, the mechanism depends on whether there is a need to persist and exchange the progress, or the stakeholders can consult the relevant resources to determine progress from those resources. See [Sharing Ouputs](sharing-outputs.html).  

Two mechanisms can be used:

### Counting task.output  

This approach doesn't require any elements on the resources. It relies on counting the actual/expected outputs.

Systems should know what task.outputs to count (resource types, status) - this is dependent on business rules, and should be consistent between impacted parties.
  * Note that this also requires access to the outputs (see above).  


#### Example: Physiotherapy - count number of sessions
For a patient that has undergone 4 out of 10 planned physiotherapy sessions,  

### Explicitly track progress with task.output as a Ratio

In cases where a ratio is expected and can be determined, (for example when there is a need for n out of m instances are completed or a percentage of progress towards completion) and this ratio can be persisted.   

#### Example: Physiotherapy - tracking sessions completed

In this example, a physiotherapy treatment plan requires 10 sessions. After 4 sessions are completed, the progress is tracked using `Task.output` with a Ratio datatype:

```json
{
  "resourceType": "Task",
  ...
  "output": [
    {
      "type": {
        "coding": [
          {
            "system": "http://example.org/output-types",
            "code": "sessions-progress",
            "display": "Sessions Progress"
          }
        ]
      },
      "valueRatio": {
        "numerator": {
          "value": 4,
          "unit": "sessions",
          "system": "http://unitsofmeasure.org",
          "code": "{session}"
        },
        "denominator": {
          "value": 10,
          "unit": "sessions",
          "system": "http://unitsofmeasure.org",
          "code": "{session}"
        }
      }
    }
  ]
}
```

This indicates that 4 out of 10 required sessions have been completed (or, for example, 40% progress).

Note: The appropriate display of ratios is out of scope of this guidance.
