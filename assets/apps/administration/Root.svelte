<script>
	import Router, { link } from "svelte-spa-router";
	import routes, { Pages } from "./routes";
	import { currentUser, tenant } from "../../auth/auth-store";
	import Modal from "../../components/Modal.svelte";

	$: console.log($currentUser);
	$: console.log($tenant);
	console.log($currentUser);
</script>

<Modal>
	<div class="mt-1">
		<Router {routes} />
	</div>
</Modal>
