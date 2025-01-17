Alias: $fhir-types = http://hl7.org/fhir/fhir-types

Instance: example-laborder
Title: "Placer-assigned Lab order tracking with Task"
InstanceOf: ExampleScenario
Usage: #definition
* text
  * status = #additional
  * div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      <p> \n        <b> ExampleScenario - Lab order tracking with Task</b> \n        <a name=\"example-laborder\"> </a> \n      </p> \n      <div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\">\n        <p style=\"margin-bottom: 0px\">Resource ExampleScenario &quot;example-laborder&quot; </p> \n      </div> \n      <p> \n        <b> status</b> : draft\n      </p> \n      <p> \n        <b> purpose</b> : Purpose: this serves to demonstrate a scenario that uses service requests and Task resources to establish a handshake for order tracking.\n      </p> \n     \n      <img src=\"./examplescenario-example-laborder.png\" alt=\"ExampleScenario diagram - IHE MMA example\"/>\n    </div>"
* extension
  * url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
  * valueCode = #fhir
* name = "LabOrderTrackingWithTask"
//* title = "Lab order tracking with Task"
* status = #draft
* publisher = "HL7 International / FHIR Infrastructure"
* contact.telecom
  * system = #url
  * value = "http://www.hl7.org/Special/committees/fiwg"
//* description = "In this example, the clinician creates an order in the CPOE. Then a Task is created and updated by both the CPOE and the Lab system..."
* purpose = "Purpose: this serves to demonstrate a scenario that uses service requests and Task resources to establish a handshake for order tracking."
* actor[0]
  * actorId = "Clin"
  * type = #person
  * name = "Clinician"
  * description = "Clinician"
* actor[+]
  * actorId = "CPOE"
  * type = #entity
  * name = "CPOE"
  * description = "CPOE"
* actor[+]
  * actorId = "EMR"
  * type = #entity
  * name = "EMR"
  * description = "EMR"
* actor[+]
  * actorId = "LabMan"
  * type = #person
  * name = "Lab person"
  * description = "Lab Person"
* actor[+]
  * actorId = "Lab"
  * type = #entity
  * name = "Lab"
  * description = "Lab"
* instance[0]
  * resourceId = "req1"
  * resourceType = $fhir-types#ServiceRequest
  * name = "Request for a lab procedure"
  * description = "Bla"
  * version[0]
    * versionId = "req1-v1"
//    * name = "v1- initial"
    * description = "Initial order"
  * version[+]
    * versionId = "req1-v2"
//    * name = "v2 - in progress"
    * description = "Order in progress"
  * version[+]
    * versionId = "req1-v3"
//    * name = "v3 - completed"
    * description = "Order completed"
* instance[+]
  * resourceId = "task1"
  * resourceType = $fhir-types#Task
  * name = "Task"
  * description = "The task that handles the status updates..."
  * version[0]
    * versionId = "task1-v1"
//    * name = "v1 - created"
    * description = "Initially created"
  * version[+]
    * versionId = "task1-v2"
//    * name = "v2 - accepted"
    * description = "Accepted"
  * version[+]
    * versionId = "task1-v3"
//    * name = "v3 - in progress"
    * description = "In progress"
  * version[+]
    * versionId = "task1-v4"
//    * name = "v4 - completed"
    * description = "Completed"
* instance[+]
  * resourceId = "req.lab1"
  * resourceType = $fhir-types#ServiceRequest
  * name = "Internal lab request"
  * description = "Lab's internal request for the procedure"
  * version[0]
    * versionId = "req.lab1-v1"
//    * name = "v1 - created"
    * description = "Order in progress"
  * version[+]
    * versionId = "req.lab1-v2"
//    * name = "v2 - in progress"
    * description = "Order in progress"
  * version[+]
    * versionId = "req.lab1-v3"
//    * name = "v3 - completed"
    * description = "Order completed"
* process
  * title = "Lab order tracking with Task"
  * description = "Lab order, status updates handled with Task between CPOE, EMR and Lab systems"
  * step[0]
 //   * number = "1"
    * process
      * title = "Create order"
      * description = "New lab order"
      * step[0]
        * operation
          * number = "1.1"
          * name = "Make a call"
          * initiator = "Clin"
          * receiver = "LabMan"
      * step[+]
        * operation
          * number = "1.2"
          * name = "Create new EMR order"
          * initiator = "Clin"
          * receiver = "CPOE"
      * step[+]
        * operation
          * number = "1.3"
          * name = "Submit order to EMR"
          * initiator = "CPOE"
          * receiver = "EMR"
          * request
            * resourceId = "req1"
            * versionId = "req1-v1"
      * step[+]
        * operation
          * number = "1.4"
          * name = "Create new task "
          * initiator = "EMR"
          * receiver = "EMR"
          * request
            * resourceId = "task1"
            * versionId = "task1-v1"
      * step[+]
        * operation
          * number = "1.5"
          * name = "Send task to Lab"
          * initiator = "EMR"
          * receiver = "Lab"
          * request
            * resourceId = "task1"
            * versionId = "task1-v1"
    * pause = true
  * step[+]
