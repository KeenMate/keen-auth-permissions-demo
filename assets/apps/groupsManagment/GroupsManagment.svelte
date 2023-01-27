<script>
	import GroupsList from "../administration/components/GroupsList.svelte";
	import GroupDetail from "../administration/components/GroupDetail.svelte";
	import { GroupsManager } from "../../managers/GroupsManager";
	import { onMount } from "svelte";
	import Modal from "../../components/Modal.svelte";
	import CreateGroupForm from "../administration/pages/CreateGroupForm.svelte";
	import { tenant } from "../../auth/auth-store";

	let groups = [];
	let group;
	let errorMessage;
	let openCreate = false;

	async function showDetail(groupId) {
		console.log("show detail of " + groupId);
		await callApi(async () => (group = await manager.getGroup(groupId)), false);
	}

	function showList() {
		group = null;
		openCreate = false;
	}

	async function setActive({ setTo, groupId }) {}
	async function setLocked({ setTo, groupId }) {}

	async function createGroup(group) {
		callApi(async () => {
			errorMessage = null;
			await manager.createGroup(group);
			openCreate = false;
		});
	}

	async function deleteGroup(group) {}

	async function createMappings(val) {
		callApi(async () => {
			errorMessage = null;
			await manager.createMapping(
				group.userGroupId,
				val.name,
				val.value,
				val.provider,
				val.type
			);
			await showDetail(group.userGroupId);
		});
	}

	async function removeMapping(mappingId) {
		callApi(async () => {
			errorMessage = null;
			await manager.removeMapping(group.userGroupId, mappingId);
			await showDetail(group.userGroupId);
		});
	}

	async function callApi(func, shouldLoad = true) {
		try {
			await func();
		} catch (res) {
			if (res == "Forbidden") {
				errorMessage = "Forbidden, missing permissions";
				return;
			}

			console.log(res);
			if (res?.error) {
				errorMessage = res?.error?.msg;
			} else {
				errorMessage = "Server error try again later";
			}
			return;
		}
		if (shouldLoad) {
			load();
		}
	}
</script>

<Modal>
	<h1>Groups</h1>

	{#if openCreate}
		<CreateGroupForm
			on:create={(e) => createGroup(e.detail)}
			{errorMessage}
			on:close={showList}
		/>
	{:else if group}
		<GroupDetail
			{group}
			on:close={showList}
			{errorMessage}
			on:add-member={(e) => addMember(group.userGroupId, e.detail)}
			on:remove-member={(e) => removeMember(group.userGroupId, e.detail)}
			on:reload={(e) => showDetail(e.detail)}
			on:create-mappings={(e) => createMappings(e.detail)}
			on:remove-mapping={(e) => removeMapping(e.detail)}
		/>
	{:else}
		<GroupsList
			{errorMessage}
			{groups}
			on:open-detail={(e) => showDetail(e.detail.userGroupId)}
			on:set-active={(e) => setActive(e.detail)}
			on:set-locked={(e) => setLocked(e.detail)}
			on:open-create={() => (openCreate = true)}
			on:delete={(e) => deleteGroup(e.detail)}
		/>
	{/if}
</Modal>
