import { GroupsEndpoint } from "../constants/urls";
import { BaseApiManager } from "./BaseApiProvider";

export class GroupsManager extends BaseApiManager {
	constructor(tenant) {
		super();
		this.tenant = tenant;
		this.endpoint = GroupsEndpoint(tenant);
	}

	async getGroups() {
		let res = await this.Get(this.endpoint.getAll);
		return res.data;
	}
}
