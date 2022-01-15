@IsTest
public class LogInToExperienceController_Test {
  @IsTest
  static void testShouldGetSessionInfo() {
    LogInToExperienceManagementController.SessionInfo info = LogInToExperienceManagementController.getSessionInfo();
    system.assert(info.UserType != null);
  }

  @isTest
  static void testShouldGetException() {
  }
}
