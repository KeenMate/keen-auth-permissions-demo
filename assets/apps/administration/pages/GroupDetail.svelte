<script>
	import { getContext } from "svelte";
	import { push } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import WithLazyLoader from "../../../components/WithLazyLoader.svelte";
	import { emptyPromise } from "../../../helpers/promise-helpers";
	import { GroupsManager } from "../../../providers/groups-provider";
	import GroupMapping from "../components/GroupMapping.svelte";
	import Notifications from "../../../providers/notifications-provider";
	export let params;

	let manager = new GroupsManager($tenant);

	let group;
	let userId;

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

	async function addMemberAsync() {
		try {
			await manager.addMemberAsync(group.userGroupId, userId);

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
	async function createMappingAsync(val) {
		try {
			await manager.createMappingAsync(
				group.userGroupId,
				val.name,
				val.value,
				val.provider,
				val.type
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

	load();

	$: console.log("group", group);
</script>

<WithLazyLoader {task}>
	<div class="d-flex mt-5">
		<div class="text-start">
			<h2 class="mb-0">{group.title}</h2>
			<p class="text-muted mb-0">#{group.userGroupId} ({group.code})</p>
			{#if !group.isActive}
				<span class="badge bg-danger"> Disabled </span>
			{/if}
			{#if !group.isAssignable}
				<span class="badge bg-warning"> Locked </span>
			{/if}
			{#if group.isDefault}
				<span class="badge bg-info"> Default </span>
			{/if}
			{#if group.isExternal}
				<span class="badge bg-info"> External </span>
			{/if}
			{#if group.isSystem}
				<span class="badge bg-info"> System </span>
			{/if}
		</div>
		<div class=" ms-auto align-self-start">
			<button on:click={close} class="btn btn-muted">
				<i class="fa-solid fa-xmark text-3xl" />
			</button>
		</div>
	</div>

	<div class="card my-3">
		<div class="card-header">
			<div class=" d-flex">
				<h4 class="m-0">Members</h4>
				<button class="btn btn-primary btn-sm ms-auto" on:click={showModal}>
					Mappings</button
				>
			</div>
			<div class="row">
				<div class="col-8">
					<div class=" input-group input-group-static ">
						<input
							type="number"
							bind:value={userId}
							placeholder="user_id"
							class="form-control"
							id="userId"
						/>
					</div>
				</div>
				<button
					on:click={addMemberAsync}
					class=" col-4 btn btn-sm btn-success "
				>
					Add new member</button
				>
			</div>
		</div>
		<hr class="m-0" />
		<div class="card-body">
			<table class="table">
				<thead>
					<th />
					<th>Manual</th>
					<th>Active</th>
					<th>Locked</th>
					<th>ID</th>
					<th>Name</th>
				</thead>
				<tbody>
					{#each group.members as member}
						<tr>
							<td class="fixed_width"
								><button
									title="Remove member"
									class="btn btn-outline btn-sm"
									on:click={() => removeMemberAsync(member.userId)}
									><i class="fa-solid fa-user-minus" /></button
								></td
							>
							<td class="fixed_width">{member.manualAssignment}</td>
							<td class="fixed_width">{member.userIsActive}</td>
							<td class="fixed_width">{member.userIsLocked}</td>
							<td class="fixed_width">{member.userId}</td>
							<td>{member.userDisplayName}</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>
</WithLazyLoader>

<style>
	.fixed_width {
		width: 1px;
	}

	.btn-sm {
		padding: 0.25rem 0.5rem;
		font-size: 0.875rem;
		line-height: 1.5;
		border-radius: 0.2rem;
	}

	.form-control {
		height: calc(1.5em + 0.75rem + 2px);
	}
</style>
