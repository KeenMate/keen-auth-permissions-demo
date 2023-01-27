<script>
	import { createEventDispatcher } from "svelte";

	export let name, password, email, errorMessage;

	const dispatch = createEventDispatcher();
</script>

<div class="input-group input-group-static mb-4">
	<label for="name"> Display name</label>
	<input
		type="text"
		class="form-control mb-3"
		id="name"
		name="name"
		placeholder="Your Name"
		bind:value={name}
	/>
</div>
<div class="input-group input-group-static mb-4">
	<label for="email">Email</label>
	<input
		type="email"
		class="form-control mb-3"
		id="email"
		name="email"
		placeholder="Your Email"
		bind:value={email}
	/>
</div>
<div class="input-group input-group-static mb-4">
	<label for="password">Password</label>
	<input
		type="password"
		class="form-control mb-3"
		id="password"
		name="password"
		placeholder="Password"
		bind:value={password}
	/>
</div>
{#if errorMessage}
	<div class="alert alert-danger" role="alert">
		{errorMessage}
	</div>
{/if}
<div>
	<button
		type="submit"
		value="send"
		class="btn btn-primary mb-1"
		on:click={() => dispatch("register")}>REGISTER</button
	>

	<a href="/login" class="text-muted">Already have an account</a>
</div>
