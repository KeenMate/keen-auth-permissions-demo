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
		base: base,
		getAll: base,
		create: base,
		get: (group_id) => `${base}/${group_id}`,
		delete: (group_id) => `${base}/${group_id}`,
		enable: (group_id) => `${base}/${group_id}/enable`,
		disable: (group_id) => `${base}/${group_id}/disable`,
		lock: (group_id) => `${base}/${group_id}/lock`,
		unlock: (group_id) => `${base}/${group_id}/unlock`,
		addUser: (group_id, user_id) => `${base}/${group_id}/${user_id}`,
		removeUser: (group_id, user_id) => `${base}/${group_id}/${user_id}`,
	};
};
