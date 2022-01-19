import { LightningElement, wire, track } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import USER_ID from "@salesforce/user/id";
import NAME_FIELD from "@salesforce/schema/User.Name";
import getSessionInfo from "@salesforce/apex/LogInToExperienceManagementController.getSessionInfo";

export default class LogInToExperienceBanner extends LightningElement {
  //Private Variables
  @track isLoggedInAsUser = false;
  @track name;

  //Wire functionas
  @wire(getRecord, {
    recordId: USER_ID,
    fields: [NAME_FIELD]
  })
  wireuser({ data }) {
    if (data) {
      this.name = data.fields.Name.value;
    }
  }

  @wire(getSessionInfo)
  retrieveUserSession({ data }) {
    if (data) {
      this.isLoggedInAsUser = data.IsLoggedInAsUser;
    }
  }
}
