public with sharing class Foobar
{
	public static Map<String, Schema.SObjectType> AR_types;
	
	public static Map<String, Map<Id, ActiveRecordBase>> AR_repository;
	
	private void ActiveRecord()
	{
		AR_types = Schema.getGlobalDescribe();
	}
}