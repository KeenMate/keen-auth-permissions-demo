<script>
	import { createEventDispatcher } from "svelte";

	export let group;
	export let errorMessage;
	const dispatch = createEventDispatcher();

	function close() {
		dispatch("close");
	}

	let userId;
	function addMember() {
		if (!userId) {
			errorMessage = "userId cant be null";
			return;
		}
		dispatch("add-member", userId);
	}

	function removeMember(id) {
		dispatch("remove-member", id);
	}

	function reload() {
		dispatch("reload", group.userGroupId);
	}
</script>

<div class="d-flex">
	<button on:click={close} class="btn btn-muted ml-auto"
		><i class="fa-solid fa-xmark" /></button
	>
</div>
<h1>#{group.userGroupId} {group.title}</h1>
<h4>({group.code})</h4>
active: {group.isActive} <br />
assignable: {group.isAssignable}<br />
default: {group.isDefault}<br />
external: {group.isExternal}<br />
system: {group.isSystem}<br />
<h3>Members</h3>

<input
	type="number"
	bind:value={userId}
	placeholder="user_id"
	class="form-control"
/>
<button on:click={addMember} class="btn"> Add new member</button>
{#if errorMessage}
	<div class="alert alert-danger" role="alert">
		{errorMessage}
	</div>
{/if}
<table class="table">
	<thead>
		<th
			><button
				title="Remove member"
				class="btn btn-outline btn-sm"
				on:click={() => reload()}><i class="fas fa-sync" /></button
			>
		</th>
		<th>ID</th>
		<th>Name</th>
		<th>Manual</th>
		<th>Is active</th>
		<th>Is locked</th>
	</thead>
	<tbody>
		{#each group.members as member}
			<tr>
				<td
					><button
						title="Remove member"
						class="btn btn-outline btn-sm"
						on:click={() => removeMember(member.userId)}
						><i class="fa-solid fa-user-minus" /></button
					></td
				>
				<td>{member.userId}</td>
				<td>{member.userDisplayName}</td>
				<td>{member.manualAssignment}</td>
				<td>{member.userIsActive}</td>
				<td>{member.userIsLocked}</td>
			</tr>
		{/each}
	</tbody>
</table>

<style>
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
