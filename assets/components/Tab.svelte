<script>
	import { createEventDispatcher } from "svelte";
	const dispatch = createEventDispatcher();

	export let selectedTab;
	export let code;
	$: active = selectedTab == code;

	function changeTab() {
		selectedTab = code;
		dispatch("click", code);
	}
</script>

<li class="nav-item">
	<!-- svelte-ignore a11y-click-events-have-key-events -->
	<span
		class="nav-link mb-0 px-0 py-1"
		class:active
		role="tab"
		aria-controls="profile"
		aria-selected={active ? "true" : "false"}
		on:click={changeTab}
	>
		<slot>{code}</slot>
	</span>
</li>

<style>
	.nav-item {
		cursor: pointer;
	}
</style>
