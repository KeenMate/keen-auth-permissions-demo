export class BaseApiManager {
	constructor() {
		this.token = document
			.querySelector('meta[name="csrf-token"]')
			.getAttribute("content");
	}

	async FetchWithToken(url, bodyObject, method = "post") {
		let res = await fetch(url, {
			method: method,
			headers: {
				"Content-Type": "application/json",
				"X-CSRF-Token": this.token,
			},
			body: bodyObject ? JSON.stringify(bodyObject) : undefined,
		});

		if (res.status === 200) {
			let json = await res.json();

			console.debug(`[API CALL] called ${method} on ${url}`, {
				response: json,
			});

			return json;
		}

		let contentType = res.headers.get("content-type");
		if (contentType && contentType.indexOf("application/json") !== -1) {
			throw await res.json();
		}
		throw await res.text();
	}

	GetAsync(url) {
		return this.FetchWithToken(url, undefined, "GET");
	}

	PostAsync(url, body) {
		return this.FetchWithToken(url, body, "POST");
	}

	PutAsync(url, body) {
		return this.FetchWithToken(url, body, "PUT");
	}
	PatchAsync(url, body) {
		return this.FetchWithToken(url, body, "PATCH");
	}
	DeleteAsync(url, body) {
		return this.FetchWithToken(url, body, "DELETE");
	}

	/**
	 * extract error msg from server response
	 * @param {*} error
	 * @returns
	 */
	getErrorMsg(response) {
		if (response == "Forbidden") {
			return "Forbidden, missing permissions";
		}

		if (response?.error) {
			const error = response.error;
			return error?.msg ?? error?.code;
		}

		return "Server or connection error";
	}
}
