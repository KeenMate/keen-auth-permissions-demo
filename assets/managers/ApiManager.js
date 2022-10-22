import { registrationUrl } from "../constants/urls";
import { timeout } from "../helpers/promiseHelpers";

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
