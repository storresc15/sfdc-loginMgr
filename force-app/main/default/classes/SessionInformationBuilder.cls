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
public with sharing class SessionInformationBuilder {
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
    system.debug('Inside the login history: ' + loginHistory);
    this.theSessionInformation.LoginHistory = loginHistory == null ||
      loginHistory == ''
      ? ''
      : loginHistory;
    system.debug(
      'Returning this as login history: ' +
      this.theSessionInformation.LoginHistory
    );
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
      system.debug(
        'Inside the setIsLoggedInAsUser:  the login history' +
        this.theSessionInformation.LoginHistory
      );
      this.theSessionInformation.IsLoggedInAsUser = false;
      return this;
    }
  }

  public SessionInformationBuilder setPermissions() {
    String parentSession = '';
    String userId = '';
    String sessionId = this.theSessionInformation.SessionId;
    system.debug('Inside setHasPermission: The session Id' + sessionId);

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
      removePermission(); // To be reviewed
      AuthSession authSession = [
        SELECT Id, LoginHistoryId, ParentId
        FROM AuthSession
        WHERE Id = :sessionId
        LIMIT 1
      ];
      parentSession = authSession.ParentId;

      AuthSession parentAuthSession = [
        SELECT Id, LoginHistoryId, UsersId
        FROM AuthSession
        WHERE Id = :parentSession
        LIMIT 1
      ];
      userId = parentAuthSession != null ? parentAuthSession.UsersId : null;
    }

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

    for (PermissionSet ps : psMap.values()) {
      if (ps.Name == 'LogInToExperience_Permission_RW') {
        //this.theSessionInformation.HasPermission = true;
        return this;
      }
    }
    //this.theSessionInformation.HasPermission = false;

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

  public SessionInformationWrapper build() {
    return this.theSessionInformation;
  }

  public class SessionInformationWrapper {
    public String UserType;
    public String LoginType;
    public String SessionId;
    public String LoginHistory;
    public Boolean HasCreatePermission;
    public Boolean HasReadPermission;
    public Boolean HasEditPermission;
    public Boolean HasDeletePermission;
    public Boolean IsLoggedInAsUser;
  }
}
