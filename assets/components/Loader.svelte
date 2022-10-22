<script>
  export let loading;
</script>

<div style="position: relative;">
  {#if loading}
    <div class="b-overlay position-absolute" style="inset: 0px; z-index: 10;">
      <div
        class="position-absolute bg-light rounded-sm"
        style="inset: 0px; opacity: 0.85; backdrop-filter: blur(2px);"
      />
      <div
        class="position-absolute"
        style="top: 50%; left: 50%; transform: translateX(-50%) translateY(-50%);"
      >
        <span aria-hidden="true" class="spinner-border"><!----></span>
      </div>
    </div>
  {/if}
  <slot />
</div>
