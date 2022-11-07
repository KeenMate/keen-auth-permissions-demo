<script>
	import { createEventDispatcher } from "svelte";
	const dispatch = createEventDispatcher();

	let title,
		isActive = true,
		isAssignable = true,
		isExternal = false;
	export let errorMessage;

	function dispatchCreate() {
		if (!valid()) {
			return;
		}

		dispatch("create", { title, isActive, isAssignable, isExternal });
	}

	function valid() {
		if (!title) {
			errorMessage = "Title cant be empty";
			return false;
		}

		return true;
	}

	function close() {
		dispatch("close");
	}
</script>

<div class="d-flex">
	<button on:click={close} class="btn btn-muted ml-auto"
		><i class="fa-solid fa-xmark" /></button
	>
</div>

<h1>Create new group</h1>
<div class="form-container">
	<div class="form-group">
		<label for="title">Title</label>
		<input
			type="text"
			class="form-control mb-3"
			id="title"
			name="title"
			placeholder="Title"
			bind:value={title}
		/>
	</div>
	<div class="form-group">
		<label for="isActive"> Is active</label>

		<input
			type="checkbox"
			id="isActive"
			name="isActive"
			class="form-control mb-3"
			bind:checked={isActive}
		/>
	</div>
	<div class="form-group">
		<label for="isAssignable"> Is assignable</label>

		<input
			type="checkbox"
			id="isAssignable"
			name="isAssignable"
			class="form-control  mb-3"
			bind:checked={isAssignable}
		/>
	</div>

	<div class="form-group">
		<label for="isExternal"> Is external</label>

		<input
			type="checkbox"
			id="isExternal"
			name="isExternal"
			class="form-control  mb-3"
			bind:checked={isExternal}
		/>
	</div>

	{#if errorMessage}
		<div class="alert alert-danger" role="alert">
			{errorMessage}
		</div>
	{/if}
	<button
		type="submit"
		value="send"
		class="btn btn-secondary mb-1"
		on:click={dispatchCreate}
	>
		CREATE
	</button>
</div>

<style>
	.form-control {
		height: calc(1.5em + 0.75rem + 2px);
	}

	.form-container {
		align-items: left !important;
	}
</style>
