### Assumptions

- A practitioner orders a diet for an inpatient. The dietary system that assigns the diet and prepares the meals is the Fulfiller.
- The Coordination Task is at the Fulfiller: the Placer creates it on the dietary system's FHIR server and subscribes to its updates.
- The `NutritionOrder` remains active while it is being fulfilled. It is temporarily put on hold (for example, while the patient is fasting before a procedure) and later reactivated.
- Systems can view the current diet (`NutritionOrder`) and the fulfillment status (`Task`) at any time.
- The `Task.businessStatus` values in this example are illustrative.
- Transport mechanisms and infrastructure for exchanging data about `NutritionOrder` and `Task` are provided.

### Example
<figure>
  {% include ex8-nutrition-order.svg %}
</figure>
