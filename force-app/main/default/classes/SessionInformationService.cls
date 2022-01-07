/*******************************************************************************
Class Name      : SessionInformationService
Description     : Main Support Service Implementation
Created By      : Sebastian Torres
Created Date    : 2022-06-01
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-06-01              Initial version
*******************************************************************************/
public without sharing class SessionInformationService {
  public static SessionInformationBuilder.SessionInformationWrapper getSessionInfo() {
    Map<String, String> sessionMap = Auth.SessionManagement.getCurrentSession();

    SessionInformationBuilder.SessionInformationWrapper sessionInfo = new SessionInformationBuilder()
      .setUserType(sessionMap.get('UserType'))
      .setLoginType(sessionMap.get('LoginType'))
      .setSessionId(sessionMap.get('SessionId'))
      .setLoginHistory(sessionMap.get('LoginHistoryId'))
      .setIsLoggedInAsUser()
      .setPermissions()
      .build();

    return sessionInfo;
  }
}
