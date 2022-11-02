<script>
	import GroupsList from "./components/GroupsList.svelte";
	import GroupDetail from "./components/GroupDetail.svelte";
	import { GroupsManager } from "../../managers/GroupsManager";
	import { onMount } from "svelte";

	export let tenant;

	let manager = new GroupsManager(tenant);
	let groups = [];
	let group;

	function showDetail(g) {
		group = g;
	}

	function showList() {
		group = null;
	}

	onMount(async () => {
		groups = (await manager.getGroups()) ?? [];
	});
</script>

{#if group}
	<GroupDetail {group} on:close={showList} />
{:else}
	<GroupsList {groups} on:open-detail={(e) => showDetail(e.detail)} />
{/if}
