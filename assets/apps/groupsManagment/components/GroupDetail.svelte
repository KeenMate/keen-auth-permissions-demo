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
		dispatch("add-member", userId);
	}

	function removeMember(id) {
		dispatch("remove-member", id);
	}
</script>

<button on:click={close}>close</button>
<h1>#{group.userGroupId} {group.title}</h1>
({group.code})<br />
active: {group.isActive} <br />
assignable:{group.isAssignable}<br />
default:{group.isDefault}<br />
external:{group.isExternal}<br />
system:{group.isSystem}<br />
<h3>Members</h3>

<input type="text" bind:value={userId} />
<button on:click={addMember}> add</button>
{#if errorMessage}
	<div class="alert alert-danger" role="alert">
		{errorMessage}
	</div>
{/if}
<table class="table">
	<thead>
		<th />
		<th>ID</th>
		<th>Name</th>
		<th>Manual</th>
		<th>Is active</th>
		<th>Is locked</th>
	</thead>
	<tbody>
		{#each group.members as member}
			<tr>
				<td><button on:click={() => removeMember(member.userId)}>R</button></td>
				<td>{member.userId}</td>
				<td>{member.userDisplayName}</td>
				<td>{member.manualAssignment}</td>
				<td>{member.userIsActive}</td>
				<td>{member.userIsLocked}</td>
			</tr>
		{/each}
	</tbody>
</table>
