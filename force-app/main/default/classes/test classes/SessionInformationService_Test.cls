@IsTest
public class SessionInformationService_Test {
  @IsTest
  static void testGetSessionInformation() {
    SessionInformationBuilder.SessionInformationWrapper sessionInfo = SessionInformationService.getSessionInfo();
    system.assert(sessionInfo.UserType != null);
  }
}
