export const baseApiUrl = "";

export const registrationUrl = baseApiUrl + "/register";
export const forgottenPasswordUrl = baseApiUrl + "/forgotten-password";
export const resetPasswrodUrl = (token, method) =>
  baseApiUrl + `/reset-password?token=${token}&method=${method}`;
export const smsTokenReset = baseApiUrl + "/sms-reset";
