import { GroupsEndpoint } from "../constants/urls";
import { BaseApiManager } from "./base-api-provider";

export class GroupsManager extends BaseApiManager {
	constructor(tenant) {
		super();
		this.tenant = tenant;
		this.endpoint = GroupsEndpoint(tenant);
	}

	async getGroupsAsync() {
		let res = await this.Get(this.endpoint.getAll);
		return res.data;
	}

	async createGroup(group) {
		let res = await this.Put(this.endpoint.create, group);
		return res.data;
	}

	async getGroupAsync(groupId) {
		let res = await this.Get(this.endpoint.get(groupId));
		return res.data;
	}

	async deleteGroupAsync(groupId) {
		let res = await this.Delete(this.endpoint.delete(groupId));
		return res.data;
	}
	async setEnableAsync(groupId, setTo) {
		let res;
		if (setTo === true) {
			res = await this.Patch(this.endpoint.enable(groupId));
		} else {
			res = await this.Patch(this.endpoint.disable(groupId));
		}

		return res.data;
	}

	async setLockedAsync(groupId, setTo) {
		let res;
		if (setTo === true) {
			res = await this.Patch(this.endpoint.lock(groupId));
		} else {
			res = await this.Patch(this.endpoint.unlock(groupId));
		}

		return res.data;
	}

	async addMemberAsync(groupId, UserId) {
		let res = await this.Put(this.endpoint.addMember(groupId, UserId));
		return res.data;
	}
	async removeMemberAsync(groupId, UserId) {
		let res = await this.Delete(this.endpoint.removeMember(groupId, UserId));
		return res.data;
	}

	async createMappingAsync(groupId, name, value, provider, type) {
		const res = await this.Put(this.endpoint.createMapping(groupId), {
			name,
			value,
			provider,
			type,
		});

		return res.data;
	}
	async removeMappingAsync(groupId, mappingId) {
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
