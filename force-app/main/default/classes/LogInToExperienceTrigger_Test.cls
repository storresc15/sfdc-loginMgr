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
      'LogInToExperienceAsUser_Read' /*, 
                                                'LogInToExperienceAsUser_Edit', 
                                                'LogInToExperienceAsUser_Delete'*/
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

    //Creating Accounts

    /*
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Account') ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        List<String> lstrequiredfields=new List<String>();
        
        for(String f : fields.keyset())
        {
        Schema.DescribeFieldResult desribeResult = fields.get(f).getDescribe();
        if( desribeResult.isCreateable() && !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate() )
        {
            //This is mandatory / required field
            lstrequiredfields.add(f);
            
        }
        }
*/
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
      Account a = new Account(name = 'TestAcc');
      LogInToExperienceManagementTrigger.handleObjectPermission(
        new List<SObject>{ a }
      );
    }
  }
}
