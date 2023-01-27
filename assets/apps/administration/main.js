import Root from "./Root.svelte";
import { currentUser, tenant } from "../../auth/auth-store";
// instantiate the component
function constructor(element, props) {
	currentUser.set(window.currentUser);
	tenant.set(props.tenant);
	new Root({
		// mount it to `document.body`
		target: element,

		props: props,
	});
}

window.AppsManager.register("administration", constructor);
