/**
*  State
*
* Utility allowing users to arbitrarily store data assosciated with a specific User and/or Session,
* potentially allowing developer to cut down on amount of data Salesforce needs to send during page
* refreshes or increase the amount of data that can be hadnled during single request by offloading
* some of said data to this utility as opposed to the built-in Visualforce viewstate
*
* 2011-12-06: Case# 00171892 / Michael Ng & William Saunders - Bluewolf
*   First pass at ServersideState utility
* 2012-03-31: Bluewolf Internal Development / Andrew Couch - Bluewolf
*   Extend for scalability and refactor to use interface
* 2012-07-13: Hackathon 5.0 / Andrew Couch - Bluewolf
*   Rename to State and add default implementations
*
*/
public class State
{
	public static final String STATE_NOT_FOUND = 'Cannot find corresponding server side state!';
	public static final String STATE_NOT_STORED = 'Cannot properly store state!';
	public static final String STATE_SLUG_MISSING = 'Must specify a text slug representing functionality this state belongs to.';

	public static final Integer TEXT_UPPER_LIMIT = 32768;
	public static final Integer STATE_CHUNK_COUNT = 10;
	public static final String STATE_CHUNK_PREFIX = 'State_Chunk_';
	public static final String STATE_TOKEN_DELIM = ' - ';

	public static void storeState( IStateful stateToStore )
	{
		String theState = stateToStore.serialize();

		List<State__c> oldStates = [SELECT Id FROM State__c WHERE Token__c = :stateToStore.getStateToken()];
		if( !oldStates.isEmpty() )
			delete oldStates;

		Integer numObjects = Integer.valueOf( Decimal.valueOf( theState.length() ).divide( STATE_CHUNK_COUNT * TEXT_UPPER_LIMIT, 0, System.RoundingMode.CEILING ) );

		List<String> stateSplits = splitByLength( theState, TEXT_UPPER_LIMIT );
		List<State__c> newStates = new List<State__c>();

		for( Integer objectIndex = 0; objectIndex < numObjects; objectIndex++ )
		{

			Integer splitOffset = objectIndex * STATE_CHUNK_COUNT;

			State__c newState = new State__c( Token__c = stateToStore.getStateToken(), Index__c = objectIndex );

			for ( Integer splitIndex = 0; splitIndex < STATE_CHUNK_COUNT && splitOffset + splitIndex < stateSplits.size(); splitIndex++ )
				newState.put( STATE_CHUNK_PREFIX + ( splitIndex + 1 ) + '__c', stateSplits[ splitOffset + splitIndex ] );		// +1 as field names dont start at 0

			newStates.add( newState );

		}

		try
		{
			insert newStates;
		}
		catch( System.DmlException dmlEx )
		{
			throw new ServerSideStateException( STATE_NOT_STORED, dmlEx );
		}

	}

	public static void retrieveState( IStateful stateToRetrieve )
	{
		List<State__c> requestedStateObjects;

		try
		{
			requestedStateObjects = [ SELECT Id, state_chunk_1__c ,
									 state_chunk_2__c ,
									 state_chunk_3__c ,
									 state_chunk_4__c ,
									 state_chunk_5__c ,
									 state_chunk_6__c ,
									 state_chunk_7__c ,
									 state_chunk_8__c ,
									 state_chunk_9__c ,
									 state_chunk_10__c
									 FROM State__c
									 WHERE Token__c = :stateToRetrieve.getStateToken()
									 ORDER BY Index__c ];
		}
		catch( System.QueryException qEx )
		{
			throw new ServerSideStateException( STATE_NOT_FOUND, qEx );
		}

		if( requestedStateObjects.isEmpty() )
		{
			throw new ServerSideStateException( STATE_NOT_FOUND );
		}

		stateToRetrieve.deserialize( concatState( requestedStateObjects ) );
	}

	private static String concatState( List<State__c> statesToConcat )
	{
		String concatString = '';

		for( State__c stateToConcat : statesToConcat )
			for ( Integer stateFieldIndex = 1; stateFieldIndex < STATE_CHUNK_COUNT+1; stateFieldIndex++ )
				if( null != stateToConcat.get( STATE_CHUNK_PREFIX + stateFieldIndex + '__c' ) )
					concatString += stateToConcat.get( STATE_CHUNK_PREFIX + stateFieldIndex + '__c' );

		return concatString;
	}

	//TODO: Move to StringUtils
	public static List<String> splitByLength( String stringToSplit, Integer length )
	{
		List<String> splitStrings = new List<String>();
		Integer strPosit = 0;

		while ( strPosit < stringToSplit.length() )
		{
			Integer endPosit = Math.min( strPosit + length, stringToSplit.length() );

			splitStrings.add( stringToSplit.substring( strPosit, endPosit ) );

			strPosit = strPosit + length;
		}

		return splitStrings;
	}

	public class ServerSideStateException extends Exception { }

	public interface IStateful
	{
		String getStateToken();
		String serialize();
		void deserialize( String state );
	}

	public abstract class UserSObject implements IStateful
	{
		private String applicationToken;
		private SObject sObjectStore;

		public UserSObject( String application, SObject anSObject )
		{
			applicationToken = application;
			sObjectStore = anSObject;
		}

		public String getStateToken()
		{
			return applicationToken + STATE_TOKEN_DELIM + UserInfo.getUserId() + STATE_TOKEN_DELIM + sObjectStore.Id;
		}

		public String serialize()
		{
			return JSON.serialize( sObjectStore );
		}

		public void deserialize( String state )
		{
			sObjectStore = (SObject) JSON.deserialize( state, SObject.class );
		}

		public SObject getSObject()
		{
			return sObjectStore;
		}
	}
}
