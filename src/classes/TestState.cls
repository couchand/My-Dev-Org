/*
*  TestState
*/
@isTest
private class TestState
{
	private static final String TEST_STATE_SLUG = 'test.slug';

	private static User testUser
	{
		get
		{
			if( null == testUser )
			{
				testUser = TestingUtils.createUser( 'State', true );
			}
			return testUser;
		}
	}

	private static String generateTestString( String charac, Integer length )
	{
		String theString = '';

		for ( Integer strIndex = 0; strIndex < length; strIndex++ )
			theString += charac;

		return theString;

	}

	static testMethod void storeState()
	{
		String baseStateChunk = generateTestString( '1', State.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;

		for ( Integer testIndex = 2; testIndex < State.STATE_CHUNK_COUNT; testIndex++ )
			testState += baseStateChunk;

		Test.startTest();

			System.runAs( testUser )
			{
				State.storeState( new TestStateful( testState ) );
			}

		Test.stopTest();

		List<State__c> resolvedState = [ SELECT Id,
												state_chunk_1__c,
												state_chunk_2__c,
												state_chunk_3__c,
												state_chunk_4__c,
												state_chunk_5__c,
												state_chunk_6__c,
												state_chunk_7__c,
												state_chunk_8__c,
												state_chunk_9__c,
												state_chunk_10__c,
												Token__c
												FROM State__c
												WHERE OwnerId = :testUser.Id ];

		System.assertEquals( 1, resolvedState.size(), 'Only one state should have been created!' );
		System.assertEquals( testUser.Id + State.STATE_TOKEN_DELIM + TEST_STATE_SLUG, resolvedState[0].Token__c, 'Token should have been generated correctly.' );

		String fieldValueExpected = baseStateChunk;

		for ( Integer testIndex = 1; testIndex < State.STATE_CHUNK_COUNT; testIndex++ )
		{
			String resolvedFieldActual = String.valueOf( resolvedState[0].get( State.STATE_CHUNK_PREFIX + testIndex + '__c' ) );

			System.assertEquals( fieldValueExpected, resolvedFieldActual );
		}
	}

	static testMethod void ensureSingleState()
	{
		String baseStateChunk = generateTestString( '1', State.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;

		for ( Integer testIndex = 2; testIndex < State.STATE_CHUNK_COUNT; testIndex++ )
			testState += baseStateChunk;

		System.runAs( testUser )
		{
			State.storeState( new TestStateful( testState ) );
		}

		List<State__c> resolvedState = [ SELECT Id FROM State__c WHERE OwnerId = :testUser.Id ];

		System.assertEquals( 1, resolvedState.size(), 'Only one state should have been created!' );

		Test.startTest();

			System.runAs( testUser )
			{
				State.storeState( new TestStateful( testState ) );
			}

		Test.stopTest();

		resolvedState = [ SELECT Id, State_Token__c FROM State__c WHERE OwnerId = :testUser.Id ];

		System.assertEquals( 1, resolvedState.size(), 'Only one state should have been created!' );
	}

	static testMethod void retrieveState()
	{
		String stateChunkString = generateTestString( 'a', State.TEXT_UPPER_LIMIT );

		State__c testState = new State__c( state_chunk_1__c = stateChunkString,
																 state_chunk_2__c = stateChunkString,
																 state_chunk_3__c = stateChunkString,
																 state_chunk_4__c = stateChunkString,
																 state_chunk_5__c = stateChunkString,
																 state_chunk_6__c = stateChunkString,
																 state_chunk_7__c = stateChunkString,
																 state_chunk_8__c = stateChunkString,
																 state_chunk_9__c = stateChunkString,
																 state_chunk_10__c = stateChunkString,
																 Index__c = 0,
																 Token__c = testUser.Id + State.STATE_TOKEN_DELIM + TEST_STATE_SLUG );

																// ^ This is what a State Token looks like.

		insert testState;

		TestStateful resolvedState = new TestStateful();

		Test.startTest();

			System.runAs( testUser )
			{
				State.retrieveState( resolvedState );
			}

		Test.stopTest();

		System.assertEquals( State.STATE_CHUNK_COUNT * State.TEXT_UPPER_LIMIT, resolvedState.getTestData().length() );
	}

	static testMethod void testStoreLongState()
	{
		String baseStateChunk = generateTestString( '1', State.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;

		for ( Integer testIndex = 0; testIndex < State.STATE_CHUNK_COUNT + 2; testIndex++ )
			testState += baseStateChunk;

		Test.startTest();

			System.runAs( testUser )
			{
				State.storeState( new TestStateful( testState ) );
			}

		Test.stopTest();

		List<State__c> resolvedState = [ SELECT Id,
												state_chunk_1__c,
												state_chunk_2__c,
												state_chunk_3__c,
												state_chunk_4__c,
												state_chunk_5__c,
												state_chunk_6__c,
												state_chunk_7__c,
												state_chunk_8__c,
												state_chunk_9__c,
												state_chunk_10__c,
												Token__c, Index__c
												FROM State__c
												WHERE OwnerId = :testUser.Id
												ORDER BY Index__c ];

		System.assertEquals( 2, resolvedState.size(), 'The long state should have been split' );
		System.assertEquals( 0, resolvedState[0].Index__c, 'The index number of the state should be set.' );
		System.assertEquals( testUser.Id + State.STATE_TOKEN_DELIM + TEST_STATE_SLUG, resolvedState[0].Token__c, 'Token should have been generated correctly.' );
		System.assertEquals( 1, resolvedState[1].Index__c, 'The index number of the state should be set.' );
		System.assertEquals( testUser.Id + State.STATE_TOKEN_DELIM + TEST_STATE_SLUG, resolvedState[1].Token__c, 'Token should have been generated correctly.' );

		String fieldValueExpected = baseStateChunk;

		for ( Integer testIndex = 1; testIndex < State.STATE_CHUNK_COUNT; testIndex++ )
		{
			String resolvedFieldActual = String.valueOf( resolvedState[0].get( State.STATE_CHUNK_PREFIX + testIndex + '__c' ) );

			System.assertEquals( fieldValueExpected, resolvedFieldActual );
		}
		
		for ( Integer testIndex = 1; testIndex < 4; testIndex++ )
		{
			String resolvedFieldActual = String.valueOf( resolvedState[1].get( State.STATE_CHUNK_PREFIX + testIndex + '__c' ) );

			System.assertEquals( fieldValueExpected, resolvedFieldActual );
		}
		
		for ( Integer testIndex = 4; testIndex < State.STATE_CHUNK_COUNT; testIndex++ )
		{
			String resolvedFieldActual = String.valueOf( resolvedState[1].get( State.STATE_CHUNK_PREFIX + testIndex + '__c' ) );

			System.assertEquals( null, resolvedFieldActual );
		}
	}

	static testMethod void testFlowLongState()
	{
		String baseStateChunk = generateTestString( '1', State.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;
		TestStateful actualState = new TestStateful();

		for ( Integer testIndex = 0; testIndex < State.STATE_CHUNK_COUNT; testIndex++ )
			testState += baseStateChunk;

		testState += '12';

		Test.startTest();

			System.runAs( testUser )
			{
				State.storeState( new TestStateful( testState ) );
				State.retrieveState( actualState );
			}

		Test.stopTest();

		System.assert( testState.equals( actualState.getTestData() ), 'The state should store and retrieve properly.' );
	}

	public class TestStateful implements State.IStateful
	{
		private String testData;

		public TestStateful()
		{
			this('');
		}

		public TestStateful( String testData )
		{
			this.testData = testData;
		}

		public String getTestData()
		{
			return testData;
		}

		public String getStateToken()
		{
			return UserInfo.getUserId() + State.STATE_TOKEN_DELIM + TEST_STATE_SLUG;
		}

		public String serialize()
		{
			return testData;
		}

		public void deserialize( String state )
		{
			testData = state;
		}
	}

	private static testMethod void testUserSObject_Valid()
	{
		Contact testLead = new Contact( FirstName = 'testing', LastName = 'lead' );
		insert testLead;

		TestUserSObject actualState = new TestUserSObject( new Contact( Id = testLead.Id ) );

		Test.startTest();

			System.runAs( testUser )
			{
				State.storeState( new TestUserSObject( testLead ) );
				State.retrieveState( actualState );
			}

		Test.stopTest();

		System.assertEquals( testLead, actualState.getSObject(), 'The state should store and retrieve properly.' );
	}

	private static testMethod void testUserSObject_OtherUser()
	{
		Contact testLead = new Contact( FirstName = 'testing', LastName = 'lead' );
		insert testLead;
		State.storeState( new TestUserSObject( testLead ) );

		TestUserSObject actualState = new TestUserSObject( new Contact( Id = testLead.Id ) );

		Exception actualException;

		Test.startTest();

			System.runAs( testUser )
			{
				try
				{
					State.retrieveState( actualState );
				}
				catch( Exception e )
				{
					actualException = e;
				}
			}

		Test.stopTest();

		System.assertNotEquals( null, actualException, 'A State Exception should be thrown if a user has no state' );
		System.assertEquals( State.STATE_NOT_FOUND, actualException.getMessage(), 'The Exception should be a State Not Found exception' );
	}

	public class TestUserSObject extends State.UserSObject
	{
		public TestUserSObject( SObject anSObject )
		{
			super( 'test', anSObject );
		}
	}
}
