<script>
  import WithLazyLoader from "../../components/WithLazyLoader.svelte";
  import ApiManager from "../../providers/auth-provider";
  import { redirect } from "../../helpers/helpers";
  import { isEmpty } from "../../helpers/validationHelpers";

  let token;

  let errorMessage = "",
    complete = false;
  let loading = false;

  function sendRequest() {
    if (!isValid()) {
      return;
    }
    loading = true;

    ApiManager.SmsToken(token)
      .then((res) => {
        console.log(res);
        console.log("WTFFFFFFFFFFFFFFFFFFFFFFFF");
        complete = true;
        redirect(res.data, 500);
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
    if (isEmpty(token)) {
      errorMessage = "Token cant be empty";
      return false;
    }

    errorMessage = "";
    return true;
  }
</script>

<WithLazyLoader bind:loading>
  {#if !complete}
    <input
      class="form-control mb-3"
      id="token"
      name="token"
      placeholder="Enter your reset token"
      bind:value={token}
    />

    <button
      type="submit"
      value="send"
      class="btn btn-secondary"
      on:click={sendRequest}>SUBMIT</button
    >
    {#if errorMessage}
      <div class="alert alert-danger" role="alert">
        {errorMessage}
      </div>
    {/if}
  {:else}
    <div class="alert alert-success" role="alert">
      Redirecting to password reset page
    </div>
  {/if}
</WithLazyLoader>
