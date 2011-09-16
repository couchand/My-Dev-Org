/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestHandleProductPriceChange {

    static testMethod void testPriceChange() {
/*
		Amazing_Sale__c sale = new Amazing_Sale__c(Type__c = 'Good');
		insert sale;
		
		Schlock__c[] products = new Schlock__c[]{
			new Schlock__c(Name = 'item 1', What_Is_It__c = 'test product 1', Value__c = 10, How_Many_Do_We_Have__c = 10),
			new Schlock__c(Name = 'item 2', What_Is_It__c = 'test product 2', Value__c = 10, How_Many_Do_We_Have__c = 10)
		};
		insert products;
		
		One_Thing__c[] items = new One_Thing__c[]{
			new One_Thing__c(Amazing_Sale__c = sale.id, Schlock__c = products[0].id, How_Many__c = 3),
			new One_Thing__c(Amazing_Sale__c = sale.id, Schlock__c = products[1].id, How_Many__c = 5)
		};
		insert items;
		
		products[0].Value__c = 20;
		products[1].Value__c = 1;
		
		Test.startTest();
		update products;
		Test.stopTest();
		
		items = [select id, What_s_It_Cost__c from One_Thing__c where id in :items];
		
		System.assertEquals(items[0].What_s_It_Cost__c, 10);
		System.assertEquals(items[1].What_s_It_Cost__c, 1);
*/		
    }

}