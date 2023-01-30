import CBuffer from "CBuffer";
import { writable } from "svelte/store";
import { DateTime } from "luxon";

import Toastr from "toastr";

const MessageCount = 500;

export const Warning = "Warning";
export const Success = "Success";
export const Error = "Error";

// TODO move to constants
const timeOut = 5000;
const extendedTimeOut = 30000;

Toastr.options = {
	closeButton: false,
	debug: false,
	newestOnTop: false,
	progressBar: false,
	positionClass: "toast-bottom-right",
	preventDuplicates: false,
	onclick: null,
	showDuration: "300",
	hideDuration: "1000",
	timeOut: timeOut,
	extendedTimeOut: extendedTimeOut,
	showEasing: "swing",
	hideEasing: "linear",
	showMethod: "fadeIn",
	hideMethod: "fadeOut",
};

class NotificationProvider {
	constructor() {
		this.buffer = new CBuffer(MessageCount);
		this.messages = writable([]);
	}

	#saveMessage(type, message, title) {
		console.log({ type, message, title });
		this.buffer.push({ type, message, title, timestamp: DateTime.now() });
		this.messages.set(this.buffer.toArray());
	}

	warning(message, title = undefined, options = {}) {
		this.#saveMessage(Warning, message, title);
		Toastr.warning(message, title, options);
	}

	success(message, title = undefined, options = {}) {
		this.#saveMessage(Success, message, title);
		Toastr.success(message, title, options);
	}

	error(
		message,
		title = undefined,
		options = { timeOut: 30_000, extendedTimeOut: 60_000 }
	) {
		this.#saveMessage(Error, message, title);
		Toastr.error(message, title, options);
	}
}

export default new NotificationProvider();
