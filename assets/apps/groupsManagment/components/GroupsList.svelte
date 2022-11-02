<script>
	import { createEventDispatcher } from "svelte";

	export let groups;
	$: console.log({ groups });
	const dispatch = createEventDispatcher();
	function openDetail(group) {
		dispatch("open-detail", group);
	}
</script>

<table class="table">
	<thead>
		<tr>
			<th scope="col">#</th>
			<th scope="col">Title</th>
			<th scope="col">Code</th>
			<th scope="col">Members</th>
		</tr>
	</thead>
	<tbody>
		{#each groups as group}
			<tr>
				<th scope="row">{group.userGroupId}</th>
				<td on:click={() => openDetail(group)}>{group.groupTitle}</td>
				<td>{group.groupCode}</td>
				<td>{group.membersCount}</td>
			</tr>
		{/each}
	</tbody>
</table>
