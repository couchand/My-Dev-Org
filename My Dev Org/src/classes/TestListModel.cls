@isTest
private class TestListModel
{
	private static final Integer NUM_ENTRIES	= 7;
	private static final Integer AN_INDEX		= 4;
	private static final Integer ANOTHER_INDEX	= 2;
	private static final Integer END_INDEX		= NUM_ENTRIES - 1;
	
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
		ListModel c = createListModel();
		
		Test.startTest();
			Integer size = c.size();
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES, size, 'A collection should return its size.' );
	}
	
	static testMethod void testGetEntryList()
	{
		ListModel c = createListModel();
		
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
		ListModel c = createListModel();
		
		List<Integer> newOrder = new List<Integer>();
		
		for( Integer i = NUM_ENTRIES - 1; i >= 0; i--)
		{
			newOrder.add(i);
		}
		
		Test.startTest();
			c.reorder( newOrder );
			List<ListModel.Element> actualList = c.getList();
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES, c.size(), 'A collection should return a list of the entries.' );
		
		Integer indexCounter = 0, itemCounter = 1;
		
		for( ListModel.Element entry : actualList )
		{
			System.assertEquals( indexCounter, entry.index, 'The entries should be returned in order.' );
			System.assertEquals( itemCounter, ((TestImplementation)entry).id, 'The entries should be reordered by their indices.' );
			indexCounter += 1;
			itemCounter += 1;
		}
	}
	
	static testMethod void testRemoveElement()
	{
		ListModel c = createListModel();
		
		Test.startTest();
			TestImplementation actualElement = (TestImplementation)c.remove( AN_INDEX );
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES - 1, c.size(), 'One element should be removed' );
		System.assertEquals( NUM_ENTRIES - AN_INDEX, actualElement.id, 'The removed element should be returned.' );
		
		for( ListModel.Element entry : c.getList() )
		{
			System.assertNotEquals( NUM_ENTRIES - AN_INDEX, ((TestImplementation)entry).id, 'The removed element should be removed.' );
		}
	}
	
	static testMethod void testPutElement()
	{
		ListModel c = createListModel();
		
		Test.startTest();
			c.put( AN_INDEX, new TestImplementation( NUM_ENTRIES ) );
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES + 1, c.size(), 'One element should be inserted.' );
		
		ListModel.Element entry = c.getList()[AN_INDEX];
		System.assertEquals( NUM_ENTRIES, ((TestImplementation)entry).id, 'The element should be inserted in the right place.' );
	}
	
	static testMethod void testPutElementAtEnd()
	{
		ListModel c = createListModel();
		
		Test.startTest();
			c.put( NUM_ENTRIES, new TestImplementation( NUM_ENTRIES ) );
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES + 1, c.size(), 'One element should be inserted.' );
		
		ListModel.Element entry = c.getList()[NUM_ENTRIES];
		System.assertEquals( NUM_ENTRIES, ((TestImplementation)entry).id, 'The element should be inserted in the right place.' );
	}
	
	static testMethod void testMoveElement()
	{
		ListModel c = createListModel();
		
		Test.startTest();
			c.move( AN_INDEX, ANOTHER_INDEX );
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES, c.size(), 'The list should be the same size.' );
		
		ListModel.Element entry = c.getList()[ANOTHER_INDEX];
		ListModel.Element nextEntry = c.getList()[AN_INDEX];
		
		System.assertEquals( NUM_ENTRIES - AN_INDEX, ((TestImplementation)entry).id, 'The element should be moved to the right place.' );
		System.assertEquals( NUM_ENTRIES - AN_INDEX + 1, ((TestImplementation)nextEntry).id, 'The next element should moved back one place.' );
	}
	
	static testMethod void testMoveElementToEnd()
	{
		ListModel c = createListModel();
		
		Test.startTest();
			c.move( AN_INDEX, END_INDEX );
		Test.stopTest();
		
		System.assertEquals( NUM_ENTRIES, c.size(), 'The list should be the same size.' );
		
		ListModel.Element entry = c.getList()[END_INDEX];
		ListModel.Element nextEntry = c.getList()[AN_INDEX];
		
		System.assertEquals( NUM_ENTRIES - AN_INDEX, ((TestImplementation)entry).id, 'The element should be moved to the right place.' );
		System.assertEquals( NUM_ENTRIES - AN_INDEX - 1, ((TestImplementation)nextEntry).id, 'The next element should moved up one place.' );
	}
	
	static ListModel createListModel()
	{
		ListModel c = new ListModel();
		
		for( Integer i = NUM_ENTRIES; i > 0; i-- )
		{
			c.add( new TestImplementation( i ) );
		}
	
		return c;
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