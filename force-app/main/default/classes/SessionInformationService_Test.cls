@IsTest
public class SessionInformationService_Test {
  @IsTest
  static void testGetSessionInformation() {
    SessionInformationBuilder.SessionInformationWrapper sessionInfo = SessionInformationService.getSessionInfo();
    //Add the rest of the session asserts
    system.assert(sessionInfo.UserType != null);
  }
}
