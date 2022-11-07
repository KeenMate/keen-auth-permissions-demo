<script>
	import { createEventDispatcher } from "svelte";
	const dispatch = createEventDispatcher();

	export let group;
</script>

<td>
	<button
		class="btn btn-sm btn-outline-success"
		class:btn-outline-danger={group.isActive}
		on:click={() => dispatch("set-active")}
		title={group.isActive ? "Disable group" : "Enable group"}
		>{#if group.isActive}
			<i class="fa-solid fa-ban" />
		{:else}
			<i class="fa-solid fa-play" />
		{/if}
	</button>
	<button
		class="btn btn-sm btn-outline-primary"
		on:click={() => dispatch("set-lock")}
		title={group.isAssignable
			? "Lock group (you want be able to add more mebers)"
			: "Unlock group"}
		>{#if group.isAssignable}
			<i class="fa-solid fa-lock" />
		{:else}
			<i class="fa-solid fa-lock-open" />
		{/if}
	</button>

	<button
		class="btn btn-sm btn-outline-danger"
		on:click={() => dispatch("delete")}
		title="Delete group"><i class="fa-solid fa-trash" /></button
	>
	<button
		on:click={() => dispatch("show")}
		title="Show detail"
		class="btn btn-sm btn-outline"><i class="fa-solid fa-eye" /></button
	>
</td>

<style>
	.btn-sm {
		padding: 0.25rem 0.5rem;
		font-size: 0.875rem;
		line-height: 1.5;
		border-radius: 0.2rem;
	}
</style>
