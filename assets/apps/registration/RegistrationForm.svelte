<script>
  import { createEventDispatcher } from "svelte";

  export let name, password, email, errorMessage;

  const dispatch = createEventDispatcher();
</script>

<input
  type="text"
  class="form-control mb-3"
  id="name"
  name="name"
  placeholder="Your Name"
  bind:value={name}
/>
<input
  type="email"
  class="form-control mb-3"
  id="email"
  name="email"
  placeholder="Your Email"
  bind:value={email}
/>
<input
  type="password"
  class="form-control mb-3"
  id="password"
  name="password"
  placeholder="Password"
  bind:value={password}
/>
{#if errorMessage}
  <div class="alert alert-danger" role="alert">
    {errorMessage}
  </div>
{/if}
<button
  type="submit"
  value="send"
  class="btn btn-secondary mb-1"
  on:click={() => dispatch("register")}>REGISTER</button
>
