/*******************************************************************************
Class Name      : LogInToExperienceManagementController
Description     : 
Created By      : Sebastian Torres
Created Date    : 2022-06-01
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-06-01              Initial version
*******************************************************************************/
global with sharing class LogInToExperienceManagementController {
  @AuraEnabled(cacheable=true)
  global static SessionInfo getSessionInfo() {
    try {
      SessionInformationBuilder.SessionInformationWrapper sessionInformation = SessionInformationService.getSessionInfo();
      SessionInfo result = new SessionInfo();
      result.UserType = sessionInformation.UserType;
      result.IsLoggedInAsUser = sessionInformation.IsLoggedInAsUser;
      result.HasPermission = sessionInformation.HasCreatePermission; //To be updated

      return result;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  //Wrapper class to provide details to LWC

  global class SessionInfo {
    @AuraEnabled
    global String UserType;
    @AuraEnabled
    global Boolean HasPermission;
    @AuraEnabled
    global Boolean IsLoggedInAsUser;
  }
}
