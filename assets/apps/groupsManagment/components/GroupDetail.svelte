<script>
	import { createEventDispatcher } from "svelte";

	export let group;
	const dispatch = createEventDispatcher();

	function close() {
		dispatch("close");
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
<table class="table">
	<thead>
		<th>ID</th>
		<th>Name</th>
		<th>Manual</th>
		<th>Is active</th>
		<th>Is locked</th>
	</thead>
	<tbody>
		{#each group.members as member}
			<tr>
				<td>{member.userId}</td>
				<td>{member.userDisplayName}</td>
				<td>{member.manualAssignment}</td>
				<td>{member.userIsActive}</td>
				<td>{member.userIsLocked}</td>
			</tr>
		{/each}
	</tbody>
</table>
