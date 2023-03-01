<script>
	import GroupBadges from "./GroupBadges.svelte";

	import { push } from "svelte-spa-router";

	export let group;

	function close() {
		push("#/groups");
	}
</script>

<div class="d-flex mt-5">
	<div class="text-start">
		<h2 class="mb-0">{group.title}</h2>
		<p class="text-muted mb-0">#{group.userGroupId} ({group.code})</p>
		<GroupBadges {group} />
	</div>
	<div class=" ms-auto align-self-start">
		<button on:click={close} class="btn btn-muted">
			<i class="fa-solid fa-xmark text-3xl" />
		</button>
	</div>
</div>
