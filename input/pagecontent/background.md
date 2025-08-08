### Goals
This guide is intended to help specification authors working on Orders, Referrals, and Transfers workflows achieve interoperability more quickly and cost-effectively by:

* Highlighting abstractions that support reuse of functionality across care domains and jurisdictions
* Reducing ambiguity through proven workflow patterns
* Identifying key decision points
* Establishing shared terminology to streamline collaboration

### How Orders, Referrals, and Transfers Relate
Historically, these terms have been delineated by the extent to which responsibility for a patient's care was transitioned or delegated between providers. As care has become more collaborative, it is often challenging to draw bright line distinctions between these terms.  

To help with discussions, brief descriptions and examples of each term are provided below.

<table border="1" borderspacing="0" style='border: 1px solid black; border-collapse: collapse' class="table">
    <thead>
      <tr class="header">
        <th class="col-1">Transfer</th>
        <th class="col-1">Referral</th>
        <th class="col-1">Order</th>
      </tr>
    </thead>
    <tbody>
      <tr class="odd">
        <td>
          <ul>
            <li>Usually not service-specific</li>
            <li>Requestor usually does not expect an outcome after the coordination</li>
            <li>Usually changing primary responsibility for a patient's care, often with patient movement
              <ul>
                <li>Long-Term Care (LTC)- with functional status</li>
                <li>Burn Unit - with specific tests</li>
              </ul>
            </li>
            <li>Often includes a patient summary. May include a more specific `reason for transfer`</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>Usually more high level:
              <ul>
                <li>Imaging referral for knee pain</li>
                <li>Surgical Consult</li>
                <li>Referral for physical therapy</li>
                <li>Referral to psychiatry</li>
                <li>Authorization to see Obstetrics (OB)/Maternal-Fetal Medicine (MFM)</li>
              </ul>
            </li>
            <li>May be evaluative:
              <ul>
                <li>Consider for transport assistance</li>
              </ul>
            </li>
            <li>
              May not be authorized at the moment of creation (insurance, etc.)
            </li>
            <li>
              Recipients sometimes refuse
            </li>
          </ul>
        </td>
        <td>
          <ul>
            <li>Usually more specific:
              <ul>
                <li>X-Ray 3 view knee</li>
              </ul>
            </li>
            <li>General expectation is that the service will occur and the overall performer is known
              <ul>
                <li>Some lab in the network <em>will</em> perform this test</li>
              </ul>
            </li>
            <li><em>Usually</em> the recipient can't refuse to perform a service, although depending on the business agreements, they may be allowed to modify the request, such as by selecting a more specific service to perform. Additionally, fulfillers may indicate they are not able to fulfill the request for some reason, such as a specimen's condition or quantity.
            </li>
          </ul>
        </td>
      </tr>
    </tbody>
  </table>

These all involve a healthcare provider deciding that action should be taken by another provider or healthcare organization. The receiving party may or may not be allowed, based on the business agreements, to reject or to modify the request for service, and the initiating party may or may not expect to receive some information back during or after the service.

### Pre-Coordination Needed for Push-Based Exchanges
A core aim of this guide is to help specification authors manage notifications for orders, referrals, and transfers in a consistent way. 

FHIR provides several mechanisms by which notifications may be sent between two actors. Regardless of the specific FHIR mechanism chosen, all 'push' based exchanges require pre-coordination to define:
* Endpoints - where notifications should be sent
* Events of interest - which workflow steps trigger notifications 
* Payload expectations - both for structure and content. For example - a message may be sent between two parties that serves as both notification ("a result has been generated for this patient") and it's content ("no abnormal findings found"). This is analogous to HL7 v2 exchanges. Alternatively, a notification might indicate simply that data is available for retrieval if needed.   
* Operational agreements - including policies on request whether a Fulfiller must confirm their ability to fulfill a Request, when and how a Placer may cancel or modify a Request after it has been accepted, etc. 
* Error handling and remediation - responsibilities for correcting errors, coordinating chart updates, and involving support desks.

Implementers may approach these coordination points differently, but each must be addressed for reliable push-based exchange.

### Brief Survey of Mechanisms for Pushing FHIR Content 
This section provides context on the main FHIR-based mechanisms for pushing content between actors.

**RESTful POST of Resources (Creates or Updates)**
* This mechanism may be used alongside others. It requires the availability of FHIR servers.
* Actors must pre-coordinate where the definitive instances of shared FHIR resources will be hosted, when they should be exchanged, who can update them, and under what circumstances.
* Note that more complex transactions may be needed. For example, if a placer attempted to POST a ServiceRequest (which is not advised in this guide), the parties must agree on how to reference the patient; e.g. whether the client must use $match to obtain the recipient's Patient ID, or if the server will perform matching.

**Batch or Transaction bundles:**
* These may operate similar to the RESTful Create and Update described above, but provide a mechanism for a client to submit several transactions as a set, which can reduce network traffic. This guide does not explore this option in detail.

**FHIR Messaging:**
* Event-driven exchange using a Bundle with a <code>MessageHeader</code> and related resources.
* Resources in the message are not required to persist or be queryable.
* Messaging is conceptually similar to HL7 v2, requiring tight coordination on events, message content, and identifiers.
* Senders should include all potentially relevant information, as recipients may not be able to retrieve more later.

**FHIR Subscriptions:**
* These can also function in a manner similar to HL7 v2. A Subscription records that a party would like to receive content from a server on a specified channel when certain events occur. A <code>subscription-notification</code> bundle is sent when these triggers occur.
* Subscriptions provide two optional features that support order, referral, and transfer workflows: 
    * SubscriptionTopics: a data-holder MAY make a <code>SubscriptionTopic</code> available to which authorized data requestors may subscribe for updates. Such "dynamic subscriptions" let an actor specify their own endpoint, events of interest, and desired format from a menu of options chosen by the data holder. This is purely optional within Subscriptions: administrators may instead discuss updates out of band and manually configure Subscriptions, just as administrators do for HL7v2 interfaces today. 
    * Query guidance: <code>subscription-notifications</code> can include instructions for how a recipient may query for additional information later. For instance, if insurance coverage might change between when a referral is created and when service should be provided, the <code>subscription-notification</code> sent for the referral can guide a Fulfiller on how to retrieve updated Coverage data if or when it is needed later.    

