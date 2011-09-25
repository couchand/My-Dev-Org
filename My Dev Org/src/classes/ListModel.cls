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
	
	public Element remove( Integer index )
	{
		return remove( index, true );
	}
	
	private Element remove( Integer index, Boolean reindex )
	{
		Element theEl = theList.remove( index );
		
		if( reindex ) reindex();
		
		return theEl;
	}
	
	public void put( Integer index, Element newEl )
	{
		put( index, newEl, true );
	}
	
	private void put( Integer index, Element newEl, Boolean reindex )
	{
		if( size() == index )
			add( newEl );
		else
		{
			theList.add( index, newEl );
			if( reindex ) reindex();
		}
	}
	
	public void move( Integer fromIndex, Integer toIndex )    
	{
		put( toIndex, remove( fromIndex, false ), false );
		reindex();
	}
	
	public List<Element> getList()
	{
		return theList;
	}
	
	private void reindex()
	{
		for( Integer i = size() - 1; i >= 0; i-- )
		{
			theList[i].index = i;
		}
	}
	
	public abstract class Element
	{
		public Integer index{ get; private set; }
	}
}