public with sharing class ListModel
{
	private List<Element> theList;
	
	public ListModel()
	{
		theList = new List<Element>();
	}
	
	public void add( Element c )
	{
		c.index = theList.size();
		theList.add( c );
	}
	
	public Integer size()
	{
		return theList.size();
	}
	
	public void reorder( List<Integer> newOrder )
	{
		List<Element> newList = theList.clone();
		theList = new List<Element>();
		
		for( Integer anIndex : newOrder )
		{
			add( newList.get( anIndex ) );
		}
	}
	
	public List<Element> getList()
	{
		return theList;
	}
	
	public abstract class Element
	{
		public Integer index{ get; private set; }
	}
}