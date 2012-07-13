/** ServerSideStateUtil
*
* Utility allowing users to arbitrarily store data assosciated with a specific User and/or Session,
* potentially allowing developer to cut down on amount of data Salesforce needs to send during page
* refreshes or increase the amount of data that can be hadnled during single request by offloading
* some of said data to this utility as opposed to the built-in Visualforce viewstate
*
* 2011-12-06: Case# 00171892 / Michael Ng & William Saunders - Bluewolf - First pass at ServersideState utility
*
*/
public class ServerSideStateUtil {

	public static final String STATE_NOT_FOUND = 'Cannot find corresponding server side state!';
	public static final String STATE_NOT_STORED = 'Cannot properly store state!';
	public static final String STATE_TOO_LARGE = 'State is larger than record permits!';
	public static final String STATE_SLUG_MISSING = 'Must specify a text slug representing functionality this state belongs to.';

	public static final Integer TEXT_UPPER_LIMIT = 32768;
	public static final Integer STATE_CHUNK_COUNT = 10;
	public static final String STATE_CHUNK_PREFIX = 'State_Chunk_';
	public static final String STATE_TOKEN_DELIM = ' - ';

	public static void storeState( Id userId, String stateSlug, String theState ) {

		if ( theState.length() > STATE_CHUNK_COUNT * TEXT_UPPER_LIMIT )
			throw new ServerSideStateException( STATE_TOO_LARGE );

		List<String> stateSplits = splitByLength( theState, TEXT_UPPER_LIMIT );

		Serverside_State__c newState = new Serverside_State__c( State_Token__c = genStateToken( userId, stateSlug ) );

		for ( Integer splitIndex = 0; splitIndex < stateSplits.size(); splitIndex++ )
			newState.put( STATE_CHUNK_PREFIX + ( splitIndex + 1 ) + '__c', stateSplits[ splitIndex ] );		// +1 as field names dont start at 0

		try {

			upsert newState State_Token__c;

		} catch( System.Dmlexception dmlEx ) {

			throw new ServerSideStateException( STATE_NOT_STORED );

		}

	}

	public static String retrieveState( Id userId, String stateSlug ) {

		String concatenatedState = '';

		Serverside_State__c requestedState;

		try {

			requestedState = [ SELECT Id, state_chunk_1__c ,
									 state_chunk_2__c ,
									 state_chunk_3__c ,
									 state_chunk_4__c ,
									 state_chunk_5__c ,
									 state_chunk_6__c ,
									 state_chunk_7__c ,
									 state_chunk_8__c ,
									 state_chunk_9__c ,
									 state_chunk_10__c
									 FROM Serverside_State__c
									 WHERE State_Token__c = :genStateToken( userId, stateSlug ) ];

		} catch( System.Queryexception qEx ) {

			throw new ServerSideStateException( STATE_NOT_FOUND );

		}

		return concatState( requestedState );

	}

	private static String genStateToken( Id userId, String stateSlug ) {

		if ( stateSlug == null || stateSlug.trim() == '' )
			throw new ServerSideStateException( STATE_SLUG_MISSING );

		return userId + STATE_TOKEN_DELIM + stateSlug;

	}

	private static String concatState( Serverside_State__c stateToConcat ) {

		String concatString = '';

		for ( Integer stateFieldIndex = 1; stateFieldIndex < STATE_CHUNK_COUNT+1; stateFieldIndex++ )
			concatString += stateToConcat.get( STATE_CHUNK_PREFIX + stateFieldIndex + '__c' );

		return concatString;

	}

	//TODO: Move to StringUtils
	public static List<String> splitByLength( String stringToSplit, Integer length ) {

		List<String> splitStrings = new List<String>();
		Integer strPosit = 0;

		while ( strPosit < stringToSplit.length() ) {

			Integer endPosit = ( strPosit + length < stringToSplit.length() ) ? strPosit + length : stringToSplit.length();

			String strChunk = stringToSplit.substring( strPosit, endPosit );

			splitStrings.add( strChunk );

			strPosit = strPosit + length;

		}

		return splitStrings;

	}

	public class ServerSideStateException extends Exception { }

}