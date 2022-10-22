<script>
  import Loader from "../../components/Loader.svelte";
  import ApiManager from "../../managers/ApiManager";
  import { redirectHome } from "../../helpers/helpers";

  let email;

  let errorMessage = "",
    complete = false;
  let loading = false;

  function sendRequest(method) {
    loading = true;
    if (!isValid()) {
      return;
    }

    ApiManager.ForgottenPassword(email, method)
      .then((res) => {
        complete = true;
        redirectHome(1500);
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
    errorMessage = "";
    return true;
  }
</script>

<Loader bind:loading>
  {#if !complete}
    <input
      type="email"
      class="form-control mb-3"
      id="email"
      name="email"
      placeholder="Your Email"
      bind:value={email}
    />

    <button
      type="submit"
      value="send"
      class="btn btn-secondary"
      on:click={() => {
        sendRequest("email");
      }}>EMAIL RESET</button
    >
    <button
      type="submit"
      value="send"
      class="btn btn-secondary"
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
    <div class="alert alert-success" role="alert">Reset link send.</div>
  {/if}
</Loader>
