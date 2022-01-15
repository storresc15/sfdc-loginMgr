@isTest
public class SessionInformationBuilder_Test {
  @isTest
  static void testBuilderInternalUser() {
    //Mocking the internal User
    Map<String, String> internalUserMap = new Map<String, String>{
      'SessionId' => '1234455',
      'UserType' => 'Standard',
      'LoginHistoryId' => '11111111',
      'LoginType' => 'Remote Access 2.0'
    };

    SessionInformationBuilder.SessionInformationWrapper sessionInfo = new SessionInformationBuilder()
      .setUserType(internalUserMap.get('UserType'))
      .setLoginType(internalUserMap.get('LoginType'))
      .setSessionId(internalUserMap.get('SessionId'))
      .setLoginHistory(internalUserMap.get('LoginHistoryId'))
      .setIsLoggedInAsUser()
      .setPermissions()
      .build();
  }

  @isTest
  static void testBuilderExternalUser() {
    //Mocking the External User
    Map<String, String> externalUserMap = new Map<String, String>{
      'SessionId' => '1234455',
      'UserType' => 'CspLitePortal',
      'LoginHistoryId' => null,
      'LoginType' => 'Remote Access 2.0'
    };

    SessionInformationBuilder.SessionInformationWrapper sessionInfo = new SessionInformationBuilder()
      .setUserType(externalUserMap.get('UserType'))
      .setLoginType(externalUserMap.get('LoginType'))
      .setSessionId(externalUserMap.get('SessionId'))
      .setLoginHistory(externalUserMap.get('LoginHistoryId'))
      .setIsLoggedInAsUser()
      .setPermissions()
      .build();
  }
}
