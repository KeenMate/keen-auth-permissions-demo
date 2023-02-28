import GroupsList from "./pages/GroupsList.svelte";
import GroupDetail from "./pages/GroupDetail.svelte";
import CreateGroupForm from "./pages/CreateGroupForm.svelte";
import NotFound from "./pages/NotFound.svelte";

export const Pages = [
	{
		name: "GroupList",
		title: "Groups",
		url: "/groups",
	},
	{
		name: "CreateGroupForm",
		title: "Create group",
		url: "/groups/create",
		icon: "fas fa-map",
	},
	{
		name: "GroupDetail",
		title: "Get group",
		url: "/groups/:group",
		icon: "fas fa-map",
		hide: true,
	},
];



export const PageUrls = Pages.reduce((acc, x) => {
	// filter irrelevant pages
	if (!x) return acc;

	acc[x.name] = x.url;
	return acc;
}, {});


const routerPages = {
	[PageUrls.GroupList]: GroupsList,
	[PageUrls.CreateGroupForm]: CreateGroupForm,
	[PageUrls.GroupDetail]: GroupDetail,
	// The catch-all route must always be last
	"*": NotFound,
};

export default routerPages;