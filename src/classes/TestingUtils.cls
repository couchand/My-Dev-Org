@isTest
public class TestingUtils
{
	public static Profile STANDARD_USER_PROFILE
	{
		get
		{
			if( null == STANDARD_USER_PROFILE )
			{
				STANDARD_USER_PROFILE = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
			}
			return STANDARD_USER_PROFILE;
		}
	}

	public static User ADMIN_USER
	{
		get
		{
			if( null == ADMIN_USER )
			{
				ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
			}
			return ADMIN_USER;
		}
	}

	public static User createUser( String name, Boolean doInsert )
	{
		User testUser = new User();

		testUser.FirstName = 'Test';
		testUser.LastName = name;
		testUser.Email = name + '@example.com';
		testUser.Username = testUser.Email;

		testUser.Alias = name.length() > 8 ? name.substring( 0, 8 ) : name;
		testUser.CommunityNickname = testUser.Alias;

		testUser.TimeZoneSidKey = 'America/New_York';
		testUser.LocaleSidKey = 'en_US';
		testUser.EmailEncodingKey = 'ISO-8859-1';
		testUser.LanguageLocaleKey = 'en_US';

		testUser.ProfileId = STANDARD_USER_PROFILE.Id;

		if( doInsert )
		{
			System.runAs( ADMIN_USER )
			{
				insert testUser;
			}
		}

		return testUser;
	}
}