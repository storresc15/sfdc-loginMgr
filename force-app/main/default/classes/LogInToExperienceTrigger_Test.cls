@IsTest
public class LogInToExperienceTrigger_Test {
  @TestSetup
  static void setup() {
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
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
      'LogInToExperienceAsUser_Read'
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

  @IsTest
  static void testCreate() {
    User u = [
      SELECT id, Username
      FROM User
      WHERE Username = 'systemuser@uravttest.com'
      LIMIT 1
    ];
    System.runAs(u) {
      LogInToExperienceObjectManager__mdt theRecord = new LogInToExperienceObjectManager__mdt();
      theRecord.DeveloperName = 'Account MTD';
      theRecord.SObject__c = 'Account';
      theRecord.Create_Access_Check__c = true;
      theRecord.Edit_Access_Check__c = true;
      theRecord.Delete_Access_Check__c = true;

      Account a = new Account(name = 'TestAcc');
      ObjectManagerConfig_MTD.MDObjectManager testObjMdt = new ObjectManagerConfig_MTD.MDObjectManager(
        theRecord
      );
      LogInToExperienceManagementTrigger.handleObjectPermission(
        new List<SObject>{ a }
      );
      LogInToExperienceManagementTrigger.handleTriggerTransaction(
        'BEFORE_INSERT',
        true,
        true,
        true,
        testObjMdt,
        a
      );
      LogInToExperienceManagementTrigger.handleTriggerTransaction(
        'BEFORE_UPDATE',
        true,
        true,
        true,
        testObjMdt,
        a
      );
      LogInToExperienceManagementTrigger.handleTriggerTransaction(
        'BEFORE_DELETE',
        true,
        true,
        true,
        testObjMdt,
        a
      );
    }
  }
}
