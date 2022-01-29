/*******************************************************************************
Class Name      : LogInToExperienceManagementController
Description     : Main Controller to be used on Aura and LWC to manage the permissions while user is Leveraging the Log in to Experience as User.
Created By      : Sebastian Torres
Created Date    : 2022-06-01
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-06-01              Initial version
*******************************************************************************/
global with sharing class LogInToExperienceManagementController {
  @testvisible
  private static Boolean fakeException = false;

  @AuraEnabled(cacheable=true)
  global static SessionInfo getSessionInfo() {
    try {
      SessionInformationBuilder.SessionInformationWrapper sessionInformation = SessionInformationService.getSessionInfo();
      SessionInfo result = new SessionInfo();
      result.UserType = sessionInformation.UserType;
      result.IsLoggedInAsUser = sessionInformation.IsLoggedInAsUser;
      result.HasCreatePermission = sessionInformation.HasCreatePermission;
      result.HasReadPermission = sessionInformation.HasReadPermission;
      result.HasEditPermission = sessionInformation.HasEditPermission;
      result.HasDeletePermission = sessionInformation.HasDeletePermission;

      if (test.isRunningTest() && fakeException) {
        List<SessionInfo> sessions = new List<SessionInfo>();
        system.debug(sessions[20000].UserType);
      }

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
    global Boolean IsLoggedInAsUser;
    @AuraEnabled
    global Boolean HasCreatePermission;
    @AuraEnabled
    global Boolean HasReadPermission;
    @AuraEnabled
    global Boolean HasEditPermission;
    @AuraEnabled
    global Boolean HasDeletePermission;
  }
}
