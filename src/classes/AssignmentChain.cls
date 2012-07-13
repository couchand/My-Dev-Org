public with sharing class AssignmentChain
{
	public abstract class AssignmentHandler
	{
		private AssignmentHandler successor;
		private Set<Id> applicableRecordTypeIds;
		
		public AssignmentHandler( AssignmentHandler successor, Set<Id> applicableRecordTypeIds )
		{
			this.successor = successor;
			this.applicableRecordTypeIds = applicableRecordTypeIds;
		}
		
		private Boolean isApplicable( Service_Request__c serviceRequest )
		{
			return applicableRecordTypeIds.contains( serviceRequest.RecordTypeId );
		}
		
		abstract protected void makeAssignments( List<Service_Request__c> serviceRequests );
		
		abstract public void assign( List<Service_Request__c> serviceRequests );
		//abstract public List<Round_Robin__c> getRecords();
	}
	
	public abstract class OpportunityAssigner extends AssignmentHandler
	{
		public OpportunityAssigner( AssignmentHandler successor, Set<Id> applicableRecordTypeIds )
		{
			super( successor, applicableRecordTypeIds );
		}
		
		public override void assign( List<Service_Request__c> serviceRequests )
		{
			Boolean assignHere = false;
			
			for( Service_Request__c serviceRequest : serviceRequests )
			{
				if( isApplicable( serviceRequest ) )
				{
					assignHere = true;
					break;
				}
			}
			
			if( assignHere )
			{
				makeAssignments( serviceRequests );
			}
			else
			{
				if( null != successor )
					successor.assign( serviceRequests );
			}
		}
	}
	
	public abstract class ServiceRequestAssigner extends AssignmentHandler
	{
		public ServiceRequestAssigner( AssignmentHandler successor, Set<Id> applicableRecordTypeIds )
		{
			super( successor, applicableRecordTypeIds );
		}
		
		public override void assign( List<Service_Request__c> serviceRequests )
		{
			List<Service_Request__c> requestsToAssign = new List<Service_Request__c>();
			List<Service_Request__c> requestsToPassOn = new List<Service_Request__c>();
			
			for( Service_Request__c serviceRequest : serviceRequests )
			{
				if( isApplicable( serviceRequest ) )
				{
					requestsToAssign.add( serviceRequest );
				}
				else
				{
					requestsToPassOn.add( serviceRequest );
				}
			}
			
			makeAssignments( requestsToAssign );
			
			if( null != successor )
				successor.assign( requestsToPassOn );
		}
	}
}