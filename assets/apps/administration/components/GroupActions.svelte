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
		class="btn btn-sm btn-outline-primary min-w"
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
		title="Delete group"
	>
		<i class="fa-solid fa-trash" />
	</button>
</td>

<style>
	.min-w {
		min-width: 9px;
	}
</style>
