import App from "./App.svelte";

// instantiate the component
function constructor(element, props) {
  new App({
    // mount it to `document.body`
    target: element,

    props: props,
  });
}

window.AppsManager.register("forgottenPassword", constructor);
