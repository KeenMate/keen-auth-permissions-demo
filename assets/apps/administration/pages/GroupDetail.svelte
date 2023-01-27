<script>
	import { createEventDispatcher, getContext, onMount } from "svelte";
	import { push } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import WithLazyLoader from "../../../components/WithLazyLoader.svelte";
	import { emptyPromise } from "../../../helpers/promise-helpers";
	import { GroupsManager } from "../../../managers/GroupsManager";
	import GroupMapping from "../components/GroupMapping.svelte";

	export let params;
	$: groupId = params.group;
	let manager = new GroupsManager($tenant);

	let group;
	let errorMessage;
	const dispatch = createEventDispatcher();

	const { open, close: closeModal } = getContext("simple-modal");

	const showModal = () =>
		open(GroupMapping, {
			mappings: group.mappings,
			create: async (newMapping) => {
				await createMappings(newMapping);
				closeModal();
			},
			remove: async (value) => {
				await removeMapping(value);
				closeModal();
			},
		});

	function close() {
		push("#/groups");
	}

	let userId;

	async function addMember() {
		await callApi(async () => {
			errorMessage = null;
			await manager.addMember(group.userGroupId, userId);
		});
	}
	async function removeMember(targetUserId) {
		await callApi(async () => {
			errorMessage = null;
			await manager.removeMember(group.userGroupId, targetUserId);
		});
	}
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
		});
	}

	async function removeMapping(mappingId) {
		callApi(async () => {
			errorMessage = null;

			await manager.removeMapping(group.userGroupId, mappingId);
		});
	}

	let loadTask = emptyPromise;
	function loadGroup() {
		loadTask = callApi(async () => {
			group = await manager.getGroup(params.group);
			console.log("got group", group);
			return group;
		}, false);

		return loadTask;
	}
	loadGroup();
	// onMount(() => loadGroup());

	async function callApi(func, shouldLoad = true) {
		try {
			await func();
			if (shouldLoad) {
				await loadGroup();
			}
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
		}
	}

	$: console.log(errorMessage);
</script>

<WithLazyLoader task={loadTask}>
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
				<button on:click={addMember} class=" col-4 btn btn-sm btn-success ">
					Add new member</button
				>
			</div>
		</div>
		{#if errorMessage}
			<hr class="m-0" />

			<div class="alert alert-danger" role="alert">
				{errorMessage}
			</div>
		{/if}
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
									on:click={() => removeMember(member.userId)}
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
	</div></WithLazyLoader
>

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
