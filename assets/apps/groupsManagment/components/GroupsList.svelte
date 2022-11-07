<script>
	import { createEventDispatcher } from "svelte";
	import GroupActions from "./GroupActions.svelte";

	export let groups;
	export let errorMessage;
	const dispatch = createEventDispatcher();

	function openDetail(group) {
		dispatch("open-detail", group);
	}

	function setActive(group, setTo) {
		dispatch("set-active", { groupId: group.userGroupId, setTo });
	}
	function setLocked(group, setTo) {
		dispatch("set-locked", { groupId: group.userGroupId, setTo });
	}
	function deleteGroup(group) {
		dispatch("delete", group);
	}

	function openCreate() {
		dispatch("open-create");
	}
</script>

{#if errorMessage}
	<div class="alert alert-danger" role="alert">
		{errorMessage}
	</div>
{/if}

<div class="mb-2">
	<button class="btn btn-primary" on:click={openCreate}>create new group</button
	>
</div>

<table class="table">
	<thead>
		<tr>
			<th scope="col" />
			<th scope="col">#</th>
			<th scope="col">Title</th>
			<th scope="col">Code</th>
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
					on:show={() => openDetail(group)}
				/>
				<th scope="row">{group.userGroupId}</th>
				<td
					class="clickable"
					on:click={() => openDetail(group)}
					on:keydown={() => openDetail(group)}>{group.groupTitle}</td
				>
				<td>{group.groupCode}</td>
				<td>{group.membersCount}</td>
				<td>{group.isActive}</td>
				<td>{group.isAssignable}</td>
				<td>{group.isExternal}</td>
			</tr>
		{/each}
	</tbody>
</table>

<style>
	.clickable {
		cursor: pointer;
	}
</style>
