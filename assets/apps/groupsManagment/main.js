import GroupsManagment from "./GroupsManagment.svelte";

// instantiate the component
function constructor(element, props) {
	new GroupsManagment({
		// mount it to `document.body`
		target: element,

		props: props,
	});
}

window.AppsManager.register("groupsManagment", constructor);
