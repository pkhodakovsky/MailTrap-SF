@isTest
public with sharing class EmailSettingsControllerTest {
    @testSetup
    static void setupTestData() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(
            Alias = 'expluser',
            Email = 'user@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'expluser@example.com'
        );

        insert u;
    }

    @isTest
    static void testSaveSenderNameSuccess(){
        User contextUser = [SELECT Id, Alias FROM User WHERE Alias = 'expluser'];
        System.runAs(contextUser){
            EmailSettingsController.saveSenderName('New Sender Name');
        }
        User userWithNewSenderName = [SELECT Id, SenderName FROM User WHERE Alias = 'expluser'];

        Assert.areEqual('New Sender Name', userWithNewSenderName.SenderName);
    }

    @isTest
    static void testSaveSenderNameFail(){
        User contextUser = [SELECT Id, Alias FROM User WHERE Alias = 'expluser'];
        System.runAs(contextUser){
            //Test with name that is too long (>80 Characters)
            try{
                EmailSettingsController.saveSenderName('New Sender Name TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT');
            }catch(Exception e){
                Assert.areEqual('Script-thrown exception', e.getMessage());
            }
        }
    }
}