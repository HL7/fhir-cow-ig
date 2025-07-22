This page describes how the FHIR exchanges modeled in this implementation guide compare with traditional HL7 v2 Orders and Results (ORM/ORU) exchanges.  Making data available for query and managing 'state' across servers may introduce complexity compared to existing HL7 v2 exchanges. 

### Format Comparison:

#### Traditional HL7 v2 Message:
In a traditional HL7 v2 message the 'notification' of an event carries with it the content necessary to process that event. A standard HL7 v2 Order message might look like the below:

```
MSH|^~\&|HARTFORD CLINIC||||20250721221212|RISTECHMAM|ORM^O01|334310.49|T
PID|1||202751^^^EPI^MR||TEST^JULIE^^^^^D||19660319|F||White|1818 UNIVERSITY AVE,^^MADISON^WI^53703^US^PERM^^DANE|DANE|(608)251-9999^P^H^^^608^2519999|||M||29100|806-26-7615|||NOT HISPANIC
PV1|1|OP|^^^^^^^^EMH BREAST IMAGING^^||||1000^FAMILY MEDICINE^PHYSICIAN^^^^^^PROVID^^^^PROVID|1000^FAMILY MEDICINE^PHYSICIAN^^^^^^PROVID^^^^PROVID|||||||||||29100|||||||||||||||||||||||||20180507110328|||||||V
ORC|NW|901911^EPC|199||Arrived||^^^^^R||20250721221212|RISTECHMAM^RADIOLOGY^BREAST^IMAGING TECHNOLOGIST^||1000^FAMILY MEDICINE^PHYSICIAN^^^^^^PROVID^^^^PROVID|^^^^^^^^EMH BREAST IMAGING|(555)555-5555^^^^^555^5555555|||||||||||||||I
OBR|1|901911^EPC|199|IMG605^BI MAMMOGRAM SCREENING BILATERAL^IMGEAP|R|20180507110329|||||Anc Perform|||||1000^FAMILY MEDICINE^PHYSICIAN^^^^^^PROVID^^^^PROVID|(555)555-5555^^^^^555^5555555|||||||MG|Arrived||^^^^^R|||||||||20180507110500
ZPF|1|BI^IMG BI PROCEDURES|||||^^^^^^^^EMH BREAST IMAGING
PRT|1|SP||OPO||||EMH Medical Clinic^^urn:examp:cec.play^^^EPC^XX^^^urn:examp:cec.play
DG1|1|I10|Z12.31^Encounter for screening mammogram for malignant neoplasm of breast^I10|Encounter for screening mammogram for malignant neoplasm of breast||W
```

Breaking this down, the message:
* Includes a message header segment (MSH) that indicates the type of message (an ORM), information about the sender of the message, the time the message was sent, etc.
* Contains details on the requested service (the OBR - Observation Request). The Common Order segment (ORC) indicates that this message is for a new order.
* Gives that order context via identifiers for the patient the ordr relates to (in PID), identifiers for the patient's visit (in PV1), and information related to the diagnosis that gave rise to the request (in DG1). 

#### Comparison to a FHIR Message:
Although this Implementation Guide does not define specific message bundles,  it is easy to imagine how a [FHIR message bundle]([url](https://hl7.org/fhir/messaging.html)) similar to the HL7 v2 message could be constructed.

```
Bundle 
  * type == message
{
MessageHeader:
  * event == New-Order
  * source == HARTFORD Clinic
  * focus:
      * Patient JULIE TEST
      * Task 1234
      * ServiceRequest 4567
      * .
      * .
Patient Julie Test:
  * identifier:
        * value == 202751
        * system == EPI

Task 1234:
  * focus == ServiceRequest 4567
  * status == Requested
  * .

ServiceRequest 4567:
  * identifier == 901911
  * code: 26175-0 MG Breast - bilateral screening
  * ,
}
```
This results in an overall 'package' of informatoin that is in many respects analagous to the HL7 v2 message, though parties must make a substantial effort to coordinate the details. 

#### Comparison to a Subscription-Status Notification:
An analagous 'package' of information can be communicated via a [Subscription framework]([url](https://hl7.org/fhir/subscriptions.html)). The only real distinction is that Subscriptions lend themselves to the idea that FHIR servers
are available, and that some information may then be retrievable 'restfully'. This creates an option to have a notification reference content, without necessarily including all of that content in the bundle. 

Alternatively, a Subscription-Status notification could also be used to send a full payload with the notification. 

```
Bundle
  * type == subscription-notification

{
SubscriptionStatus:
  * status == active
  * type == event-notification
  * subscription == 334310
  * notificationEvent:
        * eventNumber == 49
        * focus == Task 1234
        * related-query == ServiceRequest 4567
        * . 
  * NotificationAuthorizationHint: abc9876
  * .

}
```

### Where the formats diverge:
FHIR allows decoupling the notification of an event from communication of the details of that event, as the Subscription example shows. When FHIR servers are available, recipients of a notification can attempt to query
if they would like to obtain more information about an event, and senders may provide 'hints' to help the recipient find content that is likely of interest. 

### Suggestions for Use:
* TODO
