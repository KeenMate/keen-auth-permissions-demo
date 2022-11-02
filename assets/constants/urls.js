export const baseApiUrl = "/api";

export const registrationUrl = baseApiUrl + "/register";
export const forgottenPasswordUrl = baseApiUrl + "/forgotten-password";
export const resetPasswrodUrl = (token, method) =>
	baseApiUrl + `/reset-password?token=${token}&method=${method}`;
export const smsTokenReset = baseApiUrl + "/sms-reset";
export const resendVerification = baseApiUrl + "/resend-verification";

export const GroupsEndpoint = (tenant) => {
	let base = `${baseApiUrl}/${tenant}/groups`;
	return {
		base: baseApiUrl + "/" + tenant + "/groups",
		getAll: base,
	};
};
