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

	async createGroup(group) {
		let res = await this.Put(this.endpoint.create, group);
		return res.data;
	}

	async getGroup(groupId) {
		let res = await this.Get(this.endpoint.get(groupId));
		return res.data;
	}

	async deleteGroup(groupId) {
		let res = await this.Delete(this.endpoint.delete(groupId));
		return res.data;
	}
	async setEnable(groupId, setTo) {
		let res;
		if (setTo === true) {
			res = await this.Patch(this.endpoint.enable(groupId));
		} else {
			res = await this.Patch(this.endpoint.disable(groupId));
		}

		return res.data;
	}

	async setLocked(groupId, setTo) {
		let res;
		if (setTo === true) {
			res = await this.Patch(this.endpoint.lock(groupId));
		} else {
			res = await this.Patch(this.endpoint.unlock(groupId));
		}

		return res.data;
	}

	async addMember(groupId, UserId) {
		let res = await this.Put(this.endpoint.addMember(groupId, UserId));
		return res.data;
	}
	async removeMember(groupId, UserId) {
		let res = await this.Delete(this.endpoint.removeMember(groupId, UserId));
		return res.data;
	}

	async createMapping(groupId, name, value, provider, type) {
		const res = await this.Put(this.endpoint.createMapping(groupId), {
			name,
			value,
			provider,
			type,
		});

		return res.data;
	}
	async removeMapping(groupId, mappingId) {
		const res = await this.Delete(
			this.endpoint.removeMapping(groupId, mappingId)
		);

		return res.data;
	}
	async getMappings(groupId) {
		const res = await this.Get(this.endpoint.getMappings(groupId, mappingId));

		return res.data;
	}
}
