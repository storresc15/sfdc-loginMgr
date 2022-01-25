import { LightningElement, api, wire, track } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import USER_ID from "@salesforce/user/Id";
import NAME_FIELD from "@salesforce/schema/User.Name";
import USERNAME_FIELD from "@salesforce/schema/User.Username";
import getSessionInfo from "@salesforce/apex/LogInToExperienceManagementController.getSessionInfo";

export default class LogInToExperienceBanner extends LightningElement {
  //Private Variables
  @track isLoggedInAsUser = false;
  @track name;
  @track username;
  @api displayUserInfo;
  @api displayUser;
  @api font;
  @api color;
  @api backgroundColor;

  //Wire functionas
  @wire(getRecord, {
    recordId: USER_ID,
    fields: [NAME_FIELD, USERNAME_FIELD]
  })
  wireuser({ data }) {
    if (data) {
      this.name = data.fields.Name.value;
      this.username = data.fields.Username.value;
    }
  }

  @wire(getSessionInfo)
  retrieveUserSession({ data }) {
    if (data) {
      this.isLoggedInAsUser = data.IsLoggedInAsUser;
    }
  }
}
