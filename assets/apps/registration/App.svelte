<script>
  import Loader from "../../components/Loader.svelte";
  import { redirect } from "../../helpers/helpers";
  import { isEmpty, isValidEmail } from "../../helpers/validationHelpers";
  import Manager from "../../managers/ApiManager";
  import RegistrationForm from "./RegistrationForm.svelte";

  let name, password, email;

  let errorMessage = "",
    complete = false;
  let loading = false;

  function register() {
    if (!isValid()) {
      return;
    }

    loading = true;

    Manager.Register(name, email, password)
      .then(() => {
        complete = true;
        redirect("login", 5000);
      })
      .catch((res) => {
        console.warn(res);
        if (res?.error) {
          errorMessage = res?.error?.msg;
        }
      })
      .finally(() => {
        loading = false;
      });
  }

  function isValid() {
    if (isEmpty(name) || name.lenght > 4) {
      errorMessage = "Name has to be at least 4 characters long";
      return false;
    }

    if (isEmpty(email) || !isValidEmail(email)) {
      errorMessage = "Email need to be valid";
      return false;
    }

    if (isEmpty(password) || password.lenght < 8) {
      errorMessage = "Password has to be at least 4 characters long";
      return false;
    }
    errorMessage = "";
    return true;
  }
</script>

<Loader bind:loading>
  {#if !complete}
    <RegistrationForm
      bind:name
      bind:password
      bind:email
      bind:errorMessage
      on:register={register}
    />
  {:else}
    <div class="alert alert-success" role="alert">
      Registration successfull, click on link in email we send you to activate
      account.
    </div>
  {/if}
</Loader>
