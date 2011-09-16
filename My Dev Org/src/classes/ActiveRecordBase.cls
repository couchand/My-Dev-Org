public abstract with sharing class ActiveRecordBase implements ActiveRecordSObject
{
	/*public interface Translator
	{
		String tableNameFromInstance( ActiveRecordBase instance );
		ActiveRecordBase instanceFromTableName( String tableName );
	}*/
	public interface ActiveRecordSObject
	{
		String SObjectName();
	}
	
	//abstract static String theString();
	/*public virtual String SObjectName()
	{
		return 'ActiveRecordBase_NotAnSObject';
	}*/
	public static String SObjectName = '';
	
	public static final List<String> STANDARD_FIELDS_TO_IGNORE = new List<String>
	{
		'isdeleted',
		'createddate',
		'systemmodstamp',
		'ownerid',			// maybe important?
		'lastmodifiedbyid',	//ditto?
		'createdbyid',
		'lastmodifieddate'
	};
	
	//public static virtual String SObjectName();
	
	private static Schema.SObjectType AR_type;
	
	private static Map<String,Schema.SObjectField> AR_fields;
	
	public static ActiveRecordBase find_by_id( Id theId )
	{
		if ( null == SObjectName )
		{
			//TODO: throw type error
			return null;
		}
		if ( null == AR_type )
		{
			AR_type = ActiveRecord.AR_types.get( SObjectName );
		}
		if ( null == AR_fields )
		{
			AR_fields = AR_type.getDescribe().fields.getMap();
		}
		
		if ( !ActiveRecord.AR_repository.containsKey( SObjectName ) )
		{
			ActiveRecordBase theObject = find_by_id_kernel( theId );
			
			Map<Id, ActiveRecordBase> newMap = new Map<Id,ActiveRecordBase>();
						
			newMap.put( theId, theObject );
			
			ActiveRecord.AR_repository.put( SObjectName, newMap );
			
			return theObject;
		}
		else
		{
			Map<Id, ActiveRecordBase> oldMap = ActiveRecord.AR_repository.get( SObjectName );
			
			if ( !oldMap.containsKey( theId ) )
			{
				ActiveRecordBase theObject = find_by_id_kernel( theId );
				
				oldMap.put( theId, theObject );
				
				return theObject;
			}
			else
			{
				return oldMap.get( theId );
			}
				
		}
	}
	
	private static ActiveRecordBase find_by_id_kernel( Id theId )
	{
		return null;
	}
	
	public static Boolean value;
	public static Boolean isTrue()
	{
		/*Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		
		System.debug( 'hi!!!!!!!!!');
		
		for( String objectName : gd.keySet() )
		{
			System.debug( '++++' + objectName );
			
			Map<String, Schema.SObjectField> fieldMap = gd.get( objectName ).getDescribe().fields.getMap();
			
			for( String fieldName : fieldMap.keySet() )
			{
				Schema.DescribeFieldResult fd = fieldMap.get( fieldName ).getDescribe();
				System.debug( '-----------' + fieldName + ' ' + fd.getLabel() );
			}
		}*/
		return ( null != value ) ? value : ( value=false );
	}
	public static void setValue()
	{
		value = true;
	}
	
	private void ActiveRecordBase()
	{
	}
	
	public Object get(String fieldName)
	{
		return fieldName;
	}
}