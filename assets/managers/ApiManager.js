import {
	registrationUrl,
	forgottenPasswordUrl,
	resetPasswrodUrl,
	smsTokenReset,
	resendVerification,
} from "../constants/urls";
import { BaseApiManager } from "./BaseApiProvider";

class ApiManager extends BaseApiManager {
	constructor() {
		super();
	}

	async Register(name, email, password) {
		return await this.Post(registrationUrl, {
			name,
			email,
			password,
		});
	}

	async ForgottenPassword(email, method) {
		return await this.Post(forgottenPasswordUrl, {
			method,
			email,
		});
	}

	async PasswordReset(token, method, password) {
		let url = resetPasswrodUrl(token, method);

		return await this.Post(url, {
			password,
		});
	}

	async SmsToken(token) {
		return await this.Post(smsTokenReset, {
			token,
		});
	}

	async ResendVerification(email) {
		return await this.Post(resendVerification, {
			email,
		});
	}
}

export default new ApiManager();
