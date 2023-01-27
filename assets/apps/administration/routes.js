import GroupsList from "./pages/GroupsList.svelte";
import GroupDetail from "./pages/GroupDetail.svelte";
import CreateGroupForm from "./pages/CreateGroupForm.svelte";
import NotFound from "./pages/NotFound.svelte";
// routes
export default {
	// groups
	"/groups": GroupsList,
	"/groups/create": CreateGroupForm,
	"/groups/:group": GroupDetail,

	// Catch-all
	// This is optional, but if present it must be the last
	"*": NotFound,
};
