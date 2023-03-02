<script>
	import WithLazyLoader from "../../../components/WithLazyLoader.svelte";

	import { tenant } from "../../../auth/auth-store";
	import { GroupsManager } from "../../../providers/groups-provider";
	import Notifications from "../../../providers/notifications-provider";

	const manager = new GroupsManager($tenant);

	export let group;

	let task;

	let assigments = [];
	async function getAssignedPermissionsAsync() {
		try {
			assigments = await (task = manager.getAssignedPermissionsAsync(
				group.userGroupId
			));
			filterAssigments(assigments);
			Notifications.success("Permissions loaded");
		} catch (res) {
			Notifications.error(
				manager.getErrorMsg(res),
				"Error loading permissions"
			);
		}
	}

	let permSets = [];
	let directlyAssigned = [];
	function filterAssigments(assigments) {
		permSets = assigments.filter((a) => a.permSetId);
		directlyAssigned = assigments.filter((a) => !a.permSetId) ?? [];
	}

	$: getAssignedPermissionsAsync(group);
</script>

<div class="card my-3">
	<div class="card-body">
		<h3>Permission sets</h3>
		<WithLazyLoader {task}>
			<table class="table table-striped">
				<thead>
					<tr>
						<th class="fixed_width">
							<button
								class="btn btn-xsm btn-outline-success m-0"
								title="Unassign permission set"
							>
								<i class="fa-solid fa-plus" />
							</button>
						</th>
						<th class="fixed_width"> Title </th>
						<th> Permissions </th>
					</tr>
				</thead>
				<tbody>
					{#each permSets as permSet}
						<tr>
							<td>
								<button
									class="btn btn-xsm btn-outline-danger m-0"
									title="Unassign permission set"
								>
									<i class="fa-solid fa-minus" />
								</button>
							</td>

							<td class="fixed_width">
								{permSet.permSetTitle}
							</td>
							<td>
								<div class="d-flex flex-wrap">
									{#each permSet.permissions as permission}
										<span class="ms-2">{permission.code}</span>
									{/each}
								</div>
							</td>
						</tr>
					{:else}
						<tr>
							<td colspan="2">No permission sets are assigned</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</WithLazyLoader>
		<hr />
		<h3>Direcly assigned</h3>

		<WithLazyLoader {task}>
			<table class="table table-striped">
				<thead>
					<tr>
						<th class="fixed_width">
							<button
								class="btn btn-xsm btn-outline-success m-0"
								title="Unassign permission set"
							>
								<i class="fa-solid fa-plus" />
							</button>
						</th>
						<th class="fixed_width"> Title </th>
						<th> Permissions </th>
					</tr>
				</thead>
				<tbody>
					{#each directlyAssigned as assigment}
						{@const permission = assigment.permissions[0]}
						<tr>
							<td>
								<button
									class="btn btn-xsm btn-outline-danger m-0"
									title="Unassign permission set"
								>
									<i class="fa-solid fa-minus" />
								</button>
							</td>

							<td class="fixed_width">
								{permission.title}
							</td>
							<td>
								{permission.code}
							</td>
						</tr>
					{:else}
						<tr>
							<td colspan="2">No permissions are direcly assigned</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</WithLazyLoader>
	</div>
</div>

<style>
	.fixed_width {
		width: 1px;
	}
</style>