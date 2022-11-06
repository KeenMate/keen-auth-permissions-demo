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
		get: (groupId) => `${base}/${groupId}`,
		delete: (groupId) => `${base}/${groupId}`,
		enable: (groupId) => `${base}/${groupId}/enable`,
		disable: (groupId) => `${base}/${groupId}/disable`,
		lock: (groupId) => `${base}/${groupId}/lock`,
		unlock: (groupId) => `${base}/${groupId}/unlock`,
		addMember: (groupId, userId) => `${base}/${groupId}/${userId}`,
		removeMember: (groupId, userId) => `${base}/${groupId}/${userId}`,
	};
};
