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

	async Get(url) {
		return await this.FetchWithToken(url, undefined, "GET");
	}

	async Post(url, body) {
		return await this.FetchWithToken(url, body, "POST");
	}

	async Put(url, body) {
		return await this.FetchWithToken(url, body, "PUT");
	}
	async Patch(url, body) {
		return await this.FetchWithToken(url, body, "PATCH");
	}
	async Delete(url, body) {
		return await this.FetchWithToken(url, body, "DELETE");
	}
}
