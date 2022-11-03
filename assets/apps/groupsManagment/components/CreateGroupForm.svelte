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
		}
	}

	function close() {
		dispatch("close");
	}
</script>

<button on:click={close}>close</button>

<input
	type="text"
	class="form-control mb-3"
	id="title"
	name="title"
	placeholder="Title"
	bind:value={title}
/>
<div>
	<label for="isActive"> Is active</label>

	<input
		type="checkbox"
		id="isActive"
		name="isActive"
		class="form-control mb-3"
		bind:checked={isActive}
	/>
</div>
<div>
	<label for="isAssignable"> Is assignable</label>

	<input
		type="checkbox"
		id="isAssignable"
		name="isAssignable"
		class="form-control mb-3"
		bind:checked={isAssignable}
	/>
</div>

<div>
	<label for="isExternal"> Is external</label>

	<input
		type="checkbox"
		id="isExternal"
		name="isExternal"
		class="form-control mb-3"
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
