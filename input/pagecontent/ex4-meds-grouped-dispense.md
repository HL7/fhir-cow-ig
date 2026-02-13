#### Assumptions

- Physician requests 2 medications in one prescription
- Regulation determines that entire prescription is filled at one place. (Note that this does not constitute a dependency, and while a RequestGroup may be used, it is not required, since the Task is already grouping the actions to be taken from the different Requests.)   
- Transport mechanisms and infrastructure for exchanging data about `Prescription`, `Task` and `Dispense` are provided.

#### Example 
<figure>
  {% include ex4-meds-grouped-dispense.svg %}
</figure>