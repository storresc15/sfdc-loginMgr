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
    Map<String, String> sessionMap = getSessionMap();

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
  private static Map<String, String> getSessionMap() {
    //If run by the Automated Process user - While attempting to access Auth.SessionManagement methods throws an UNCATCHABLE error
    String userSession = UserInfo.getSessionId();
    if (String.isBlank(userSession) || Test.isRunningTest()) {
      return new Map<String, String>{
        'SessionId' => userSession,
        'UserType' => 'Standard',
        'LoginHistoryId' => '11111111',
        'LoginType' => 'Remote Access 2.0'
      };
    }

    return Auth.SessionManagement.getCurrentSession();
  }
}
