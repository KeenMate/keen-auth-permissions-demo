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

	function showDetail(g) {
		console.log("show detail of " + g.userGroupId);
		callApi(async () => (group = await manager.getGroup(g.userGroupId)), false);
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

	async function callApi(func, load = true) {
		try {
			await func();
		} catch (res) {
			if (res?.error) {
				errorMessage = res?.error?.msg;
			} else {
				errorMessage = "Server error try again later";
			}
			return;
		}
		if (load) {
			load();
		}

		errorMessage = null;
	}

	onMount(async () => {
		load();
	});

	async function load() {
		groups = (await manager.getGroups()) ?? [];
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
		<GroupDetail {group} on:close={showList} {errorMessage} />
	{:else}
		<GroupsList
			{errorMessage}
			{groups}
			on:open-detail={(e) => showDetail(e.detail)}
			on:set-active={(e) => setActive(e.detail)}
			on:set-locked={(e) => setLocked(e.detail)}
			on:open-create={() => (openCreate = true)}
		/>
	{/if}
</Modal>
