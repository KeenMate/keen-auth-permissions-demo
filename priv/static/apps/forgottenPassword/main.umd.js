(function(factory) {
  typeof define === "function" && define.amd ? define(factory) : factory();
})(function() {
  "use strict";
  function noop() {
  }
  function assign(tar, src) {
    for (const k in src)
      tar[k] = src[k];
    return tar;
  }
  function add_location(element2, file2, line, column, char) {
    element2.__svelte_meta = {
      loc: { file: file2, line, column, char }
    };
  }
  function run(fn) {
    return fn();
  }
  function blank_object() {
    return /* @__PURE__ */ Object.create(null);
  }
  function run_all(fns) {
    fns.forEach(run);
  }
  function is_function(thing) {
    return typeof thing === "function";
  }
  function safe_not_equal(a, b) {
    return a != a ? b == b : a !== b || (a && typeof a === "object" || typeof a === "function");
  }
  function is_empty(obj) {
    return Object.keys(obj).length === 0;
  }
  function create_slot(definition, ctx, $$scope, fn) {
    if (definition) {
      const slot_ctx = get_slot_context(definition, ctx, $$scope, fn);
      return definition[0](slot_ctx);
    }
  }
  function get_slot_context(definition, ctx, $$scope, fn) {
    return definition[1] && fn ? assign($$scope.ctx.slice(), definition[1](fn(ctx))) : $$scope.ctx;
  }
  function get_slot_changes(definition, $$scope, dirty, fn) {
    if (definition[2] && fn) {
      const lets = definition[2](fn(dirty));
      if ($$scope.dirty === void 0) {
        return lets;
      }
      if (typeof lets === "object") {
        const merged = [];
        const len = Math.max($$scope.dirty.length, lets.length);
        for (let i = 0; i < len; i += 1) {
          merged[i] = $$scope.dirty[i] | lets[i];
        }
        return merged;
      }
      return $$scope.dirty | lets;
    }
    return $$scope.dirty;
  }
  function update_slot_base(slot, slot_definition, ctx, $$scope, slot_changes, get_slot_context_fn) {
    if (slot_changes) {
      const slot_context = get_slot_context(slot_definition, ctx, $$scope, get_slot_context_fn);
      slot.p(slot_context, slot_changes);
    }
  }
  function get_all_dirty_from_scope($$scope) {
    if ($$scope.ctx.length > 32) {
      const dirty = [];
      const length = $$scope.ctx.length / 32;
      for (let i = 0; i < length; i++) {
        dirty[i] = -1;
      }
      return dirty;
    }
    return -1;
  }
  function append(target, node) {
    target.appendChild(node);
  }
  function insert(target, node, anchor) {
    target.insertBefore(node, anchor || null);
  }
  function detach(node) {
    node.parentNode.removeChild(node);
  }
  function element(name) {
    return document.createElement(name);
  }
  function text(data) {
    return document.createTextNode(data);
  }
  function space() {
    return text(" ");
  }
  function empty() {
    return text("");
  }
  function listen(node, event, handler, options) {
    node.addEventListener(event, handler, options);
    return () => node.removeEventListener(event, handler, options);
  }
  function attr(node, attribute, value) {
    if (value == null)
      node.removeAttribute(attribute);
    else if (node.getAttribute(attribute) !== value)
      node.setAttribute(attribute, value);
  }
  function children(element2) {
    return Array.from(element2.childNodes);
  }
  function set_input_value(input, value) {
    input.value = value == null ? "" : value;
  }
  function set_style(node, key, value, important) {
    if (value === null) {
      node.style.removeProperty(key);
    } else {
      node.style.setProperty(key, value, important ? "important" : "");
    }
  }
  function custom_event(type, detail, { bubbles = false, cancelable = false } = {}) {
    const e = document.createEvent("CustomEvent");
    e.initCustomEvent(type, bubbles, cancelable, detail);
    return e;
  }
  let current_component;
  function set_current_component(component) {
    current_component = component;
  }
  const dirty_components = [];
  const binding_callbacks = [];
  const render_callbacks = [];
  const flush_callbacks = [];
  const resolved_promise = Promise.resolve();
  let update_scheduled = false;
  function schedule_update() {
    if (!update_scheduled) {
      update_scheduled = true;
      resolved_promise.then(flush);
    }
  }
  function add_render_callback(fn) {
    render_callbacks.push(fn);
  }
  function add_flush_callback(fn) {
    flush_callbacks.push(fn);
  }
  const seen_callbacks = /* @__PURE__ */ new Set();
  let flushidx = 0;
  function flush() {
    const saved_component = current_component;
    do {
      while (flushidx < dirty_components.length) {
        const component = dirty_components[flushidx];
        flushidx++;
        set_current_component(component);
        update(component.$$);
      }
      set_current_component(null);
      dirty_components.length = 0;
      flushidx = 0;
      while (binding_callbacks.length)
        binding_callbacks.pop()();
      for (let i = 0; i < render_callbacks.length; i += 1) {
        const callback = render_callbacks[i];
        if (!seen_callbacks.has(callback)) {
          seen_callbacks.add(callback);
          callback();
        }
      }
      render_callbacks.length = 0;
    } while (dirty_components.length);
    while (flush_callbacks.length) {
      flush_callbacks.pop()();
    }
    update_scheduled = false;
    seen_callbacks.clear();
    set_current_component(saved_component);
  }
  function update($$) {
    if ($$.fragment !== null) {
      $$.update();
      run_all($$.before_update);
      const dirty = $$.dirty;
      $$.dirty = [-1];
      $$.fragment && $$.fragment.p($$.ctx, dirty);
      $$.after_update.forEach(add_render_callback);
    }
  }
  const outroing = /* @__PURE__ */ new Set();
  let outros;
  function transition_in(block, local) {
    if (block && block.i) {
      outroing.delete(block);
      block.i(local);
    }
  }
  function transition_out(block, local, detach2, callback) {
    if (block && block.o) {
      if (outroing.has(block))
        return;
      outroing.add(block);
      outros.c.push(() => {
        outroing.delete(block);
        if (callback) {
          if (detach2)
            block.d(1);
          callback();
        }
      });
      block.o(local);
    } else if (callback) {
      callback();
    }
  }
  const globals = typeof window !== "undefined" ? window : typeof globalThis !== "undefined" ? globalThis : global;
  function bind(component, name, callback) {
    const index = component.$$.props[name];
    if (index !== void 0) {
      component.$$.bound[index] = callback;
      callback(component.$$.ctx[index]);
    }
  }
  function create_component(block) {
    block && block.c();
  }
  function mount_component(component, target, anchor, customElement) {
    const { fragment, after_update } = component.$$;
    fragment && fragment.m(target, anchor);
    if (!customElement) {
      add_render_callback(() => {
        const new_on_destroy = component.$$.on_mount.map(run).filter(is_function);
        if (component.$$.on_destroy) {
          component.$$.on_destroy.push(...new_on_destroy);
        } else {
          run_all(new_on_destroy);
        }
        component.$$.on_mount = [];
      });
    }
    after_update.forEach(add_render_callback);
  }
  function destroy_component(component, detaching) {
    const $$ = component.$$;
    if ($$.fragment !== null) {
      run_all($$.on_destroy);
      $$.fragment && $$.fragment.d(detaching);
      $$.on_destroy = $$.fragment = null;
      $$.ctx = [];
    }
  }
  function make_dirty(component, i) {
    if (component.$$.dirty[0] === -1) {
      dirty_components.push(component);
      schedule_update();
      component.$$.dirty.fill(0);
    }
    component.$$.dirty[i / 31 | 0] |= 1 << i % 31;
  }
  function init(component, options, instance2, create_fragment2, not_equal, props, append_styles, dirty = [-1]) {
    const parent_component = current_component;
    set_current_component(component);
    const $$ = component.$$ = {
      fragment: null,
      ctx: [],
      props,
      update: noop,
      not_equal,
      bound: blank_object(),
      on_mount: [],
      on_destroy: [],
      on_disconnect: [],
      before_update: [],
      after_update: [],
      context: new Map(options.context || (parent_component ? parent_component.$$.context : [])),
      callbacks: blank_object(),
      dirty,
      skip_bound: false,
      root: options.target || parent_component.$$.root
    };
    append_styles && append_styles($$.root);
    let ready = false;
    $$.ctx = instance2 ? instance2(component, options.props || {}, (i, ret, ...rest) => {
      const value = rest.length ? rest[0] : ret;
      if ($$.ctx && not_equal($$.ctx[i], $$.ctx[i] = value)) {
        if (!$$.skip_bound && $$.bound[i])
          $$.bound[i](value);
        if (ready)
          make_dirty(component, i);
      }
      return ret;
    }) : [];
    $$.update();
    ready = true;
    run_all($$.before_update);
    $$.fragment = create_fragment2 ? create_fragment2($$.ctx) : false;
    if (options.target) {
      if (options.hydrate) {
        const nodes = children(options.target);
        $$.fragment && $$.fragment.l(nodes);
        nodes.forEach(detach);
      } else {
        $$.fragment && $$.fragment.c();
      }
      if (options.intro)
        transition_in(component.$$.fragment);
      mount_component(component, options.target, options.anchor, options.customElement);
      flush();
    }
    set_current_component(parent_component);
  }
  class SvelteComponent {
    $destroy() {
      destroy_component(this, 1);
      this.$destroy = noop;
    }
    $on(type, callback) {
      if (!is_function(callback)) {
        return noop;
      }
      const callbacks = this.$$.callbacks[type] || (this.$$.callbacks[type] = []);
      callbacks.push(callback);
      return () => {
        const index = callbacks.indexOf(callback);
        if (index !== -1)
          callbacks.splice(index, 1);
      };
    }
    $set($$props) {
      if (this.$$set && !is_empty($$props)) {
        this.$$.skip_bound = true;
        this.$$set($$props);
        this.$$.skip_bound = false;
      }
    }
  }
  function dispatch_dev(type, detail) {
    document.dispatchEvent(custom_event(type, Object.assign({ version: "3.51.0" }, detail), { bubbles: true }));
  }
  function append_dev(target, node) {
    dispatch_dev("SvelteDOMInsert", { target, node });
    append(target, node);
  }
  function insert_dev(target, node, anchor) {
    dispatch_dev("SvelteDOMInsert", { target, node, anchor });
    insert(target, node, anchor);
  }
  function detach_dev(node) {
    dispatch_dev("SvelteDOMRemove", { node });
    detach(node);
  }
  function listen_dev(node, event, handler, options, has_prevent_default, has_stop_propagation) {
    const modifiers = options === true ? ["capture"] : options ? Array.from(Object.keys(options)) : [];
    if (has_prevent_default)
      modifiers.push("preventDefault");
    if (has_stop_propagation)
      modifiers.push("stopPropagation");
    dispatch_dev("SvelteDOMAddEventListener", { node, event, handler, modifiers });
    const dispose = listen(node, event, handler, options);
    return () => {
      dispatch_dev("SvelteDOMRemoveEventListener", { node, event, handler, modifiers });
      dispose();
    };
  }
  function attr_dev(node, attribute, value) {
    attr(node, attribute, value);
    if (value == null)
      dispatch_dev("SvelteDOMRemoveAttribute", { node, attribute });
    else
      dispatch_dev("SvelteDOMSetAttribute", { node, attribute, value });
  }
  function set_data_dev(text2, data) {
    data = "" + data;
    if (text2.wholeText === data)
      return;
    dispatch_dev("SvelteDOMSetData", { node: text2, data });
    text2.data = data;
  }
  function validate_slots(name, slot, keys) {
    for (const slot_key of Object.keys(slot)) {
      if (!~keys.indexOf(slot_key)) {
        console.warn(`<${name}> received an unexpected slot "${slot_key}".`);
      }
    }
  }
  class SvelteComponentDev extends SvelteComponent {
    constructor(options) {
      if (!options || !options.target && !options.$$inline) {
        throw new Error("'target' is a required option");
      }
      super();
    }
    $destroy() {
      super.$destroy();
      this.$destroy = () => {
        console.warn("Component was already destroyed");
      };
    }
    $capture_state() {
    }
    $inject_state() {
    }
  }
  const file$1 = "C:/git/keen-auth-permissions-demo/assets/components/Loader.svelte";
  function create_if_block$1(ctx) {
    let div2;
    let div0;
    let t;
    let div1;
    let span;
    const block = {
      c: function create() {
        div2 = element("div");
        div0 = element("div");
        t = space();
        div1 = element("div");
        span = element("span");
        attr_dev(div0, "class", "position-absolute bg-light rounded-sm");
        set_style(div0, "inset", "0px");
        set_style(div0, "opacity", "0.85");
        set_style(div0, "backdrop-filter", "blur(2px)");
        add_location(div0, file$1, 7, 6, 184);
        attr_dev(span, "aria-hidden", "true");
        attr_dev(span, "class", "spinner-border");
        add_location(span, file$1, 15, 8, 475);
        attr_dev(div1, "class", "position-absolute");
        set_style(div1, "top", "50%");
        set_style(div1, "left", "50%");
        set_style(div1, "transform", "translateX(-50%) translateY(-50%)");
        add_location(div1, file$1, 11, 6, 333);
        attr_dev(div2, "class", "b-overlay position-absolute");
        set_style(div2, "inset", "0px");
        set_style(div2, "z-index", "10");
        add_location(div2, file$1, 6, 4, 102);
      },
      m: function mount(target, anchor) {
        insert_dev(target, div2, anchor);
        append_dev(div2, div0);
        append_dev(div2, t);
        append_dev(div2, div1);
        append_dev(div1, span);
      },
      d: function destroy(detaching) {
        if (detaching)
          detach_dev(div2);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_if_block$1.name,
      type: "if",
      source: "(6:2) {#if loading}",
      ctx
    });
    return block;
  }
  function create_fragment$1(ctx) {
    let div;
    let t;
    let current;
    let if_block = ctx[0] && create_if_block$1(ctx);
    const default_slot_template = ctx[2].default;
    const default_slot = create_slot(default_slot_template, ctx, ctx[1], null);
    const block = {
      c: function create() {
        div = element("div");
        if (if_block)
          if_block.c();
        t = space();
        if (default_slot)
          default_slot.c();
        set_style(div, "position", "relative");
        add_location(div, file$1, 4, 0, 46);
      },
      l: function claim(nodes) {
        throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
      },
      m: function mount(target, anchor) {
        insert_dev(target, div, anchor);
        if (if_block)
          if_block.m(div, null);
        append_dev(div, t);
        if (default_slot) {
          default_slot.m(div, null);
        }
        current = true;
      },
      p: function update2(ctx2, [dirty]) {
        if (ctx2[0]) {
          if (if_block)
            ;
          else {
            if_block = create_if_block$1(ctx2);
            if_block.c();
            if_block.m(div, t);
          }
        } else if (if_block) {
          if_block.d(1);
          if_block = null;
        }
        if (default_slot) {
          if (default_slot.p && (!current || dirty & 2)) {
            update_slot_base(
              default_slot,
              default_slot_template,
              ctx2,
              ctx2[1],
              !current ? get_all_dirty_from_scope(ctx2[1]) : get_slot_changes(default_slot_template, ctx2[1], dirty, null),
              null
            );
          }
        }
      },
      i: function intro(local) {
        if (current)
          return;
        transition_in(default_slot, local);
        current = true;
      },
      o: function outro(local) {
        transition_out(default_slot, local);
        current = false;
      },
      d: function destroy(detaching) {
        if (detaching)
          detach_dev(div);
        if (if_block)
          if_block.d();
        if (default_slot)
          default_slot.d(detaching);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_fragment$1.name,
      type: "component",
      source: "",
      ctx
    });
    return block;
  }
  function instance$1($$self, $$props, $$invalidate) {
    let { $$slots: slots = {}, $$scope } = $$props;
    validate_slots("Loader", slots, ["default"]);
    let { loading } = $$props;
    $$self.$$.on_mount.push(function() {
      if (loading === void 0 && !("loading" in $$props || $$self.$$.bound[$$self.$$.props["loading"]])) {
        console.warn("<Loader> was created without expected prop 'loading'");
      }
    });
    const writable_props = ["loading"];
    Object.keys($$props).forEach((key) => {
      if (!~writable_props.indexOf(key) && key.slice(0, 2) !== "$$" && key !== "slot")
        console.warn(`<Loader> was created with unknown prop '${key}'`);
    });
    $$self.$$set = ($$props2) => {
      if ("loading" in $$props2)
        $$invalidate(0, loading = $$props2.loading);
      if ("$$scope" in $$props2)
        $$invalidate(1, $$scope = $$props2.$$scope);
    };
    $$self.$capture_state = () => ({ loading });
    $$self.$inject_state = ($$props2) => {
      if ("loading" in $$props2)
        $$invalidate(0, loading = $$props2.loading);
    };
    if ($$props && "$$inject" in $$props) {
      $$self.$inject_state($$props.$$inject);
    }
    return [loading, $$scope, slots];
  }
  class Loader extends SvelteComponentDev {
    constructor(options) {
      super(options);
      init(this, options, instance$1, create_fragment$1, safe_not_equal, { loading: 0 });
      dispatch_dev("SvelteRegisterComponent", {
        component: this,
        tagName: "Loader",
        options,
        id: create_fragment$1.name
      });
    }
    get loading() {
      throw new Error("<Loader>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
    }
    set loading(value) {
      throw new Error("<Loader>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
    }
  }
  const baseApiUrl = "";
  const registrationUrl = baseApiUrl + "/register";
  const forgottenPasswordUrl = baseApiUrl + "/forgotten-password";
  class ApiManager {
    constructor() {
      this.token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
    }
    async Register(name, email, password) {
      return await this.FetchWithToken(registrationUrl, {
        name,
        email,
        password
      });
    }
    async ForgottenPassword(email, method) {
      return await this.FetchWithToken(forgottenPasswordUrl, {
        method,
        email
      });
    }
    async FetchWithToken(url, bodyObject, method = "post") {
      let res = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.token
        },
        body: JSON.stringify(bodyObject)
      });
      if (res.status === 200) {
        return await res.json();
      }
      if (res.status === 500) {
        throw await res.json();
      }
      console.log(res);
      throw "Error Comunication with server";
    }
  }
  const ApiManager$1 = new ApiManager();
  function redirectHome(time) {
    setTimeout(() => {
      window.location = "/";
    }, time);
  }
  const { console: console_1 } = globals;
  const file = "C:/git/keen-auth-permissions-demo/assets/apps/forgottenPassword/App.svelte";
  function create_else_block(ctx) {
    let div;
    const block = {
      c: function create() {
        div = element("div");
        div.textContent = "Reset link send.";
        attr_dev(div, "class", "alert alert-success");
        attr_dev(div, "role", "alert");
        add_location(div, file, 74, 4, 1577);
      },
      m: function mount(target, anchor) {
        insert_dev(target, div, anchor);
      },
      p: noop,
      d: function destroy(detaching) {
        if (detaching)
          detach_dev(div);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_else_block.name,
      type: "else",
      source: "(74:2) {:else}",
      ctx
    });
    return block;
  }
  function create_if_block(ctx) {
    let input;
    let t0;
    let button0;
    let t2;
    let button1;
    let t4;
    let if_block_anchor;
    let mounted;
    let dispose;
    let if_block = ctx[1] && create_if_block_1(ctx);
    const block = {
      c: function create() {
        input = element("input");
        t0 = space();
        button0 = element("button");
        button0.textContent = "EMAIL RESET";
        t2 = space();
        button1 = element("button");
        button1.textContent = "SMS RESET";
        t4 = space();
        if (if_block)
          if_block.c();
        if_block_anchor = empty();
        attr_dev(input, "type", "email");
        attr_dev(input, "class", "form-control mb-3");
        attr_dev(input, "id", "email");
        attr_dev(input, "name", "email");
        attr_dev(input, "placeholder", "Your Email");
        add_location(input, file, 43, 4, 913);
        attr_dev(button0, "type", "submit");
        button0.value = "send";
        attr_dev(button0, "class", "btn btn-secondary");
        add_location(button0, file, 52, 4, 1084);
        attr_dev(button1, "type", "submit");
        button1.value = "send";
        attr_dev(button1, "class", "btn btn-secondary");
        add_location(button1, file, 60, 4, 1264);
      },
      m: function mount(target, anchor) {
        insert_dev(target, input, anchor);
        set_input_value(input, ctx[0]);
        insert_dev(target, t0, anchor);
        insert_dev(target, button0, anchor);
        insert_dev(target, t2, anchor);
        insert_dev(target, button1, anchor);
        insert_dev(target, t4, anchor);
        if (if_block)
          if_block.m(target, anchor);
        insert_dev(target, if_block_anchor, anchor);
        if (!mounted) {
          dispose = [
            listen_dev(input, "input", ctx[5]),
            listen_dev(button0, "click", ctx[6], false, false, false),
            listen_dev(button1, "click", ctx[7], false, false, false)
          ];
          mounted = true;
        }
      },
      p: function update2(ctx2, dirty) {
        if (dirty & 1 && input.value !== ctx2[0]) {
          set_input_value(input, ctx2[0]);
        }
        if (ctx2[1]) {
          if (if_block) {
            if_block.p(ctx2, dirty);
          } else {
            if_block = create_if_block_1(ctx2);
            if_block.c();
            if_block.m(if_block_anchor.parentNode, if_block_anchor);
          }
        } else if (if_block) {
          if_block.d(1);
          if_block = null;
        }
      },
      d: function destroy(detaching) {
        if (detaching)
          detach_dev(input);
        if (detaching)
          detach_dev(t0);
        if (detaching)
          detach_dev(button0);
        if (detaching)
          detach_dev(t2);
        if (detaching)
          detach_dev(button1);
        if (detaching)
          detach_dev(t4);
        if (if_block)
          if_block.d(detaching);
        if (detaching)
          detach_dev(if_block_anchor);
        mounted = false;
        run_all(dispose);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_if_block.name,
      type: "if",
      source: "(43:2) {#if !complete}",
      ctx
    });
    return block;
  }
  function create_if_block_1(ctx) {
    let div;
    let t;
    const block = {
      c: function create() {
        div = element("div");
        t = text(ctx[1]);
        attr_dev(div, "class", "alert alert-danger");
        attr_dev(div, "role", "alert");
        add_location(div, file, 69, 6, 1466);
      },
      m: function mount(target, anchor) {
        insert_dev(target, div, anchor);
        append_dev(div, t);
      },
      p: function update2(ctx2, dirty) {
        if (dirty & 2)
          set_data_dev(t, ctx2[1]);
      },
      d: function destroy(detaching) {
        if (detaching)
          detach_dev(div);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_if_block_1.name,
      type: "if",
      source: "(69:4) {#if errorMessage}",
      ctx
    });
    return block;
  }
  function create_default_slot(ctx) {
    let if_block_anchor;
    function select_block_type(ctx2, dirty) {
      if (!ctx2[2])
        return create_if_block;
      return create_else_block;
    }
    let current_block_type = select_block_type(ctx);
    let if_block = current_block_type(ctx);
    const block = {
      c: function create() {
        if_block.c();
        if_block_anchor = empty();
      },
      m: function mount(target, anchor) {
        if_block.m(target, anchor);
        insert_dev(target, if_block_anchor, anchor);
      },
      p: function update2(ctx2, dirty) {
        if (current_block_type === (current_block_type = select_block_type(ctx2)) && if_block) {
          if_block.p(ctx2, dirty);
        } else {
          if_block.d(1);
          if_block = current_block_type(ctx2);
          if (if_block) {
            if_block.c();
            if_block.m(if_block_anchor.parentNode, if_block_anchor);
          }
        }
      },
      d: function destroy(detaching) {
        if_block.d(detaching);
        if (detaching)
          detach_dev(if_block_anchor);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_default_slot.name,
      type: "slot",
      source: "(42:0) <Loader bind:loading>",
      ctx
    });
    return block;
  }
  function create_fragment(ctx) {
    let loader;
    let updating_loading;
    let current;
    function loader_loading_binding(value) {
      ctx[8](value);
    }
    let loader_props = {
      $$slots: { default: [create_default_slot] },
      $$scope: { ctx }
    };
    if (ctx[3] !== void 0) {
      loader_props.loading = ctx[3];
    }
    loader = new Loader({ props: loader_props, $$inline: true });
    binding_callbacks.push(() => bind(loader, "loading", loader_loading_binding));
    const block = {
      c: function create() {
        create_component(loader.$$.fragment);
      },
      l: function claim(nodes) {
        throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
      },
      m: function mount(target, anchor) {
        mount_component(loader, target, anchor);
        current = true;
      },
      p: function update2(ctx2, [dirty]) {
        const loader_changes = {};
        if (dirty & 1031) {
          loader_changes.$$scope = { dirty, ctx: ctx2 };
        }
        if (!updating_loading && dirty & 8) {
          updating_loading = true;
          loader_changes.loading = ctx2[3];
          add_flush_callback(() => updating_loading = false);
        }
        loader.$set(loader_changes);
      },
      i: function intro(local) {
        if (current)
          return;
        transition_in(loader.$$.fragment, local);
        current = true;
      },
      o: function outro(local) {
        transition_out(loader.$$.fragment, local);
        current = false;
      },
      d: function destroy(detaching) {
        destroy_component(loader, detaching);
      }
    };
    dispatch_dev("SvelteRegisterBlock", {
      block,
      id: create_fragment.name,
      type: "component",
      source: "",
      ctx
    });
    return block;
  }
  function instance($$self, $$props, $$invalidate) {
    let { $$slots: slots = {}, $$scope } = $$props;
    validate_slots("App", slots, []);
    let email;
    let errorMessage = "", complete = false;
    let loading = false;
    function sendRequest(method) {
      $$invalidate(3, loading = true);
      if (!isValid())
        ;
      ApiManager$1.ForgottenPassword(email, method).then((res) => {
        $$invalidate(2, complete = true);
        redirectHome(1500);
      }).catch((res) => {
        var _a;
        console.warn(res);
        if (res == null ? void 0 : res.error) {
          $$invalidate(1, errorMessage = (_a = res == null ? void 0 : res.error) == null ? void 0 : _a.msg);
        } else {
          $$invalidate(1, errorMessage = "Server error");
        }
      }).finally(() => {
        $$invalidate(3, loading = false);
      });
    }
    function isValid() {
      $$invalidate(1, errorMessage = "");
      return true;
    }
    const writable_props = [];
    Object.keys($$props).forEach((key) => {
      if (!~writable_props.indexOf(key) && key.slice(0, 2) !== "$$" && key !== "slot")
        console_1.warn(`<App> was created with unknown prop '${key}'`);
    });
    function input_input_handler() {
      email = this.value;
      $$invalidate(0, email);
    }
    const click_handler = () => {
      sendRequest("email");
    };
    const click_handler_1 = () => {
      sendRequest("sms");
    };
    function loader_loading_binding(value) {
      loading = value;
      $$invalidate(3, loading);
    }
    $$self.$capture_state = () => ({
      Loader,
      ApiManager: ApiManager$1,
      redirectHome,
      email,
      errorMessage,
      complete,
      loading,
      sendRequest,
      isValid
    });
    $$self.$inject_state = ($$props2) => {
      if ("email" in $$props2)
        $$invalidate(0, email = $$props2.email);
      if ("errorMessage" in $$props2)
        $$invalidate(1, errorMessage = $$props2.errorMessage);
      if ("complete" in $$props2)
        $$invalidate(2, complete = $$props2.complete);
      if ("loading" in $$props2)
        $$invalidate(3, loading = $$props2.loading);
    };
    if ($$props && "$$inject" in $$props) {
      $$self.$inject_state($$props.$$inject);
    }
    return [
      email,
      errorMessage,
      complete,
      loading,
      sendRequest,
      input_input_handler,
      click_handler,
      click_handler_1,
      loader_loading_binding
    ];
  }
  class App extends SvelteComponentDev {
    constructor(options) {
      super(options);
      init(this, options, instance, create_fragment, safe_not_equal, {});
      dispatch_dev("SvelteRegisterComponent", {
        component: this,
        tagName: "App",
        options,
        id: create_fragment.name
      });
    }
  }
  function constructor(element2, props) {
    new App({
      target: element2,
      props
    });
  }
  window.AppsManager.register("forgottenPassword", constructor);
});
//# sourceMappingURL=main.umd.js.map
