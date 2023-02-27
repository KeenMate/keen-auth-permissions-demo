import {
	registrationUrl,
	forgottenPasswordUrl,
	resetPasswrodUrl,
	smsTokenReset,
	resendVerification,
} from "../constants/urls";
import { BaseApiManager } from "./base-api-provider";

class ApiManager extends BaseApiManager {
	constructor() {
		super();
	}

	async Register(name, email, password) {
		return await this.PostAsync(registrationUrl, {
			name,
			email,
			password,
		});
	}

	async ForgottenPassword(email, method) {
		return await this.PostAsync(forgottenPasswordUrl, {
			method,
			email,
		});
	}

	async PasswordReset(token, method, password) {
		let url = resetPasswrodUrl(token, method);

		return await this.PostAsync(url, {
			password,
		});
	}

	async SmsToken(token) {
		return await this.PostAsync(smsTokenReset, {
			token,
		});
	}

	async ResendVerification(email) {
		return await this.PostAsync(resendVerification, {
			email,
		});
	}
}

export default new ApiManager();
