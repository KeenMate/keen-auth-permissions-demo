<script>
	import WithLazyLoader from "../../components/WithLazyLoader.svelte";
	import ApiManager from "../../providers/auth-provider";
	import { redirect } from "../../helpers/helpers";
	import { isEmpty, isValidEmail } from "../../helpers/validationHelpers";

	let email;

	let errorMessage = "",
		complete = false;
	let loading = false;

	async function sendRequest() {
		if (!isValid()) {
			return;
		}
		loading = true;

		try {
			await ApiManager.ResendVerification(email);
			complete = true;

			redirect("/login", 2000);
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
				name="email"
				id="email"
				class="form-control mb-3"
				placeholder="Email"
				bind:value={email}
			/>
		</div>

		<input
			type="submit"
			value="resend"
			class="btn btn-primary"
			on:click={sendRequest}
		/>
		{#if errorMessage}
			<div class="alert alert-danger" role="alert">
				{errorMessage}
			</div>
		{/if}
	{:else}
		<div class="alert alert-success" role="alert">
			{#if complete}
				Verification email send.
			{/if}
		</div>
	{/if}
</WithLazyLoader>
