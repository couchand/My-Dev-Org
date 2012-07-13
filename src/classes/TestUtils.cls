@isTest
public class TestUtils
{
	public static User ADMIN_USER {
		get {
			if ( ADMIN_USER == null ){
				ADMIN_USER = [SELECT  Id FROM User WHERE  Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
			}
			return ADMIN_USER;
		}
		private set;
	}
	
	public static User getTestUser( String userName, String profileName )
	{
		Id profileId;
		try
		{
			profileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id;
		}
		catch(Exception ex)
		{
			System.debug(ex);
			System.assert(false, 'No profile exists with name'+ profileName);
		}
		User testUser = new User();
		testUser.LastName = 'test ' + UserName;
		testUser.Alias = UserName;
		testUser.Email = UserName+'@test.com';
		testUser.Username = UserName+UserName+'@test.com';
		testUser.CommunityNickname = 'a'+UserName;
		testUser.TimeZoneSidKey = 'America/New_York';
		testUser.LocaleSidKey = 'en_US';
		testUser.EmailEncodingKey = 'ISO-8859-1';
		testUser.ProfileId = profileId;
		testUser.LanguageLocaleKey = 'en_US';
		testUser.IsActive = true;
		
		return testUser;
	}
}