import {
  registrationUrl,
  forgottenPasswordUrl,
  resetPasswrodUrl,
} from "../constants/urls";
import { getQueryVariable } from "../helpers/helpers";

class ApiManager {
  constructor() {
    this.token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
  }

  async Register(name, email, password) {
    return await this.FetchWithToken(registrationUrl, {
      name,
      email,
      password,
    });
  }

  async ForgottenPassword(email, method) {
    return await this.FetchWithToken(forgottenPasswordUrl, {
      method,
      email,
    });
  }

  async PasswordReset(password) {
    let url = resetPasswrodUrl(
      getQueryVariable("token"),
      getQueryVariable("method")
    );

    return await this.FetchWithToken(url, {
      password,
    });
  }

  async FetchWithToken(url, bodyObject, method = "post") {
    let res = await fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.token,
      },
      body: JSON.stringify(bodyObject),
    });

    if (res.status === 200) {
      return await res.json();
    }
    if (res.status === 500) {
      throw await res.json();
    }
    console.log(res);
    throw "Error Comunication with server";
  }
}

export default new ApiManager();
