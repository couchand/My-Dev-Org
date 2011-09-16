public with sharing class MyMap {

	public static Map<String,SObject> getMap( List<SObject> objects, String field )
	{
		Map<String, SObject> ret = new Map<String, SObject>();
		
		for ( SObject obj : objects )
			ret.put( (String)obj.get( field ), obj );
		
		return ret;
	}

}