<script>
  import Loader from "../../components/Loader.svelte";
  import ApiManager from "../../managers/ApiManager";
  import { redirect, redirectHome } from "../../helpers/helpers";

  let password, passwordAgain;

  let errorMessage = "",
    complete = false;
  let loading = false;

  function sendRequest() {
    loading = true;
    if (!isValid()) {
      return;
    }

    ApiManager.PasswordReset(password)
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

<Loader bind:loading>
  {#if !complete}
    <input
      type="password"
      class="form-control mb-3"
      id="password"
      name="password"
      placeholder="New Password"
      bind:value={password}
    />
    <input
      type="password"
      class="form-control mb-3"
      id="password_verification"
      name="password_verification"
      placeholder="Password Verification"
      bind:value={passwordAgain}
    />

    <button
      type="submit"
      value="send"
      class="btn btn-secondary"
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
</Loader>
