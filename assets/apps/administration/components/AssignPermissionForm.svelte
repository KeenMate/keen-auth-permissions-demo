<script>
	import { Multiselect } from "svelte-multiselect";
	import { tenant } from "../../../auth/auth-store";
	import { GroupsManager } from "../../../providers/groups-provider";
	import Notifications from "../../../providers/notifications-provider";
	import { assigmentTypes } from "../../../constants/keys";
	import { getContext } from "svelte";
	const manager = new GroupsManager($tenant);
	const { close } = getContext("simple-modal");
	//used to tell parent that permission was asigned
	export let assignCallback;
	export let groupId;

	export let type;
	let code;
	function beforeAssign() {
		switch (type) {
			case assigmentTypes.perm:
				assignAsync(null, code);
				break;
			case assigmentTypes.permSet:
				assignAsync(code, null);
				break;
			default:
				break;
		}
	}

	async function assignAsync(perm_set_code, perm_code) {
		try {
			await manager.assignPermissionsAsync(groupId, perm_code, perm_set_code);
			Notifications.success("Permission assigned");
			close();
			assignCallback();
		} catch (res) {
			console.error(res);

			Notifications.error(
				manager.getErrorMsg(res),
				"Error assigning permissions"
			);
		}
	}
</script>

<div>
	<Multiselect
		options={Object.values(assigmentTypes)}
		bind:value={type}
		allowEmpty={false}
	/>
	<div class="input-group input-group-static">
		<input
			class="form-control"
			type="text"
			bind:value={code}
			placeholder="value"
		/>
	</div>

	<button
		class="btn btn-xsm btn-outline-danger m-0"
		title="assign permission set"
		on:click={beforeAssign}
	>
		Assign
	</button>
</div>
