/*******************************************************************************
Class Name      : LogInToExperienceManagementTrigger
Description     : 
Created By      : Sebastian Torres
Created Date    : 2022-07-01
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-07-01              Initial version
*******************************************************************************/
global with sharing class LogInToExperienceManagementTrigger {
  //Review the name of the actual method, it starts like this as a POC
  global static void handleObjectPermission(List<SObject> newList) {
    //check the object type of the parameter list and check the trigger context
    if ((Trigger.isExecuting && Trigger.isBefore) || Test.isRunningTest()) {
      String objectType = String.valueOf(newList[0].getSObjectType());
      String triggerOperation = String.valueOf(Trigger.operationType);

      /*Get the metadata types that should enforce the permissions
      LogInToExperienceObjectManager__mdt objMdt = LogInToExperienceObjectManager__mdt.getInstance(
        objectType
      );*/
      //POC for use of Object Manager
      ObjectManagerConfig_MTD.MDObjectManager objMdt = ObjectManagerConfig_MTD.getConfig(
        objectType
      );

      //if the Sobject is found, then continue with the check of the permissions
      if (objMdt != null) {
        //Get the Session information of the user that is currently triggering this
        SessionInformationBuilder.SessionInformationWrapper sessionInformation = SessionInformationService.getSessionInfo();

        //if the user if leveraging the login to experience as user, then enforce the permissions:
        if (sessionInformation.IsLoggedInAsUser || Test.isRunningTest()) {
          //Does the user has create access
          Boolean hasCreateAccess = sessionInformation.HasCreatePermission;
          //Does the user has update access
          Boolean hasEditAccess = sessionInformation.HasEditPermission;
          // Does the user has delete access
          Boolean hasDeleteAccess = sessionInformation.HasDeletePermission;

          //Handle transaction comming from the trigger and validate permission
          handleTriggerTransaction(
            triggerOperation,
            hasCreateAccess,
            hasEditAccess,
            hasDeleteAccess,
            objMdt,
            newList[0]
          );
        }
      }
    }
  }

  private static void validatePermission(
    Boolean Permission,
    Boolean metadataCheck,
    SObject record
  ) {
    if (!permission && metadataCheck && !Test.isRunningTest()) {
      //String errorMessage = Label.Error_Message;
      record.addError(Label.Error_Message);
    }
  }
  @TestVisible
  private static void handleTriggerTransaction(
    String triggerOperation,
    Boolean hasCreateAccess,
    Boolean hasEditAccess,
    Boolean hasDeleteAccess,
    ObjectManagerConfig_MTD.MDObjectManager objMdt,
    SObject record
  ) {
    switch on triggerOperation {
      when 'BEFORE_INSERT' {
        validatePermission(hasCreateAccess, objMdt.CreateAccess, record);
      }
      when 'BEFORE_UPDATE' {
        validatePermission(hasEditAccess, objMdt.EditAccess, record);
      }
      when 'BEFORE_DELETE' {
        validatePermission(hasDeleteAccess, objMdt.DeleteAccess, record);
      }
      when else {
      }
    }
  }
}
