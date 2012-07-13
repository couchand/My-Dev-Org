@isTest
private class TestAssignmentChain
{
	static Opportunity testOpp;
	static List<Service_Request__c> testServiceRequests;
	
	static final Id RECORD_TYPE_1_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Type_I' AND SObjectType = 'Service_Request__c'].Id;
	static final Id RECORD_TYPE_2_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Type_II' AND SObjectType = 'Service_Request__c'].Id;
	static final Id RECORD_TYPE_3_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Type_III' AND SObjectType = 'Service_Request__c'].Id;
	
	static final Integer NUM_SERVICE_REQUESTS = 12;
	
	static void setup()
	{
		testOpp = new Opportunity( Name = 'Test Opp', StageName = 'Open', CloseDate = Date.today() );
		insert testOpp;
		
		testServiceRequests = new List<Service_Request__c>();
		
		for( Integer i = 0; i < NUM_SERVICE_REQUESTS; i += 2 )
		{
			Service_Request__c aServiceRequest = new Service_Request__c();
			
			aServiceRequest.RecordTypeId = RECORD_TYPE_1_ID;
			aServiceRequest.Opportunity__c = testOpp.Id;
			aServiceRequest.Assigned__c = false;
			
			testServiceRequests.add( aServiceRequest );
			
			Service_Request__c anotherServiceRequest = new Service_Request__c();
			
			anotherServiceRequest.RecordTypeId = RECORD_TYPE_2_ID;
			anotherServiceRequest.Opportunity__c = testOpp.Id;
			anotherServiceRequest.Assigned__c = false;
			
			testServiceRequests.add( anotherServiceRequest );
		}
		
		/*insert testServiceRequests;
		
		testServiceRequests = [SELECT Id, RecordType.Id FROM Service_Request__c WHERE Id IN :testServiceRequests];*/
	}
	
	static testMethod void testAssignByOpportunityFirst()
	{
		setup();
		
		TestOpportunityAssigner testOppAssignerSecond = new TestOpportunityAssigner( null, new Set<Id>{ RECORD_TYPE_1_ID }, '2' );
		TestOpportunityAssigner testOppAssignerFirst = new TestOpportunityAssigner( testOppAssignerSecond, new Set<Id>{ RECORD_TYPE_2_ID }, '1' );
		
		Test.startTest();
		
			testOppAssignerFirst.assign( testServiceRequests );
		
		Test.stopTest();
		
		System.assertEquals( NUM_SERVICE_REQUESTS, testServiceRequests.size() );
		
		for( Service_Request__c actualServiceRequest : testServiceRequests )
		{
			System.assert( actualServiceRequest.Assigned__c );
			System.assertEquals( '1', actualServiceRequest.Assigned_To__c );
		}
	}
	
	static testMethod void testAssignByOpportunitySecond()
	{
		setup();
		
		TestOpportunityAssigner testOppAssignerSecond = new TestOpportunityAssigner( null, new Set<Id>{ RECORD_TYPE_1_ID }, '2' );
		TestOpportunityAssigner testOppAssignerFirst = new TestOpportunityAssigner( testOppAssignerSecond, new Set<Id>{ RECORD_TYPE_3_ID }, '1' );
		
		Test.startTest();
		
			testOppAssignerFirst.assign( testServiceRequests );
		
		Test.stopTest();
		
		System.assertEquals( NUM_SERVICE_REQUESTS, testServiceRequests.size() );
		
		for( Service_Request__c actualServiceRequest : testServiceRequests )
		{
			System.assert( actualServiceRequest.Assigned__c );
			System.assertEquals( '2', actualServiceRequest.Assigned_To__c );
		}
	}
	
	static testMethod void testAssignByServiceRequest()
	{
		setup();
		
		TestServiceRequestAssigner testSRAssignerSecond = new TestServiceRequestAssigner( null, new Set<Id>{ RECORD_TYPE_1_ID }, '2' );
		TestServiceRequestAssigner testSRAssignerFirst = new TestServiceRequestAssigner( testSRAssignerSecond, new Set<Id>{ RECORD_TYPE_2_ID }, '1' );
		
		Test.startTest();
		
			testSRAssignerFirst.assign( testServiceRequests );
		
		Test.stopTest();
		
		System.assertEquals( NUM_SERVICE_REQUESTS, testServiceRequests.size() );
		
		Integer numType1 = 0, numType2 = 0;
		
		for( Service_Request__c actualServiceRequest : testServiceRequests )
		{
			System.assert( actualServiceRequest.Assigned__c );
			
			if( RECORD_TYPE_1_ID == actualServiceRequest.RecordTypeId )
				numType1++;
			else
				numType2++;
		}
		
		System.assertEquals( NUM_SERVICE_REQUESTS / 2, numType1 );
		System.assertEquals( NUM_SERVICE_REQUESTS / 2, numType2 );
	}
	
	class TestOpportunityAssigner extends AssignmentChain.OpportunityAssigner
	{
		private String myName;
		
		public TestOpportunityAssigner( AssignmentHandler successor, Set<Id> applicableRecordTypeIds, String name )
		{
			super( successor, applicableRecordTypeIds );
			
			myName = name;
		}
		
		public override void makeAssignments( List<Service_Request__c> serviceRequests )
		{
			for( Service_Request__c serviceRequest : serviceRequests )
			{
				serviceRequest.Assigned__c = true;
				serviceRequest.Assigned_To__c = myName;
			}
		}
	}
	
	class TestServiceRequestAssigner extends AssignmentChain.ServiceRequestAssigner
	{
		private String myName;
		
		public TestServiceRequestAssigner( AssignmentHandler successor, Set<Id> applicableRecordTypeIds, String name )
		{
			super( successor, applicableRecordTypeIds );
			
			myName = name;
		}
		
		public override void makeAssignments( List<Service_Request__c> serviceRequests )
		{
			for( Service_Request__c serviceRequest : serviceRequests )
			{
				serviceRequest.Assigned__c = true;
				serviceRequest.Assigned_To__c = myName;
			}
		}
	}
}