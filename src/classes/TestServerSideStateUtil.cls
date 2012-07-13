/* ServerSideStateUtilTest
*
* This class is related to Order Prioritization functionality
* This test class tests functionality belonging to ServerSideStateUtil
*
* 2011-12-05: Case# 00171892 / Michael Ng & William Saunders - Bluewolf
* 	Inital development of functionality
*/
@isTest
private class TestServerSideStateUtil {

	private static final String TEST_STATE_SLUG = 'test.slug';

	private static User testUser;

	static {

		testUser = TestUtils.getTestUser( 'TUser', 'Standard User' );

		System.runAs( TestUtils.ADMIN_USER )
		{
			insert testUser;
		}

	}

	private static String generateTestString( String charac, Integer length ) {

		String theString = '';

		for ( Integer strIndex = 0; strIndex < length; strIndex++ )
			theString += charac;

		return theString;

	}

	static testMethod void storeState() {

		String baseStateChunk = generateTestString( '1', ServerSideStateUtil.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;

		for ( Integer testIndex = 2; testIndex < ServerSideStateUtil.STATE_CHUNK_COUNT; testIndex++ )
			testState += baseStateChunk;

		Test.startTest();

			System.runAs( testUser ) {

				ServerSideStateUtil.storeState( UserInfo.getUserId(), TEST_STATE_SLUG, testState );

			}

		Test.stopTest();

		List<Serverside_State__c> resolvedState = [ SELECT Id,
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
												State_Token__c
												FROM Serverside_State__c
												WHERE OwnerId = :testUser.Id ];

		System.assertEquals( 1, resolvedState.size(), 'Only one state should have been created!' );

		String fieldValueExpected = baseStateChunk;

		for ( Integer testIndex = 1; testIndex < ServerSideStateUtil.STATE_CHUNK_COUNT; testIndex++ ) {

			String resolvedFieldActual = String.valueOf( resolvedState[0].get( ServerSideStateUtil.STATE_CHUNK_PREFIX + testIndex + '__c' ) );

			System.assertEquals( fieldValueExpected, resolvedFieldActual );

		}

	}

	static testMethod void ensureSingleState() {

		String baseStateChunk = generateTestString( '1', ServerSideStateUtil.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;

		for ( Integer testIndex = 2; testIndex < ServerSideStateUtil.STATE_CHUNK_COUNT; testIndex++ )
			testState += baseStateChunk;

		System.runAs( testUser ) {

			ServerSideStateUtil.storeState( UserInfo.getUserId(), TEST_STATE_SLUG, testState );

		}

		List<Serverside_State__c> resolvedState = [ SELECT Id FROM Serverside_State__c WHERE OwnerId = :testUser.Id ];

		System.assertEquals( 1, resolvedState.size(), 'Only one state should have been created!' );

		Test.startTest();

			System.runAs( testUser ) {

				ServerSideStateUtil.storeState( UserInfo.getUserId(), TEST_STATE_SLUG, testState );

			}

		Test.stopTest();

		resolvedState = [ SELECT Id, State_Token__c FROM Serverside_State__c WHERE OwnerId = :testUser.Id ];

		System.assertEquals( 1, resolvedState.size(), 'Only one state should have been created!' );

	}

    static testMethod void retrieveState() {

		String stateChunkString = generateTestString( 'a', ServerSideStateUtil.TEXT_UPPER_LIMIT );

		System.runAs( testUser ) {

		Serverside_State__c testState = new Serverside_State__c( state_chunk_1__c = stateChunkString,
																 state_chunk_2__c = stateChunkString,
																 state_chunk_3__c = stateChunkString,
																 state_chunk_4__c = stateChunkString,
																 state_chunk_5__c = stateChunkString,
																 state_chunk_6__c = stateChunkString,
																 state_chunk_7__c = stateChunkString,
																 state_chunk_8__c = stateChunkString,
																 state_chunk_9__c = stateChunkString,
																 state_chunk_10__c = stateChunkString,
																 State_Token__c = UserInfo.getUserId() + ServerSideStateUtil.STATE_TOKEN_DELIM + TEST_STATE_SLUG );

																// ^ This is what a State Token looks like.

			insert testState;
		}

		String resolvedState;

		Test.startTest();

			resolvedState = ServerSideStateUtil.retrieveState( testUser.Id, TEST_STATE_SLUG );

		Test.stopTest();

		System.assertEquals( ServerSideStateUtil.STATE_CHUNK_COUNT * ServerSideStateUtil.TEXT_UPPER_LIMIT, resolvedState.length() );

    }

    static testMethod void tooMuchState() {

		String baseStateChunk = generateTestString( '1', ServerSideStateUtil.TEXT_UPPER_LIMIT );
		String testState = baseStateChunk;

		for ( Integer testIndex = 0; testIndex < ServerSideStateUtil.STATE_CHUNK_COUNT + 2; testIndex++ )
			testState += baseStateChunk;

		String noException = 'Exception not thrown in the case of state being too large!';

		System.runAs( testUser ) {

			try {

				ServerSideStateUtil.storeState( UserInfo.getUserId(), TEST_STATE_SLUG, testState );

				System.assert( false, noException );

			} catch( ServerSideStateUtil.ServerSideStateException sssEx ) {

				System.assert( sssEx.getMessage().contains( ServerSideStateUtil.STATE_TOO_LARGE ), noException );

			}

		}

    }

}