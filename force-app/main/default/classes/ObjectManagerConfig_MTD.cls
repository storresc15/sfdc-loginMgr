/*******************************************************************************
Class Name      : ObjectManagerConfig_MTD
Description     : Class to manage the Object Manager custom metadata
Created By      : Sebastian Torres
Created Date    : 2022-21-01
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-21-01              Initial version
*******************************************************************************/
public class ObjectManagerConfig_MTD {
  public class MDObjectManager {
    public String Name;
    public String ManagedObject;
    public Boolean CreateAccess;
    public Boolean EditAccess;
    public Boolean DeleteAccess;

    public MDObjectManager(LogInToExperienceObjectManager__mdt source) {
      ManagedObject = source.SObject__c;
      CreateAccess = source.Create_Access_Check__c;
      EditAccess = source.Edit_Access_Check__c;
      DeleteAccess = source.Delete_Access_Check__c;
      Name = source.DeveloperName;
    }

    // Constructor that sets default values
    public MDObjectManager(String MDName) {
      ManagedObject = 'Account';
      CreateAccess = true;
      EditAccess = true;
      DeleteAccess = true;
      Name = MDName;
    }
  }

  //Configuration of The metadata

  @testvisible
  private static MDObjectManager cachedConfig = null;

  public static MDObjectManager getConfig(String mdName) {
    if (cachedConfig != null)
      return cachedConfig;

    List<LogInToExperienceObjectManager__mdt> settings = [
      SELECT
        DeveloperName,
        MasterLabel,
        SObject__c,
        Create_Access_Check__c,
        Edit_Access_Check__c,
        Delete_Access_Check__c
      FROM LogInToExperienceObjectManager__mdt
      WHERE SObject__c = :mdName
    ];

    if (settings.size() == 0 || Test.isRunningTest()) {
      cachedConfig = new MDObjectManager('Default');
      return cachedConfig;
    }
    return new MDObjectManager(settings[0]);
  }
}
