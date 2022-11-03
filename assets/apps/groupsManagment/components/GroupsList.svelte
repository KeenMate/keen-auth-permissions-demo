<script>
	import { createEventDispatcher } from "svelte";

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

	function openCreate() {
		dispatch("open-create");
	}
</script>

{#if errorMessage}
	<div class="alert alert-danger" role="alert">
		{errorMessage}
	</div>
{/if}
<button class="btn btn-primary" on:click={openCreate}>create group</button>

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
				<th>
					<button on:click={() => setActive(group, !group.isActive)}
						>{#if group.isActive}
							Dis
						{:else}
							Ena
						{/if}
					</button>
					<button on:click={() => setLocked(group, group.isAssignable)}
						>{#if group.isAssignable}
							Loc
						{:else}
							Unl
						{/if}
					</button>
				</th>
				<th scope="row">{group.userGroupId}</th>
				<td on:click={() => openDetail(group)}>{group.groupTitle}</td>
				<td>{group.groupCode}</td>
				<td>{group.membersCount}</td>
				<td>{group.isActive}</td>
				<td>{group.isAssignable}</td>
				<td>{group.isExternal}</td>
			</tr>
		{/each}
	</tbody>
</table>
