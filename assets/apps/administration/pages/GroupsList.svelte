<script>
	import { onMount } from "svelte";
	import { tenant } from "../../../auth/auth-store";
	import { GroupsManager } from "../../../managers/GroupsManager";
	import GroupActions from "../components/GroupActions.svelte";
	import Notifications from "../../../providers/notifications-provider";
	let groups = [];
	let manager = new GroupsManager($tenant);

	async function setActiveAsync(group, setTo) {
		try {
			await manager.setEnableAsync(group.userGroupId, setTo);
			Notifications.success(`Group ${setTo ? "enabled" : "disabled"}`);

			await loadAsync();
		} catch (res) {
			console.log(res);

			Notifications.error(manager.getErrorMsg(res));
		}
	}
	async function setLockedAsync(group, setTo) {
		try {
			await manager.setLockedAsync(group.userGroupId, setTo);
			Notifications.success(`Group ${setTo ? "locked" : "unlocked"}`);

			await loadAsync();
		} catch (res) {
			console.log(res);

			Notifications.error(
				manager.getErrorMsg(res),
				`Error ${setTo ? "locking" : "unlocking"} group`
			);
		}
	}
	async function deleteGroupAsync(group) {
		try {
			await manager.deleteGroupAsync(group.userGroupId);
			Notifications.success("Group active set");

			await loadAsync();
		} catch (res) {
			console.log(res);

			Notifications.error(manager.getErrorMsg(res), "Error deleting group");
		}
	}

	async function loadAsync() {
		try {
			groups = (await manager.getGroupsAsync()) ?? [];
			Notifications.success("Groups loaded");
		} catch (res) {
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error loading group");
		}
	}

	onMount(() => {
		loadAsync();
	});
</script>

<div class="card mb-5">
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
								on:set-active={() => setActiveAsync(group, !group.isActive)}
								on:set-lock={() => setLockedAsync(group, group.isAssignable)}
								on:delete={() => deleteGroupAsync(group)}
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
