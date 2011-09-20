@isTest
private class TestListModel
{
	private static final Integer NUM_ENTRIES = 7;
	
	static testMethod void testGetEmptyEntryList()
	{
		ListModel c = new ListModel();
		
		Test.startTest();
			List<ListModel.Element> actualList = c.getList();
		Test.stopTest();
		
		System.assertNotEquals( null, actualList, 'The collection should return a list.' );
		System.assert( actualList.isEmpty(), 'An empty collection should return an empty list.' );
	}
	
	static testMethod void testSize()
	{
		ListModel c = new ListModel();
		
		for( Integer i = NUM_ENTRIES; i > 0; i-- )
		{
			c.add( new TestImplementation( i ) );
		}
		
		Test.startTest();
			Integer size = c.size();
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES, size, 'A collection should return its size.' );
	}
	
	static testMethod void testGetEntryList()
	{
		ListModel c = new ListModel();
		
		for( Integer i = NUM_ENTRIES; i > 0; i-- )
		{
			c.add( new TestImplementation( i ) );
		}
		
		Test.startTest();
			List<ListModel.Element> actualList = c.getList();
		Test.stopTest();
		
		System.assertNotEquals( null, actualList, 'The collection should return a list.' );
		System.assertEquals( NUM_ENTRIES, actualList.size(), 'A collection should return a list of the entries.' );
		
		Integer indexCounter = 0, itemCounter = NUM_ENTRIES;
		
		for( ListModel.Element entry : actualList )
		{
			System.assertEquals( indexCounter, entry.index, 'The entries should be returned in order.' );
			System.assertEquals( itemCounter, ((TestImplementation)entry).id, 'The default order should be the order the items are added.' );
			indexCounter += 1;
			itemCounter -= 1;
		}
	}
	
	static testMethod void testReorderList()
	{
		ListModel c = new ListModel();
		
		for( Integer i = NUM_ENTRIES; i > 0; i-- )
		{
			c.add( new TestImplementation( i ) );
		}
		
		List<Integer> newOrder = new List<Integer>();
		
		for( Integer i = NUM_ENTRIES - 1; i >= 0; i--)
		{
			newOrder.add(i);
		}
		
		Test.startTest();
			c.reorder( newOrder );
			List<ListModel.Element> actualList = c.getList();
		Test.stopTest();
		
		System.assertNotEquals( null, actualList, 'The collection should return a list.' );
		System.assertEquals( NUM_ENTRIES, actualList.size(), 'A collection should return a list of the entries.' );
		
		Integer indexCounter = 0, itemCounter = 1;
		
		for( ListModel.Element entry : actualList )
		{
			System.assertEquals( indexCounter, entry.index, 'The entries should be returned in order.' );
			System.assertEquals( itemCounter, ((TestImplementation)entry).id, 'The entries should be reordered by their indices.' );
			indexCounter += 1;
			itemCounter += 1;
		}
	}
	
	class TestImplementation extends ListModel.Element
	{
		private Integer i;
		
		public TestImplementation( Integer id )
		{
			i = id;
		}
		
		public Integer id
		{
			get
			{
				return i;
			}
		}
	}
}