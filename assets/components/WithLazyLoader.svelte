<script>
	import { getContext } from "svelte";
	import lazyLoader from "../helpers/lazy-loader";
	import { emptyPromise } from "../helpers/promise-helpers";
	import Loader from "./Loader.svelte";

	//TODO use real context
	export const cardLoadingContext = "cardLoadingContext";
	const context = getContext(cardLoadingContext);

	export let task;
	export let loading = false;
	export let parentLoading = false;

	let oldData;

	$: lazyTask =
		(task && lazyLoader(task, showLoader, hideLoader)) || emptyPromise;
	$: lazyTask?.then((x) => {
		oldData = x;
	});

	function showLoader() {
		setLoading(true);
	}

	function hideLoader() {
		setLoading(false);
	}

	function setLoading(loading_) {
		loading = loading_;
		context?.setLoading(loading_);
	}
</script>

{#await lazyTask}
	{#if loading && !parentLoading}
		<slot name="loader">
			<Loader />
		</slot>
	{:else}
		<slot data={oldData} />
	{/if}
{:then data}
	<slot {data} />
{:catch error}
	<slot name="catch" {error} />
{/await}
