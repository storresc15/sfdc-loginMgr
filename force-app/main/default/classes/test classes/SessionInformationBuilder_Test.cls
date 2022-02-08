@isTest
public class SessionInformationBuilder_Test {
  @TestSetup
  static void setup() {
    Profile p = [SELECT Id FROM Profile LIMIT 1];
    User u = new User(
      Alias = 'standt',
      Email = 'systemuser@uravttest.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'systemuser@uravttest.com'
    );

    insert u;
    List<String> psNames = new List<String>{
      'LogInToExperienceAsUser_Create',
      'LogInToExperienceAsUser_Read',
      'LogInToExperienceAsUser_Edit',
      'LogInToExperienceAsUser_Delete'
    };
    List<PermissionSet> psets = [
      SELECT Id
      FROM PermissionSet
      WHERE Name IN :psNames
    ];

    for (PermissionSet ps : psets) {
      insert new PermissionSetAssignment(
        AssigneeId = u.id,
        PermissionSetId = ps.Id
      );
    }
  }

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
      'LoginHistoryId' => '',
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

  @isTest
  static void testBuilderUser3() {
    //Mocking the External User
    Map<String, String> externalUserMap = new Map<String, String>{
      'SessionId' => '1234455',
      'UserType' => 'CspLitePortal',
      'LoginHistoryId' => '1111111',
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

  @isTest
  static void testBuilderUser4() {
    //Mocking the External User
    Map<String, String> externalUserMap = new Map<String, String>{
      'SessionId' => '1234455',
      'UserType' => 'Standard',
      'LoginHistoryId' => '',
      'LoginType' => 'Remote Access 2.0'
    };
    try {
      SessionInformationBuilder.SessionInformationWrapper sessionInfo = new SessionInformationBuilder()
        .setUserType(externalUserMap.get('UserType'))
        .setLoginType(externalUserMap.get('LoginType'))
        .setSessionId(externalUserMap.get('SessionId'))
        .setLoginHistory(externalUserMap.get('LoginHistoryId'))
        .setIsLoggedInAsUser()
        .setPermissions()
        .build();
    } catch (Exception e) {
      system.debug('Exception: ' + e.getMessage());
    }
  }

  @isTest
  static void testPermissionSet() {
    User u = [
      SELECT ID, Username
      FROM User
      WHERE Username = 'systemuser@uravttest.com'
      LIMIT 1
    ];
    System.runAs(u) {
      SessionInformationBuilder.SessionInformationWrapper sessionInfo = new SessionInformationBuilder()
        .grantPermissionByPermissionSets(u.id)
        .build();
    }
  }
}
