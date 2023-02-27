<script>
	export let group;
</script>

{#if !group.isActive}
	<span class="badge bg-danger"> Disabled </span>
{/if}
{#if !group.isAssignable}
	<span class="badge bg-warning"> Locked </span>
{/if}
{#if group.isDefault}
	<span class="badge bg-info"> Default </span>
{/if}
{#if group.isExternal}
	<span class="badge bg-info"> External </span>
{/if}
{#if group.isSystem}
	<span class="badge bg-info"> System </span>
{/if}
