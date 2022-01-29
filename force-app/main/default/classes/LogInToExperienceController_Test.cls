@IsTest
public class LogInToExperienceController_Test {
  @IsTest
  static void testShouldGetSessionInfo() {
    LogInToExperienceManagementController.SessionInfo info = LogInToExperienceManagementController.getSessionInfo();
    system.assert(info.UserType != null);
  }

  @isTest
  static void testShouldGetException() {
    List<Exception> exceptions = new List<Exception>();

    try {
      LogInToExperienceManagementController.fakeException = true;
      LogInToExperienceManagementController.SessionInfo info = LogInToExperienceManagementController.getSessionInfo();
    } catch (Exception e) {
      exceptions.add(e);
    }
    system.assert(exceptions.size() > 0);
  }
}
