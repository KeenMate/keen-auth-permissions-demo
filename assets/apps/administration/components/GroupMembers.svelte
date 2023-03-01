<script>
	import NewMemberForm from "./NewMemberForm.svelte";

	import { createEventDispatcher } from "svelte";

	const dispatch = createEventDispatcher();
	export let group;
</script>

<div class="card my-3">
	<div class="card-header">
		<div class="row">
			<NewMemberForm on:add groupMembers={group.members} />
		</div>
	</div>
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
								on:click={() => dispatch("remove", member)}
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
</div>

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
