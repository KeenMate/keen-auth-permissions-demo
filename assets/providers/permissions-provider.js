import { BaseApiManager } from "./base-api-provider";

export class PermissionProvider extends BaseApiManager {
	constructor(tenant) {
		super();
		this.tenant = tenant;
		this.endpoint = UsersEndpoint(tenant);
	}

	//TODO add get permissions and get perm sets
}
