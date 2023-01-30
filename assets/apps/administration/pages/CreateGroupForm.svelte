<script>
	import { push } from "svelte-spa-router";
	import { tenant } from "../../../auth/auth-store";
	import { GroupsManager } from "../../../providers/groups-provider";

	let title,
		isActive = true,
		isAssignable = true,
		isExternal = false;
	let manager = new GroupsManager($tenant);
	let errorMessage;

	function dispatchCreate() {
		if (!valid()) {
			return;
		}
		callApi(async () => {
			await manager.createGroup({ title, isActive, isAssignable, isExternal });
		});
	}

	function valid() {
		if (!title) {
			errorMessage = "Title cant be empty";
			return false;
		}

		return true;
	}

	function close() {
		push("#/groups");
	}

	async function callApi(func, shouldLoad = true) {
		try {
			await func();
		} catch (res) {
			if (res == "Forbidden") {
				errorMessage = "Forbidden, missing permissions";
				return;
			}

			console.log(res);
			if (res?.error) {
				errorMessage = res?.error?.msg;
			} else {
				errorMessage = "Server error try again later";
			}
			return;
		}

		close();
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

			{#if errorMessage}
				<div class="alert alert-danger" role="alert">
					{errorMessage}
				</div>
			{/if}
			<button
				type="submit"
				value="send"
				class="btn btn-success mb-1"
				on:click={dispatchCreate}
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
