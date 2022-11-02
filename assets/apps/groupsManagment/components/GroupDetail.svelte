<script>
	import { createEventDispatcher } from "svelte";

	export let group;
	const dispatch = createEventDispatcher();

	function close() {
		dispatch("close");
	}
</script>

Group info
{JSON.stringify(group)}

<button on:click={close}>close</button>
