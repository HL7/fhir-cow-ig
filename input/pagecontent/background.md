This implementation guide is meant to provide a shared-base on which FHIR workflows for orders, referrals, and transfers may be built.

### Goals
Our goal in creating basic guidance, even if not directly implementable, is to help initiatives focused on referrals, orders, and transfers align on core mechanisms and exchange patterns to facilitate faster and cheaper interoperability. We hope to do so by:
1. Reducing the number of decisions needed
2. Highlighting abstractions that allow development for one domain to apply to others
3. Creating shared nomenclature to help spec authors define and share goals quickly. 

IGs developed for particular care domains (such as social care referrals, durable medical equipment, nursing home placement, imaging, etc.) or for particular jurisdictions may assert conformance to this IG if they leverage a compatible representation of the status of a request for service and compatible exchange mechanismss.

### Referrals, Orders, and Transfers
Modern healthcare delivery includes a variety of stakeholders, settings, specialties, interventions, and equipment. This often leads to overloading of terms, and lack of understanding of commonalities among healthcare processes. One example of that is how the term `referral` is used.

One attempt to describe the different types of processes that may be called `referrals` can be as follows:

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
                <li>LTC - with functional status</li>
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
                <li>Authorization to see OB/MFM</li>
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

All of these workflows assume that some healthcare provider, while working with a patient, decides that some action should be taken by another provider or healthcare organization. The receiving party may or may not be allowed, based on the business agreements, to reject or to modify the request for service, and the initiating party may or may not expect to receive some information back during or after the service.

### Key Differences in Implementations Today:

In reviewing other locale and care-domain specific work, this IG's authors have noted two factors which frequently motivate the creation of new exchange specifications for orders and referrals. These are:
1. Considerations for minimizing data access
2. Accomodating interactions with systems that mayt not yet support robust (and highly available) FHIR servers

**Groups prioritizing (1)** have tended to focus on RESTful exchange and on minimizing the set of data which is first transmitted between the creator of a request for service and the potential performers of that service. This occasionally extends to the point of including no supporting information with the initial notification, and instead requiring that a potential fulfiller query for any information necessary to process the request. Often, these groups also provide guidance for controlling what a potential fullfiller may query within a data-category: this could incldue limiting a non-healthcare service provider to accessing only a subset of ServiceRequests, such as those related to transport assistance, or preventing service providers from querying about the volume of requests that were sent to their competitor, by allowing them to access service request data only for those patients for whom they have received a referral.

**Groups prioritizing (2)** often focus on FHIR Messaging, which leads to considerations similar to those in HL7 v2 around broadcast interfaces and whether to include all information a fulfiller _might_ need to process a request in the notification.

This guide aims to support both groups. This guide can be seen as providing a roadmap for those prioritizing (2) to move towards RESTful exchanges as their broader exchange ecosystems develop. This also reduces implementation burden for vendors (and therefore, lock-in and silos) by providing a data model which may be represented using either paradigm. Groups prioritizing (1) should be mindful that limiting access can require pre-coordination which leads to implementation complexity, and that, often, a specialist receiving a referral is in the best position to know what data is relevant. This guide provides a brief description in the Core Concepts page for how placers may optionally limit a service provider to accessing data only to those patients for whom they have received a referral. 

### Pre-Coordination Needed for Push-Based Exchanges
A core focus for this guide is describing how notifications may be communicated between the actors involved in an order, referral, or transfer, and providing guidance to help authors of more specific guides manage these notifications in a consistent way.

FHIR provides several mechanisms by which notifications may be sent between two actors. Regardless of the specific FHIR mechanism chosen, all 'push' based exchanges require pre-coordination to define:
* The endpoints to which content should be pushed.
* The events of interest for the exchange - e.g. the workflow steps at which notifications be sent between the parties
* The expected payload of the notifications, both in terms of structure and semantic content. For example - a notification may be sent between two parties that is entirely self-contained, and which implicitly communicates a notification ("a result has been generated for this patient") and it's content ("no abnormal findings found"). This is analogous to HL7 v2 exchanges. Alternatively, a notification might indicate "data is ready - retrieve the data when needed based on the pre-coordinated mechanism or content in this notification".   
* Operational business agreements - the actors involved in an exchange must agree to business practices, such as whether a fulfiller must confirm their ability to perform a service, when and how a placer may cancel or modify a request for service after a fulfiller has accepted it, etc. 
* Procedures for error correction and remediation - whether the sender or the receiver bears responsibility for addressing a given error, how to coordinate chart corrections, service desks, etc. 

Implementations may choose to address these in different ways. 

### Brief Survey of Mechanisms for Pushing FHIR Content 
This section is provided for context and provides a brief overview of mechanisms available to push content from one actor to antoehr via FHIR. 

**POST of a resource (RESTful FHIR Creates or Updates):**
* This mechanism may be used alongside others. It requires the availability of FHIR servers.
* Actors need to pre-coordinate where the FHIR resources of interest (serving as the source-of-truth) will be hosted within the exchange ecosystem, when the resources should be posted, who may update them, and under what circumstances.
* Note that posting of a resource may require more complex supporting transactions. For example, to POST a ServiceRequest, a client must first obtain the FHIR ID that will be used for ServiceRequest.subject (such as a Patient's FHIR ID on the target server).

**Batch or Transaction bundles:**
* These may operate similar to the RESTful Create and Update described above, but provide a mechanism for a client to submit several transactions as a set, which can reduce network traffic. This guide does not explore this option in detail.

**FHIR Messaging:**
* A bundle is sent between actors based on some Event. That bundle contains a MessageHeader resource and other resources of interest.
* There is no requirement with FHIR Messaging that the resources within a Message Bundle have an independent and persistent existence, or that they be surfaceable in response to a FHIR query.
* Messaging provides similar functionality to event-driven HL7 v2 exchanges, where the content of the messages to be exchanged are now resources rather than PID segments, ORC segments, etc. This mechanism therefore has similar considerations, like that the sender and receiver must make tight agreements about events of interest, message content, and identifiers. Senders should err on the side of sending content at a given event trigger that they expect the recipient *may* want, since there's no guarantee that a recipient can request or query for additional content later.
**FHIR Subscriptions:**
* These can also function in a manner similar to HL7 v2 (in which trading partners pre-coordinate events of interest, endpoints, and the content of messages). A Subscription may exist indicating that a party would like to receive content from a server when certain events occur. Upon these triggers, a subscription-notification bundle may be sent to the party desiring data.
* Subscriptions includes two additional features that are potentially relevant for order, referral, and transfer workflows. 
    * The first is that a data-holder may make a "SubscriptionTopic" available to which authorized data requestors may then subscribe for updates. This is not required, as record holders may choose instead to create subscriptions administratively and out-of-band, but can be helpful if both actors support it. Dynamic subscriptions allow a Data requestor to  specify their own endpoint and select their events of interest and desired data format for messages from a menu of options chosen by the data holder. 
    * The second is a standard mechanism for a data holder to indicate to a potential recipient how they could query for specific additional information later. For example, if a patient's insurance may change between the time a referral is created and when a service will be performed, subscriptions provide a way for a referrer to inform a fulfiller of how they can obtain the patient's Coverage information later, closer to when it is needed.    
bmsTest
