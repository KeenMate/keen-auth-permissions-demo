<script>
	import { push } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import { GroupsManager } from "../../../providers/groups-provider";
	import Notifications from "../../../providers/notifications-provider";

	let title,
		isActive = true,
		isAssignable = true,
		isExternal = false;
	let manager = new GroupsManager($tenant);

	async function createAsync() {
		if (!valid()) {
			return;
		}
		try {
			await manager.createGroupAsync({
				title,
				isActive,
				isAssignable,
				isExternal,
			});

			Notifications.success(`Group  ${title} created`);

			close();
		} catch (res) {
			console.log(res);
			Notifications.error(manager.getErrorMsg(res), "Error creating group");
		}
	}

	function valid() {
		if (!title) {
			Notifications.error("Title cant be empty");
			return false;
		}

		return true;
	}

	function close() {
		push("#/groups");
	}
</script>

<!-- <div class="row">
	<div class="col-lg-6 col-8 col-sm-12"> -->
<div class="card mt-3">
	<div class="card-header d-flex">
		<h2>Create new group</h2>
		<button on:click={close} class="btn btn-muted ms-auto">
			<i class="fa-solid fa-xmark" />
		</button>
	</div>
	<div class="card-body">
		<div class="form-container ">
			<div class="input-group input-group-static mb-4">
				<label for="title">Title</label>
				<input
					type="text"
					class="form-control mb-3"
					id="title"
					name="name"
					placeholder="Title"
					bind:value={title}
				/>
			</div>

			<div class="row">
				<div class="col">
					<div class="form-check form-switch d-flex align-items-center ps-6">
						<input
							class="form-check-input"
							type="checkbox"
							id="isActive"
							bind:checked={isActive}
						/>
						<label class="form-check-label ms-3 mb-0" for="isActive"
							>Active</label
						>
					</div>
				</div>
				<div class="col">
					<div class="form-check form-switch d-flex align-items-center ps-6">
						<input
							class="form-check-input"
							type="checkbox"
							id="isExternal"
							bind:checked={isExternal}
						/>
						<label class="form-check-label ms-3 mb-0" for="isExternal"
							>External</label
						>
					</div>
				</div>
				<div class="col">
					<div class="form-check form-switch d-flex align-items-center ps-6">
						<input
							class="form-check-input"
							type="checkbox"
							id="isAssignable"
							bind:checked={isAssignable}
						/>
						<label class="form-check-label ms-3 mb-0" for="isAssignable"
							>Assignable</label
						>
					</div>
				</div>
			</div>
			<button
				type="submit"
				value="send"
				class="btn btn-success mb-1"
				on:click={createAsync}
			>
				CREATE
			</button>
		</div>
	</div>
</div>

<!-- </div>
</div> -->
<style>
	.form-control {
		height: calc(1.5em + 0.75rem + 2px);
	}

	.form-container {
		align-items: left !important;
	}
</style>
