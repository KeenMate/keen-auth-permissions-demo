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
			return await res.json();
		}
		if (res.status === 500) {
			throw await res.json();
		}
		console.log(res);
		throw "Error Comunication with server";
	}

	async Get(url) {
		return await this.FetchWithToken(url, undefined, "GET");
	}

	async Post(url, body) {
		return await this.FetchWithToken(url, body, "POST");
	}
}
