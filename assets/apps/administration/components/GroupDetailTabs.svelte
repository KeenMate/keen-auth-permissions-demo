<script>
	import Tab from "../../../components/Tab.svelte";
	import TabsContainer from "../../../components/TabsContainer.svelte";

	import { updateQuerystringPartial } from "../../../helpers/router-helpers";
	import { groupDetailTabs } from "../../../constants/tabs";
	export let selectedTab;

	const groupDetail = [
		{
			code: groupDetailTabs.members,
			title: "Members",
		},
		{
			code: groupDetailTabs.mappings,
			title: "Mappings",
		},
		{
			code: groupDetailTabs.permissions,
			title: "Permissions",
		},
	];

	function setCurrentTab(event) {
		updateQuerystringPartial({ tab: event.detail }, true);
	}
</script>

<TabsContainer>
	{#each groupDetail as tab}
		<Tab {selectedTab} code={tab.code} on:click={setCurrentTab}>
			{tab.title}</Tab
		>
	{/each}
</TabsContainer>
