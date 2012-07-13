public with sharing class SObjectServices
{
	public static final String INFO_SLUG = 'SObjectInfo';
	
	public static Map<String, Schema.SObjectType> tokenCache
	{
		get
		{
			if( null == tokenCache )
			{
				tokenCache = Schema.getGlobalDescribe();
			}
			return tokenCache;
		}
	}
	
	public static Map<String, SObjectType__c> typeCache
	{
		get
		{
			if( null == typeCache )
			{
				typeCache = new Map<String, SObjectType__c>();
				
				for( SObjectType__c sObjectType : [SELECT Name FROM SObjectType__c] )
				{
					typeCache.put( sObjectType.Name, sObjectType );
				}
			}
			return typeCache;
		}
	}
	
	public static Map<String, Map<String, SObjectField__c>> fieldCache
	{
		get
		{
			if( null == fieldCache )
			{
				fieldCache = new Map<String, Map<String, SObjectField__c>>();
				
				for( SObjectField__c sObjectField : [SELECT Name, SObject__r.Name FROM SObjectField__c] )
				{
					if( !fieldCache.containsKey( sObjectField.SObject__r.Name ) )
					{
						fieldCache.put( sObjectField.SObject__r.Name, new Map<String, SObjectField__c>() );
					}
					fieldCache.get( sObjectField.SObject__r.Name ).put( sObjectField.Name, sObjectField );
				}
			}
			return fieldCache;
		}
	}
	
	public static SObject find( String objectName, Id objectId )
	{
		SObjectType__c objectType = typeCache.get( objectName );
		Map<String, SObjectField__c> objectFields = fieldCache.get( objectName );
		
		String query = 'SELECT ';
		
		for( String fieldName : objectFields.keySet() )
		{
			query += fieldName + ', ';
		}
		
		query = query.substring(0, query.length() - 2);
		
		query += ' FROM ' + objectName + ' WHERE Id = \'' + objectId + '\'';
		
		List<SObject> objectsFound = Database.query( query );
		
		if( objectsFound.isEmpty() )
			return null;
		
		return objectsFound[0];
	}
	
	public static SObject create( String objectName )
	{
		Schema.SObjectType objectToken = tokenCache.get( objectName );
		
		if( null == objectToken )
			return null; // @TODO: Raise Exception
		
		return objectToken.newSObject();
	}
	
	public class SObjectInfo
	{
		private String SObjectName;
		
		public SObjectInfo( String objectName )
		{
			SObjectName = objectName;
		}
		
		public SObjectType__c objectType
		{
			get
			{
				return typeCache.get( SObjectName );
			}
		}
		
		public Map<String, SObjectField__c> fields
		{
			get
			{
				return fieldCache.get( SObjectName );
			}
		}
	}
	
	private static testMethod void testClass()
	{
		Test.startTest();
		
			SObject newObj = create( 'Account' );
			newObj.put( 'Name', 'Test Account' );
			insert newObj;
			SObject obj = find( 'Account', newObj.Id );
			SObjectInfo objInfo = new SObjectInfo( 'Account' );
		
		Test.stopTest();
		
		// @TODO: implement test
	}
}