public class CatalogController
{
    public CatalogController(ApexPages.StandardSetController sc){}
    
    public Boolean isUser
    {
        get
        {
            User aUser = [SELECT   IsPortalUser__c FROM User WHERE Id = '005A0000001YyRe'];
            return aUser.IsPortalUser__c;
        }
    }
}