import { UsersEndpoint } from "../constants/urls";
import { BaseApiManager } from "./base-api-provider";

export class UserManager extends BaseApiManager {
	constructor(tenant) {
		super();
		this.tenant = tenant;
		this.endpoint = UsersEndpoint(tenant);
	}

	async getTenantUsersAsync() {
		const response = await this.Get(this.endpoint.getTenantMembers);
		return response.data;
	}
}
