/*******************************************************************************
Class Name      : SessionInformationBuilder
Description     : Main class to build the Session Information Wrapper used in the app to manage permissions.
Created By      : Sebastian Torres
Created Date    : 2022-06-01
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-06-01              Initial version
*******************************************************************************/
public without sharing class SessionInformationBuilder {
  public SessionInformationWrapper theSessionInformation;

  public SessionInformationBuilder() {
    theSessionInformation = new SessionInformationWrapper();
  }

  public SessionInformationBuilder setUserType(String userType) {
    theSessionInformation.UserType = userType == 'CspLitePortal'
      ? 'Customer User'
      : 'Internal User';
    return this;
  }

  public SessionInformationBuilder setLoginType(String loginType) {
    theSessionInformation.LoginType = loginType;
    return this;
  }

  public SessionInformationBuilder setSessionId(String sessionId) {
    theSessionInformation.SessionId = sessionId;
    return this;
  }

  public SessionInformationBuilder setLoginHistory(String loginHistory) {
    this.theSessionInformation.LoginHistory = loginHistory == null ||
      loginHistory == ''
      ? ''
      : loginHistory;
    return this;
  }

  public SessionInformationBuilder setIsLoggedInAsUser() {
    if (this.theSessionInformation.UserType == 'Customer User') {
      this.theSessionInformation.IsLoggedInAsUser = false;
      return this;
    } else if (this.theSessionInformation.LoginHistory == '') {
      this.theSessionInformation.IsLoggedInAsUser = true;
      return this;
    } else {
      this.theSessionInformation.IsLoggedInAsUser = false;
      return this;
    }
  }

  public SessionInformationBuilder setPermissions() {
    String parentSession = '';
    String userId = '';
    String sessionId = this.theSessionInformation.SessionId;

    if (this.theSessionInformation.UserType == 'Customer User') {
      grantFullPermission();
      return this;
    }
    if (
      this.theSessionInformation.UserType == 'Internal User' &&
      !this.theSessionInformation.IsLoggedInAsUser
    ) {
      grantFullPermission();
      return this;
    }

    if (this.theSessionInformation.IsLoggedInAsUser) {
      removePermission();
      AuthSession authSession = [
        SELECT Id, LoginHistoryId, ParentId
        FROM AuthSession
        WHERE Id = :sessionId
        LIMIT 1
      ];
      parentSession = authSession != null ? authSession.ParentId : '';

      AuthSession parentAuthSession = [
        SELECT Id, LoginHistoryId, UsersId
        FROM AuthSession
        WHERE Id = :parentSession
        LIMIT 1
      ];
      userId = parentAuthSession != null ? parentAuthSession.UsersId : '';
    }

    grantPermissionByPermissionSets(userId);

    return this;
  }

  private SessionInformationBuilder grantFullPermission() {
    this.theSessionInformation.HasCreatePermission = true;
    this.theSessionInformation.HasReadPermission = true;
    this.theSessionInformation.HasEditPermission = true;
    this.theSessionInformation.HasDeletePermission = true;

    return this;
  }

  private SessionInformationBuilder removePermission() {
    this.theSessionInformation.HasCreatePermission = false;
    this.theSessionInformation.HasReadPermission = false;
    this.theSessionInformation.HasEditPermission = false;
    this.theSessionInformation.HasDeletePermission = false;

    return this;
  }

  @TestVisible
  private SessionInformationBuilder grantPermissionByPermissionSets(
    String userId
  ) {
    Map<Id, PermissionSet> psMap = new Map<Id, PermissionSet>(
      [
        SELECT ID, Name
        FROM PermissionSet
        WHERE
          Id IN (
            SELECT PermissionSetId
            FROM PermissionSetAssignment
            WHERE AssigneeId = :userId
          )
      ]
    );
    Set<Id> assigned = psMap.keySet();

    for (PermissionSet ps : psMap.values()) {
      switch on ps.Name {
        when 'LogInToExperienceAsUser_Create' {
          this.theSessionInformation.HasCreatePermission = true;
        }
        when 'LogInToExperienceAsUser_Read' {
          this.theSessionInformation.HasReadPermission = true;
        }
        when 'LogInToExperienceAsUser_Edit' {
          this.theSessionInformation.HasEditPermission = true;
        }
        when 'LogInToExperienceAsUser_Delete' {
          this.theSessionInformation.HasDeletePermission = true;
        }
        when else {
          continue;
        }
      }
    }
    for (CustomPermission cp : [
      SELECT DeveloperName
      FROM CUstomPermission
      WHERE
        Id IN (
          SELECT SetupEntityId
          FROM SetUpEntityAccess
          WHERE SetupEntityType = 'CustomPermission' AND ParentId IN :assigned
        )
    ]) {
      switch on cp.DeveloperName {
        when 'LogInToExperienceAsUser_Create' {
          this.theSessionInformation.HasCreatePermission = true;
        }
        when 'LogInToExperienceAsUser_Read' {
          this.theSessionInformation.HasReadPermission = true;
        }
        when 'LogInToExperienceAsUser_Edit' {
          this.theSessionInformation.HasEditPermission = true;
        }
        when 'LogInToExperienceAsUser_Delete' {
          this.theSessionInformation.HasDeletePermission = true;
        }
        when else {
          continue;
        }
      }
    }

    return this;
  }

  public SessionInformationWrapper build() {
    return this.theSessionInformation;
  }

  public class SessionInformationWrapper {
    public String userType;
    public String loginType;
    public String sessionId;
    public String loginHistory;
    public Boolean hasCreatePermission;
    public Boolean hasReadPermission;
    public Boolean hasEditPermission;
    public Boolean hasDeletePermission;
    public Boolean isLoggedInAsUser;
  }
}
