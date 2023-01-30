<script>
	import WithLazyLoader from "../../components/WithLazyLoader.svelte";
	import ApiManager from "../../providers/auth-provider";
	import { redirect } from "../../helpers/helpers";
	import { isEmpty, isValidEmail } from "../../helpers/validationHelpers";

	let email;

	let errorMessage = "",
		complete = false;
	let loading = false;

	async function sendRequest(method) {
		if (!isValid()) {
			return;
		}
		loading = true;

		try {
			await ApiManager.ForgottenPassword(email, method);
			complete = method;

			if (method === "sms") {
				redirect("/sms-reset", 2000);
			}
		} catch (res) {
			console.warn(res);
			if (res?.error) {
				errorMessage = res?.error?.msg;
			} else {
				errorMessage = "Server error";
			}
		}
		loading = false;
	}

	function isValid() {
		if (isEmpty(email)) {
			errorMessage = "Email cant be empty";
			return false;
		}

		if (!isValidEmail(email)) {
			errorMessage = "Email isnt valid";
			return false;
		}

		errorMessage = "";
		return true;
	}
</script>

<WithLazyLoader bind:loading>
	{#if !complete}
		<div class="input-group input-group-static mb-4">
			<input
				type="email"
				class="form-control mb-3"
				id="email"
				name="email"
				placeholder="Your Email"
				bind:value={email}
			/>
		</div>

		<button
			type="submit"
			value="send"
			class="btn btn-primary"
			on:click={() => {
				sendRequest("email");
			}}>EMAIL RESET</button
		>
		<button
			type="submit"
			value="send"
			class="btn btn-primary"
			on:click={() => {
				sendRequest("sms");
			}}>SMS RESET</button
		>
		{#if errorMessage}
			<div class="alert alert-danger" role="alert">
				{errorMessage}
			</div>
		{/if}
	{:else}
		<div class="alert alert-success" role="alert">
			{#if complete === "sms"}
				Reset code send.
			{:else}
				Reset link send to your email, click on intros.
			{/if}
		</div>
	{/if}
</WithLazyLoader>
