<script>
	import { onMount } from "svelte";
	import { push } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import { GroupsManager } from "../../../managers/GroupsManager";
	import GroupActions from "../components/GroupActions.svelte";
	let groups = [];
	export let errorMessage;
	let manager = new GroupsManager($tenant);

	function openDetail(group) {
		// redirect
		push("#/groups/" + group.userGroupId);
	}

	function setActive(group, setTo) {
		callApi(async () => await manager.setEnable(group.userGroupId, setTo));
	}
	function setLocked(group, setTo) {
		callApi(async () => await manager.setLocked(group.userGroupId, setTo));
	}
	function deleteGroup(group) {
		callApi(async () => await manager.deleteGroup(group.userGroupId));
	}

	async function load() {
		callApi(async () => (groups = (await manager.getGroups()) ?? []), false);
	}

	onMount(async () => {
		load();
	});

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

		errorMessage = null;
	}
</script>

{#if errorMessage}
	<div class="alert alert-danger" role="alert">
		{errorMessage}
	</div>
{/if}

<div class="mb-2" />

<div class="card">
	<div class="card-header d-flex">
		<h2>Groups</h2>
		<a href="#/groups/create" class="ms-auto">
			<button class="btn btn-primary ">create new group</button>
		</a>
	</div>
	<hr class="my-0" />
	<div class="card-body">
		<div class="table-responsive">
			<table class="table table-striped table-sm ">
				<thead>
					<tr>
						<th scope="col">Actions </th>
						<th scope="col">#</th>
						<th scope="col">Title</th>
						<th scope="col">Members</th>
						<th scope="col">Active</th>
						<th scope="col">Assignable</th>
						<th scope="col">External</th>
					</tr>
				</thead>
				<tbody>
					{#each groups as group}
						<tr>
							<GroupActions
								{group}
								on:set-active={() => setActive(group, !group.isActive)}
								on:set-lock={() => setLocked(group, group.isAssignable)}
								on:delete={() => deleteGroup(group)}
							/>
							<th scope="row">{group.userGroupId}</th>
							<td class="text-start">
								<a class="clickable" href={"#/groups/" + group.userGroupId}
									>{group.groupTitle}
								</a> <br />
								<span class="text-sm">
									{group.groupCode}
								</span>
							</td>
							<td>{group.membersCount}</td>
							<td>{group.isActive ? "Active" : "Inactive"}</td>

							<td>{group.isAssignable ? "Unlocked" : "Locked"}</td>
							<td>{group.isExternal}</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>
</div>

<style>
	.clickable {
		cursor: pointer;
	}
</style>
