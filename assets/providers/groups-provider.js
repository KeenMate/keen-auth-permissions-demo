import { GroupsEndpoint } from "../constants/urls";
import { BaseApiManager } from "./base-api-provider";

export class GroupsManager extends BaseApiManager {
	constructor(tenant) {
		super();
		this.tenant = tenant;
		this.endpoint = GroupsEndpoint(tenant);
	}

	async getGroupsAsync() {
		let res = await this.GetAsync(this.endpoint.getAll);
		return res.data;
	}

	async createGroupAsync(group) {
		let res = await this.PutAsync(this.endpoint.create, group);
		return res.data;
	}

	async getGroupAsync(groupId) {
		let res = await this.GetAsync(this.endpoint.get(groupId));
		return res.data;
	}

	async deleteGroupAsync(groupId) {
		let res = await this.DeleteAsync(this.endpoint.delete(groupId));
		return res.data;
	}
	async setEnableAsync(groupId, setTo) {
		let res;
		if (setTo === true) {
			res = await this.PatchAsync(this.endpoint.enable(groupId));
		} else {
			res = await this.PatchAsync(this.endpoint.disable(groupId));
		}

		return res.data;
	}

	async setLockedAsync(groupId, setTo) {
		let res;
		if (setTo === true) {
			res = await this.PatchAsync(this.endpoint.lock(groupId));
		} else {
			res = await this.PatchAsync(this.endpoint.unlock(groupId));
		}

		return res.data;
	}

	async addMemberAsync(groupId, UserId) {
		let res = await this.PutAsync(this.endpoint.addMember(groupId, UserId));
		return res.data;
	}
	async removeMemberAsync(groupId, UserId) {
		let res = await this.DeleteAsync(
			this.endpoint.removeMember(groupId, UserId)
		);
		return res.data;
	}

	async createMappingAsync(groupId, name, value, provider, type) {
		const res = await this.PutAsync(this.endpoint.createMapping(groupId), {
			name,
			value,
			provider,
			type,
		});

		return res.data;
	}
	async removeMappingAsync(groupId, mappingId) {
		const res = await this.DeleteAsync(
			this.endpoint.removeMapping(groupId, mappingId)
		);

		return res.data;
	}
	async getMappingsAsync(groupId) {
		const res = await this.GetAsync(
			this.endpoint.getMappings(groupId, mappingId)
		);

		return res.data;
	}

	async getAssignedPermissionsAsync(groupId) {
		const res = await this.GetAsync(
			this.endpoint.getAssignedPermissions(groupId)
		);

		return res.data;
	}
}
