<script>
	import WithLazyLoader from "../../components/WithLazyLoader.svelte";
	import ApiManager from "../../providers/auth-provider";
	import { redirect } from "../../helpers/helpers";

	export let token, type;

	let password, passwordAgain;

	let errorMessage = "",
		complete = false;
	let loading = false;

	function sendRequest() {
		if (!isValid()) {
			return;
		}
		loading = true;

		ApiManager.PasswordReset(token, type, password)
			.then(() => {
				complete = true;
				redirect("login", 3000);
			})
			.catch((res) => {
				console.warn(res);
				if (res?.error) {
					errorMessage = res?.error?.msg;
				} else {
					errorMessage = "Server error";
				}
			})
			.finally(() => {
				loading = false;
			});
	}

	function isValid() {
		if (password !== passwordAgain) {
			errorMessage = "Password are not same";
			return false;
		}

		errorMessage = "";
		return true;
	}
</script>

<WithLazyLoader bind:loading>
	{#if !complete}
		<div class="input-group input-group-static mb-4">
			<label for="password">Password</label>
			<input
				type="password"
				class="form-control mb-3"
				id="password"
				name="password"
				placeholder="New Password"
				bind:value={password}
			/>
		</div>
		<div class="input-group input-group-static mb-4">
			<label for="password_verification">Password again</label>

			<input
				type="password"
				class="form-control mb-3"
				id="password_verification"
				name="password_verification"
				placeholder="Password Verification"
				bind:value={passwordAgain}
			/>
		</div>

		<button
			type="submit"
			value="send"
			class="btn btn-success"
			on:click={sendRequest}>CHANGE PASSWORD</button
		>
		{#if errorMessage}
			<div class="alert alert-danger" role="alert">
				{errorMessage}
			</div>
		{/if}
	{:else}
		<div class="alert alert-success" role="alert">
			Password reseted successfully. You can now login with you new password.
		</div>
	{/if}
</WithLazyLoader>
