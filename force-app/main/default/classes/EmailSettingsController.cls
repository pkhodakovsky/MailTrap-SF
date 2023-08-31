public with sharing class EmailSettingsController {
    
    @AuraEnabled
    public static void saveSenderName(String newSenderName){
        try{
            User userToUpdate = new User(Id=UserInfo.getUserId(),SenderName=newSenderName);   
            update userToUpdate;
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }         
    }
}