//    * number = "2"
    * process
      * title = "Accept order"
      * description = "New task for handling order tracking"
      * step[0]
        * operation
          * number = "2.1"
          * name = "Accept task"
          * initiator = "LabMan"
          * receiver = "Lab"
      * step[+]
        * operation
          * number = "2.2"
          * name = "Task status = accepted"
          * initiator = "Lab"
          * receiver = "Lab"
          * request
            * resourceId = "task1"
            * versionId = "task1-v2"
      * step[+]
        * operation
          * number = "2.3"
          * name = "Create internal lab request"
          * initiator = "Lab"
          * receiver = "Lab"
          * request
            * resourceId = "req.lab1"
            * versionId = "req.lab1-v1"
      * step[+]
        * operation
          * number = "2.4"
          * name = "Send Task to EMR"
          * initiator = "Lab"
          * receiver = "EMR"
          * request
            * resourceId = "task1"
            * versionId = "task1-v2"
      * step[+]
        * operation
          * number = "2.5"
          * name = "Inform CPOE of Task status"
          * initiator = "EMR"
          * receiver = "CPOE"
          * request
            * resourceId = "task1"
            * versionId = "task1-v2"
  * step[+]
//    * number = "3"
    * process
      * title = "Initiate procedure"
      * description = "Procedure is initiated at the lab"
      * step[0]
        * operation
          * number = "3.1"
          * name = "Begin procedure"
          * initiator = "LabMan"
          * receiver = "Lab"
      * step[+]
        * operation
          * number = "3.2"
          * name = "Task status: in-progress"
          * initiator = "Lab"
          * receiver = "Lab"
          * request
            * resourceId = "task1"
            * versionId = "task1-v3"
      * step[+]
        * operation
          * number = "4.3"
          * name = "Internal lab request: in-progress"
          * initiator = "Lab"
          * receiver = "Lab"
          * request
            * resourceId = "req.lab1"
            * versionId = "req.lab1-v2"
      * step[+]
        * operation
          * number = "4.4"
          * name = "Send updated Task to EMR"
          * initiator = "Lab"
          * receiver = "EMR"
          * request
            * resourceId = "task1"
            * versionId = "task1-v3"
      * step[+]
        * operation
          * number = "4.5"
          * name = "Inform CPOE of Task status"
          * initiator = "EMR"
          * receiver = "CPOE"
          * request
            * resourceId = "task1"
            * versionId = "task1-v4"
      * step[+]
        * operation
          * number = "4.6"
          * name = "Order status: in-progress"
          * initiator = "CPOE"
          * receiver = "CPOE"
          * request
            * resourceId = "req1"
            * versionId = "req1-v2"
  * step[+]
//    * number = "4"
    * process
      * title = "Finish procedure"
      * description = "Procedure is finished"
      * step[0]
        * operation
          * number = "5.1"
          * name = "Finish procedure"
          * initiator = "LabMan"
          * receiver = "Lab"
      * step[+]
        * operation
          * number = "5.2"
          * name = "Task status = completed"
          * initiator = "Lab"
          * receiver = "Lab"
          * request
            * resourceId = "task1"
            * versionId = "task1-v2"
      * step[+]
        * operation
          * number = "5.3"
          * name = "Internal lab request: complete"
          * initiator = "Lab"
          * receiver = "Lab"
          * request
            * resourceId = "req.lab1"
            * versionId = "req.lab1-v2"
      * step[+]
        * operation
          * number = "5.4"
          * name = "Send updated Task to EMR"
          * initiator = "Lab"
          * receiver = "EMR"
          * request
            * resourceId = "task1"
            * versionId = "task1-v4"
      * step[+]
        * operation
          * number = "5.5"
          * name = "Inform CPOE of Task status"
          * initiator = "EMR"
          * receiver = "CPOE"
          * request
            * resourceId = "task1"
            * versionId = "task1-v4"
      * step[+]
        * operation
          * number = "5.6"
          * name = "Order status = completed"
          * initiator = "CPOE"
          * receiver = "CPOE"
          * request
            * resourceId = "req1"
            * versionId = "req1-v3"