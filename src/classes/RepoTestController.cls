public class RepoTestController
{
	public SObjectType__c obj { get; set; }

	private MergingSObjectRepository myRepo = new MergingSObjectRepository();

	public void load()
	{
		Id theId = ApexPages.currentPage().getParameters().get('id');

		obj = (SObjectType__c)myRepo.find( theId );
	}

	public void save()
	{
		try
		{
			myRepo.save( obj );
		}
		catch( Exception e )
		{
			ApexPages.addMessages( e );
		}
	}
}