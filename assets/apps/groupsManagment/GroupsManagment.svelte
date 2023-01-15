<script>
	import GroupsList from "./components/GroupsList.svelte";
	import GroupDetail from "./components/GroupDetail.svelte";
	import { GroupsManager } from "../../managers/GroupsManager";
	import { onMount } from "svelte";
	import Modal from "../../components/Modal.svelte";
	import CreateGroupForm from "./components/CreateGroupForm.svelte";

	export let tenant;

	let manager = new GroupsManager(tenant);
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

	async function setActive({ setTo, groupId }) {
		callApi(async () => await manager.setEnable(groupId, setTo));
	}
	async function setLocked({ setTo, groupId }) {
		callApi(async () => await manager.setLocked(groupId, setTo));
	}

	async function createGroup(group) {
		callApi(async () => {
			await manager.createGroup(group);
			openCreate = false;
		});
	}

	async function deleteGroup(group) {
		callApi(async () => await manager.deleteGroup(group.userGroupId));
	}

	async function addMember(groupId, userId) {
		await callApi(async () => {
			await manager.addMember(groupId, userId);
			await showDetail(group.userGroupId);
		});
	}
	async function removeMember(groupId, userId) {
		callApi(async () => {
			await manager.removeMember(groupId, userId);
			await showDetail(group.userGroupId);
		});
	}

	async function load() {
		console.log("load");
		callApi(async () => (groups = (await manager.getGroups()) ?? []), false);
	}

	onMount(async () => {
		load();
	});

	async function callApi(func, shouldLoad = true) {
		try {
			await func();
		} catch (res) {
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

		errorMessage = null;
	}
</script>

<Modal>
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
