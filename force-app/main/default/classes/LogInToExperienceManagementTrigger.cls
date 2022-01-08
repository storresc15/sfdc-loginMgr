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
    //check the object type of the parameter list

    //Get the metadata types that should enforce the permissions

    //if the Sobject is found, then continue with the check of the permissions

    //Get the Session information of the user that is currently triggering this

    //if the user if leveraging the login to experience as user, then enforce the permissions:

    //Does the user has read access (To be checked if this applies??)

    //Does the user has create access
    //Does the user has update access
    // Does the user has delete access

    //Do a switch on the type of transaction comming from the trigger

    //switch if is create
    //switch if is update
    //switch if is delete

    //I'm not considering any pattern for this, as it should be very generic to be added to any standard or custom object. Consider implementing one by considering the test cases first.
  }
}
