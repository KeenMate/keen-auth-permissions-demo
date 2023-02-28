<script>
	import { getContext } from "svelte";
	import { push } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import WithLazyLoader from "../../../components/WithLazyLoader.svelte";
	import { emptyPromise } from "../../../helpers/promise-helpers";
	import { GroupsManager } from "../../../providers/groups-provider";
	import GroupMapping from "../components/GroupMapping.svelte";
	import Notifications from "../../../providers/notifications-provider";
	import GroupBadges from "../components/GroupBadges.svelte";
	import TabsContainer from "../../../components/TabsContainer.svelte";
	import Tab from "../../../components/Tab.svelte";
	import GroupMembers from "../components/GroupMembers.svelte";
	import { groupDetailTabs as tabs } from "../../../constants/tabs";

	export let params;

	let manager = new GroupsManager($tenant);

	let group;

	const { open, close: closeModal } = getContext("simple-modal");

	const showModal = () =>
		open(GroupMapping, {
			mappings: group.mappings,
			create: async (newMapping) => {
				await createMappingAsync(newMapping);
				closeModal();
			},
			remove: async (value) => {
				await removeMappingAsync(value);
				closeModal();
			},
		});

	function close() {
		push("#/groups");
	}

	async function addMemberAsync(user) {
		try {
			await manager.addMemberAsync(group.userGroupId, user.userId);

			Notifications.success("Member added");

			loadGroupAsync();
		} catch (res) {
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error adding member");
		}
	}
	async function removeMemberAsync(targetUserId) {
		try {
			await manager.removeMemberAsync(group.userGroupId, targetUserId);

			Notifications.success("Member removed");

			loadGroupAsync();
		} catch (res) {
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error removing member");
		}
	}
	async function createMappingAsync(mapping) {
		try {
			console.log(mapping);
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
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error creating mapping");
		}
	}

	async function removeMappingAsync(mappingId) {
		try {
			await manager.removeMappingAsync(group.userGroupId, mappingId);

			Notifications.success("Mapping removed");

			loadGroupAsync();
		} catch (res) {
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error removing mapping");
		}
	}

	let task = emptyPromise;

	function load() {
		showLoaderAsync(() => loadGroupAsync());
		task = loadGroupAsync();
	}

	async function showLoaderAsync(func, ...args) {
		task = func(...args);
		return await task;
	}

	async function loadGroupAsync() {
		try {
			group = await manager.getGroupAsync(params.group);
			Notifications.success("Group loaded");
		} catch (res) {
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error loading group");
		}
	}

	let selectedTab = tabs.members;

	//params parameter is only used for reactivity
	$: load(params);
</script>

<WithLazyLoader {task}>
	<div class="d-flex mt-5">
		<div class="text-start">
			<h2 class="mb-0">{group.title}</h2>
			<p class="text-muted mb-0">#{group.userGroupId} ({group.code})</p>
			<GroupBadges {group} />
		</div>
		<div class=" ms-auto align-self-start">
			<button on:click={close} class="btn btn-muted">
				<i class="fa-solid fa-xmark text-3xl" />
			</button>
		</div>
	</div>

	<TabsContainer>
		<Tab bind:selectedTab name={tabs.members} />
		<Tab bind:selectedTab name={tabs.mappings} />
		<Tab bind:selectedTab name={tabs.permissions} />
	</TabsContainer>
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
		Permissions
	{/if}
</WithLazyLoader>
