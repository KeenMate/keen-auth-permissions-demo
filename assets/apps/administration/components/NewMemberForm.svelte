<script>
	import { createEventDispatcher, onMount } from "svelte";
	import { Multiselect } from "svelte-multiselect";
	import { UserManager } from "../../../providers/users-provider";
	import { tenant } from "../../../auth/auth-store";
	import notifications from "../../../providers/notifications-provider";

	const manager = new UserManager($tenant);

	const dispatch = createEventDispatcher();
	let selectedUser;
	let users = [];
	export let groupMembers = [];

	async function loadUsersAsync() {
		try {
			const loadedUsers = await manager.getTenantUsersAsync();

			const groupMemberIds = groupMembers.map((member) => member.userId);

			const filtered = loadedUsers.filter(
				(user) => !groupMemberIds.includes(user.userId)
			);

			users = filtered;
		} catch (res) {
			console.error(res);
			notifications.error(manager.getErrorMsg(res), "Error getting users");
		}
	}

	function addMember() {
		dispatch("add", selectedUser);
		selectedUser = null;
	}

	$: loadUsersAsync(groupMembers);
</script>

<div class="col-8">
	<Multiselect
		options={users}
		bind:value={selectedUser}
		label="displayName"
		trackBy="userId"
		small
		placeholder="Add new member"
	/>
</div>
<button on:click={addMember} class=" col-4 btn btn-sm btn-success mb-0">
	Add</button
>
