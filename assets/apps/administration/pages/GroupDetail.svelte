<script>
	import GroupDetailTabs from "../components/GroupDetailTabs.svelte";
	import GroupInfo from "../components/GroupInfo.svelte";
	import WithLazyLoader from "../../../components/WithLazyLoader.svelte";
	import GroupPermissions from "../components/GroupPermissions.svelte";
	import GroupMembers from "../components/GroupMembers.svelte";
	import GroupMapping from "../components/GroupMapping.svelte";

	import { push, querystring } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import { emptyPromise } from "../../../helpers/promise-helpers";
	import { GroupsManager } from "../../../providers/groups-provider";
	import Notifications from "../../../providers/notifications-provider";
	import { groupDetailTabs as tabs } from "../../../constants/tabs";
	import { parse } from "qs";

	export let params;

	let manager = new GroupsManager($tenant);

	let group;

	function close() {
		push("#/groups");
	}

	async function addMemberAsync(user) {
		try {
			await manager.addMemberAsync(group.userGroupId, user.userId);

			Notifications.success("Member added");

			loadGroupAsync();
		} catch (res) {
			console.error(res);
			Notifications.error(manager.getErrorMsg(res), "Error adding member");
		}
	}
	async function removeMemberAsync(targetUserId) {
		try {
			await manager.removeMemberAsync(group.userGroupId, targetUserId);

			Notifications.success("Member removed");

			loadGroupAsync();
		} catch (res) {
			console.error(res);
			Notifications.error(manager.getErrorMsg(res), "Error removing member");
		}
	}

	async function createMappingAsync(mapping) {
		try {
			console.error(mapping);
			await manager.createMappingAsync(
				group.userGroupId,
				mapping.name,
				mapping.value,
				mapping.provider,
				mapping.type
			);

			Notifications.success("Mapping created");

			loadGroupAsync();
		} catch (res) {
			console.error(res);
			Notifications.error(manager.getErrorMsg(res), "Error creating mapping");
		}
	}
	async function removeMappingAsync(mappingId) {
		try {
			await manager.removeMappingAsync(group.userGroupId, mappingId);

			Notifications.success("Mapping removed");

			loadGroupAsync();
		} catch (res) {
			console.error(res);
			Notifications.error(manager.getErrorMsg(res), "Error removing mapping");
		}
	}

	async function loadGroupAsync() {
		try {
			group = await manager.getGroupAsync(params.group);
			Notifications.success("Group loaded");
		} catch (res) {
			console.error(res);
			Notifications.error(manager.getErrorMsg(res), "Error loading group");
		}
	}

	let task = emptyPromise;

	function paramsChanged() {
		//only load group if group id in url changed
		if (params.group != group?.userGroupId) {
			showLoaderAsync(() => loadGroupAsync());
		}
	}

	async function showLoaderAsync(func, ...args) {
		task = func(...args);
		return await task;
	}

	$: query = parse($querystring);
	$: selectedTab = query.tab ?? tabs.members;

	//params parameter is only used for reactivity
	$: paramsChanged(params);
</script>

<WithLazyLoader {task}>
	<GroupInfo {group} />

	<GroupDetailTabs {selectedTab} />

	{#if selectedTab == tabs.members}
		<GroupMembers
			{group}
			on:add={({ detail: member }) => addMemberAsync(member)}
			on:remove={({ detail: member }) => removeMemberAsync(member.userId)}
		/>
	{/if}

	{#if selectedTab == tabs.mappings}
		<GroupMapping
			mappings={group.mappings}
			on:create={({ detail: mapping }) => createMappingAsync(mapping)}
			on:remove={({ detail: mappingId }) => removeMappingAsync(mappingId)}
		/>
	{/if}

	{#if selectedTab == tabs.permissions}
		<GroupPermissions {group} />
	{/if}
</WithLazyLoader>
