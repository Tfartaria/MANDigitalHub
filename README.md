# MAN Digital Hub - Salesforce Challenge

This guide explains how this challenge was developed.

## Part 1: Sales Process to "Lions Truck INC"


### Trucks and services products:  
To ensure the details of the trucks and services are available in the Product Object: 
- Two record types: "Product" and "Service"
- New fields to store the details of the truck: Performance__c, Tonnage__c
- New fields to store the details of the service: Subscription__c, ParentProduct__c
- Validation Rule to ensure a Service product has a Parent Product: Product_ServiceWithParentProduct


### A service can only be sold with truck and 1:1 relation: 

To ensure this requirement is implemented in the Order Object was developed:
- New field to store the error message: ErrorMessage__c
- Trigger on the OrderItem (after insert, update and delete) to populate the field ErrorMessage on the related order, if the order has only services as products, or if there is any service without the related truck. The two messages are: "Please add the truck associated with the service." and "Is not allowed to order one service without the related truck. Ensure you have only one service per truck.".
TR_Order, TH_Order, SM_OrderProductValidation, DM_Order
- Lightning Web Component to display the error message in the Order Page Layout: lwc_OrderMessageDisplay
- Validation Rule to ensure the status of the order can't be changed if the error message field is populated: Order_ReviewErrorMessage


To ensure this requirement is implemented in the Opportunity Object was developed:
- New field to store the error message: ErrorMessage__c
- Trigger on the OpportunityLineItem (after insert, update and delete) to populate the field ErrorMessage on the related order, if the order has only services as products, or if there is any service without the related truck. The two messages are: "Please add the truck associated with the service." and "Is not allowed to order one service without the related truck. Ensure you have only one service per truck.".
TR_Opportunity, TH_Opportunity, SM_OpportunityProductValidation, DM_Opportunity
- Lightning Web Component to display the error message in the Order Page Layout: lwc_OpportunityMessageDisplay
- Validation Rule to ensure the status of the order can't be changed if the error message field is populated: Opportunity_ReviewErrorMessage


### The sold trucks must be stored as Assets
To ensure this requirement is implemented was developed:
- Trigger on the Opportunity Object to create assets  for each truck of a 'closed - won' opportunity: TR_Opportunity, TH_Opportunity, DM_Opportunity


### KPI's for the sales process and dashboard for sales management
- Defined the Win/Loss Rate:
  - Win Ratio is the percentage of opportunities closed that sales rep won
  - Loss Ratio is the percentage of opportunities closed that the sales rep lost
- Dashboard built with the following reports: 
  - Leads By Source
  - Open Opportunities
  - Closed Opportunities
  - Assets By Products
  - Win/Loss Rate

## Part 2: External Data

### Integrate the backend service JOINTHEDIGITALHUB provided and enrich the asset with service data

- New field ExternalId__c, on the Product Object to identify the truck on the backend service
- New field Country__c on the Asset Object to identify the country of the truck
- Set a Named Credential to store the URL, client-id, client-secret of the backend service
- Set a Custom Setting to store the global unique identifier (guid)
- Develop apex classes to access to the backend service:
  - WS_DigitalHub: this class should be used to access JOINTHEDIGITALHUB web service. 
  - WS_DigitalHubService: to store methods that perform HTTP callouts to JOINTHEDIGITALHUB 
  - WS_DigitalHubSchema: to store classes representing JOINTHEDIGITALHUB data model
- Trigger on the Asset Object (after insert) to run a Future Method to retrieve data from the backend service through WS_DigitalHub and populate the asset if the Vehicle Identification Number (vin) matches the external Id of the product of the asset.
TR_Asset, TH_Asset, SM_Asset


