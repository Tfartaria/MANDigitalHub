/**
 * @File Name          : TestDataFactory.cls
 * @Description        : Contains methods to generate test data for test methods.
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
@IsTest
public class TestDataFactory {
    
    public static Account getAccount() {
		Account acct = new Account(
            Name = 'Test'+Integer.valueof((Math.random() * 100))
		);
		return acct;
    }
    
    public static Contact getContact(Account acct) {
		Contact contact = new Contact(
			AccountId = acct.Id,
			Email = 'merchMail@example.com',
			FirstName = 'Tname',
			LastName = 'Tsurname'+ Integer.valueof((Math.random() * 100))
		);
		return contact;
	}

    public static Lead getLead() {
		Lead lead = new Lead(
			LastName = 'TestLastName',
			Company = 'test Company',
			Email = 'testLead@example.com'
		);
		return lead;
    }
    
    public static PricebookEntry getStandardPricebookEntry(Product2 productRecord) {
		PricebookEntry standardPriceReader = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = productRecord.Id,
			UnitPrice = 50,
			IsActive = true
		);
		return standardPriceReader;
    }
    
    public static Pricebook2 getCustomPricebook() {
		Pricebook2 customPriceBook = new Pricebook2();
		customPriceBook.Name = 'customPriceBook';
		customPriceBook.IsActive = true;
		return customPriceBook;
	}

    public static PricebookEntry getCustomPrice(Product2 productRecord) {
		PricebookEntry customPriceReader = new PricebookEntry(
			Pricebook2Id = getCustomPricebook().Id,
			Product2Id = productRecord.Id,
			UnitPrice = 50,
			IsActive = true
		);
		return customPriceReader;
	}

    public static OrderItem getOrderItem(Order orderRecord, PricebookEntry customPricebookEntry) {
		OrderItem orderItemRecord = new OrderItem();
		orderItemRecord.OrderId = orderRecord.Id;
		orderItemRecord.PricebookEntryId = customPricebookEntry.Id;
		orderItemRecord.Quantity = 10;
		orderItemRecord.UnitPrice = 50;
		return orderItemRecord;
	}

    public static Product2 getTruckProduct() {
		Product2 truckProductRecord = new Product2(
            Name = 'Truck TGX',
            ExternalId__c = 'WMAH05ZZZ4B011671',
            Performance__c = 560,
            Tonnage__c = 18,
			ProductCode = 'TGX',
			Family = 'Truck',
			IsActive = true,
			RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId()
		);
		return truckProductRecord;
    }
    
    public static Product2 getServiceProduct(Product2 truckChildProduct) {
		Product2 serviceProductRecord = new Product2(
            Name = 'Truck TGX',
            ParentProduct__c = truckChildProduct.Id,
			ProductCode = 'TGX',
            Family = 'Service',
            Subscription__c = 'Yearly',
			IsActive = true,
			RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId()
		);
		return serviceProductRecord;
    }
    
    public static Order getOrder(Account acct, Contact contactRecord) {
		Order orderRecord = new Order();
		orderRecord.AccountId = acct.Id;
		orderRecord.EffectiveDate = Date.today();
		orderRecord.Status = 'Draft';
		return orderRecord;
    }
    

    public static void insertorderRecordSetUp(){
		Pricebook2 priceBook = getCustomPricebook();
		insert priceBook;

		Product2 truckProduct = getTruckProduct();
        insert truckProduct;
      
		PricebookEntry truckStandardPriceBookEntry = getStandardPricebookEntry(truckProduct);
		insert truckStandardPriceBookEntry;
  
        Product2 serviceProduct = getServiceProduct(truckProduct);
        insert serviceProduct;
        
        PricebookEntry serviceStandardPriceBookEntry = getStandardPricebookEntry(serviceProduct);
		insert serviceStandardPriceBookEntry;

		Account accountRecord = getAccount();
		insert accountRecord;

		Order orderRecord = new Order();
		orderRecord.AccountId = accountRecord.Id;
		orderRecord.Pricebook2Id = Test.getStandardPricebookId();
		orderRecord.Status = 'Draft';
		orderRecord.EffectiveDate = Date.today();
		insert orderRecord;

		OrderItem truckOrderItem = TestDataFactory.getOrderItem(orderRecord, truckStandardPriceBookEntry);
        insert truckOrderItem;

        OrderItem serviceOrderItem = TestDataFactory.getOrderItem(orderRecord, serviceStandardPriceBookEntry);
        insert serviceOrderItem;

	}

}
