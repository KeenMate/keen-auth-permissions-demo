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
		addMember: (groupId, userId) => `${base}/${groupId}/members/${userId}`,
		removeMember: (groupId, userId) => `${base}/${groupId}/members/${userId}`,
		createMapping: (groupId) => `${base}/${groupId}/mappings`,
		removeMapping: (groupId, mappingsId) =>
			`${base}/${groupId}/mappings/${mappingsId}`,
		getMappings: (groupId) => `${base}/${groupId}/mappings`,
		getAssignedPermissions: (groupId) =>
			`${base}/${groupId}/permissions/assigned`,
		assignPermission: (groupId) => `${base}/${groupId}/permissions`,
		unassignPermission: (groupId, assignmentId) =>
			`${base}/${groupId}/permissions/${assignmentId}`,
	};
};

export const UsersEndpoint = (tenant) => {
	let globalBase = `${baseApiUrl}/users`;
	let tenantBase = `${baseApiUrl}/${tenant}`;
	return {
		base: globalBase,
		getTenantMembers: `${tenantBase}/users`,
	};
};
