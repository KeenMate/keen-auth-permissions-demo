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
function get_current_component() {
  if (!current_component)
    throw new Error("Function called outside component initialization");
  return current_component;
}
function createEventDispatcher() {
  const component = get_current_component();
  return (type, detail, { cancelable = false } = {}) => {
    const callbacks = component.$$.callbacks[type];
    if (callbacks) {
      const event = custom_event(type, detail, { cancelable });
      callbacks.slice().forEach((fn) => {
        fn.call(component, event);
      });
      return !event.defaultPrevented;
    }
    return true;
  };
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
function group_outros() {
  outros = {
    r: 0,
    c: [],
    p: outros
  };
}
function check_outros() {
  if (!outros.r) {
    run_all(outros.c);
  }
  outros = outros.p;
}
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
const file$2 = "C:/git/keen-auth-permissions-demo/assets/components/Loader.svelte";
function create_if_block$2(ctx) {
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
      add_location(div0, file$2, 7, 6, 184);
      attr_dev(span, "aria-hidden", "true");
      attr_dev(span, "class", "spinner-border");
      add_location(span, file$2, 15, 8, 475);
      attr_dev(div1, "class", "position-absolute");
      set_style(div1, "top", "50%");
      set_style(div1, "left", "50%");
      set_style(div1, "transform", "translateX(-50%) translateY(-50%)");
      add_location(div1, file$2, 11, 6, 333);
      attr_dev(div2, "class", "b-overlay position-absolute");
      set_style(div2, "inset", "0px");
      set_style(div2, "z-index", "10");
      add_location(div2, file$2, 6, 4, 102);
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
    id: create_if_block$2.name,
    type: "if",
    source: "(6:2) {#if loading}",
    ctx
  });
  return block;
}
function create_fragment$2(ctx) {
  let div;
  let t;
  let current;
  let if_block = ctx[0] && create_if_block$2(ctx);
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
      add_location(div, file$2, 4, 0, 46);
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
          if_block = create_if_block$2(ctx2);
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
    id: create_fragment$2.name,
    type: "component",
    source: "",
    ctx
  });
  return block;
}
function instance$2($$self, $$props, $$invalidate) {
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
    init(this, options, instance$2, create_fragment$2, safe_not_equal, { loading: 0 });
    dispatch_dev("SvelteRegisterComponent", {
      component: this,
      tagName: "Loader",
      options,
      id: create_fragment$2.name
    });
  }
  get loading() {
    throw new Error("<Loader>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  set loading(value) {
    throw new Error("<Loader>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
}
function redirectHome(time) {
  setTimeout(() => {
    window.location = "/";
  }, time);
}
function getQueryVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i = 0; i < vars.length; i++) {
    var pair = vars[i].split("=");
    if (decodeURIComponent(pair[0]) == variable) {
      return decodeURIComponent(pair[1]);
    }
  }
  console.log("Query variable %s not found", variable);
}
function isEmpty(s) {
  return s === null || s === void 0 || s === "";
}
function isValidEmail(email) {
  return String(email).toLowerCase().match(
    /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  );
}
const baseApiUrl = "";
const registrationUrl = baseApiUrl + "/register";
const forgottenPasswordUrl = baseApiUrl + "/forgotten-password";
const resetPasswrodUrl = (token, method) => baseApiUrl + `/reset-password?token=${token}&method=${method}`;
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
  async PasswordReset(password) {
    let url = resetPasswrodUrl(
      getQueryVariable("token"),
      getQueryVariable("method")
    );
    return await this.FetchWithToken(url, {
      password
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
const Manager = new ApiManager();
const file$1 = "C:/git/keen-auth-permissions-demo/assets/apps/registration/RegistrationForm.svelte";
function create_if_block$1(ctx) {
  let div;
  let t;
  const block = {
    c: function create() {
      div = element("div");
      t = text(ctx[3]);
      attr_dev(div, "class", "alert alert-danger");
      attr_dev(div, "role", "alert");
      add_location(div, file$1, 33, 2, 612);
    },
    m: function mount(target, anchor) {
      insert_dev(target, div, anchor);
      append_dev(div, t);
    },
    p: function update2(ctx2, dirty) {
      if (dirty & 8)
        set_data_dev(t, ctx2[3]);
    },
    d: function destroy(detaching) {
      if (detaching)
        detach_dev(div);
    }
  };
  dispatch_dev("SvelteRegisterBlock", {
    block,
    id: create_if_block$1.name,
    type: "if",
    source: "(33:0) {#if errorMessage}",
    ctx
  });
  return block;
}
function create_fragment$1(ctx) {
  let input0;
  let t0;
  let input1;
  let t1;
  let input2;
  let t2;
  let t3;
  let button;
  let mounted;
  let dispose;
  let if_block = ctx[3] && create_if_block$1(ctx);
  const block = {
    c: function create() {
      input0 = element("input");
      t0 = space();
      input1 = element("input");
      t1 = space();
      input2 = element("input");
      t2 = space();
      if (if_block)
        if_block.c();
      t3 = space();
      button = element("button");
      button.textContent = "REGISTER";
      attr_dev(input0, "type", "text");
      attr_dev(input0, "class", "form-control mb-3");
      attr_dev(input0, "id", "name");
      attr_dev(input0, "name", "name");
      attr_dev(input0, "placeholder", "Your Name");
      add_location(input0, file$1, 8, 0, 174);
      attr_dev(input1, "type", "email");
      attr_dev(input1, "class", "form-control mb-3");
      attr_dev(input1, "id", "email");
      attr_dev(input1, "name", "email");
      attr_dev(input1, "placeholder", "Your Email");
      add_location(input1, file$1, 16, 0, 306);
      attr_dev(input2, "type", "password");
      attr_dev(input2, "class", "form-control mb-3");
      attr_dev(input2, "id", "password");
      attr_dev(input2, "name", "password");
      attr_dev(input2, "placeholder", "Password");
      add_location(input2, file$1, 24, 0, 443);
      attr_dev(button, "type", "submit");
      button.value = "send";
      attr_dev(button, "class", "btn btn-secondary mb-1");
      add_location(button, file$1, 37, 0, 696);
    },
    l: function claim(nodes) {
      throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    },
    m: function mount(target, anchor) {
      insert_dev(target, input0, anchor);
      set_input_value(input0, ctx[0]);
      insert_dev(target, t0, anchor);
      insert_dev(target, input1, anchor);
      set_input_value(input1, ctx[2]);
      insert_dev(target, t1, anchor);
      insert_dev(target, input2, anchor);
      set_input_value(input2, ctx[1]);
      insert_dev(target, t2, anchor);
      if (if_block)
        if_block.m(target, anchor);
      insert_dev(target, t3, anchor);
      insert_dev(target, button, anchor);
      if (!mounted) {
        dispose = [
          listen_dev(input0, "input", ctx[5]),
          listen_dev(input1, "input", ctx[6]),
          listen_dev(input2, "input", ctx[7]),
          listen_dev(button, "click", ctx[8], false, false, false)
        ];
        mounted = true;
      }
    },
    p: function update2(ctx2, [dirty]) {
      if (dirty & 1 && input0.value !== ctx2[0]) {
        set_input_value(input0, ctx2[0]);
      }
      if (dirty & 4 && input1.value !== ctx2[2]) {
        set_input_value(input1, ctx2[2]);
      }
      if (dirty & 2 && input2.value !== ctx2[1]) {
        set_input_value(input2, ctx2[1]);
      }
      if (ctx2[3]) {
        if (if_block) {
          if_block.p(ctx2, dirty);
        } else {
          if_block = create_if_block$1(ctx2);
          if_block.c();
          if_block.m(t3.parentNode, t3);
        }
      } else if (if_block) {
        if_block.d(1);
        if_block = null;
      }
    },
    i: noop,
    o: noop,
    d: function destroy(detaching) {
      if (detaching)
        detach_dev(input0);
      if (detaching)
        detach_dev(t0);
      if (detaching)
        detach_dev(input1);
      if (detaching)
        detach_dev(t1);
      if (detaching)
        detach_dev(input2);
      if (detaching)
        detach_dev(t2);
      if (if_block)
        if_block.d(detaching);
      if (detaching)
        detach_dev(t3);
      if (detaching)
        detach_dev(button);
      mounted = false;
      run_all(dispose);
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
  validate_slots("RegistrationForm", slots, []);
  let { name, password, email, errorMessage } = $$props;
  const dispatch = createEventDispatcher();
  $$self.$$.on_mount.push(function() {
    if (name === void 0 && !("name" in $$props || $$self.$$.bound[$$self.$$.props["name"]])) {
      console.warn("<RegistrationForm> was created without expected prop 'name'");
    }
    if (password === void 0 && !("password" in $$props || $$self.$$.bound[$$self.$$.props["password"]])) {
      console.warn("<RegistrationForm> was created without expected prop 'password'");
    }
    if (email === void 0 && !("email" in $$props || $$self.$$.bound[$$self.$$.props["email"]])) {
      console.warn("<RegistrationForm> was created without expected prop 'email'");
    }
    if (errorMessage === void 0 && !("errorMessage" in $$props || $$self.$$.bound[$$self.$$.props["errorMessage"]])) {
      console.warn("<RegistrationForm> was created without expected prop 'errorMessage'");
    }
  });
  const writable_props = ["name", "password", "email", "errorMessage"];
  Object.keys($$props).forEach((key) => {
    if (!~writable_props.indexOf(key) && key.slice(0, 2) !== "$$" && key !== "slot")
      console.warn(`<RegistrationForm> was created with unknown prop '${key}'`);
  });
  function input0_input_handler() {
    name = this.value;
    $$invalidate(0, name);
  }
  function input1_input_handler() {
    email = this.value;
    $$invalidate(2, email);
  }
  function input2_input_handler() {
    password = this.value;
    $$invalidate(1, password);
  }
  const click_handler = () => dispatch("register");
  $$self.$$set = ($$props2) => {
    if ("name" in $$props2)
      $$invalidate(0, name = $$props2.name);
    if ("password" in $$props2)
      $$invalidate(1, password = $$props2.password);
    if ("email" in $$props2)
      $$invalidate(2, email = $$props2.email);
    if ("errorMessage" in $$props2)
      $$invalidate(3, errorMessage = $$props2.errorMessage);
  };
  $$self.$capture_state = () => ({
    createEventDispatcher,
    name,
    password,
    email,
    errorMessage,
    dispatch
  });
  $$self.$inject_state = ($$props2) => {
    if ("name" in $$props2)
      $$invalidate(0, name = $$props2.name);
    if ("password" in $$props2)
      $$invalidate(1, password = $$props2.password);
    if ("email" in $$props2)
      $$invalidate(2, email = $$props2.email);
    if ("errorMessage" in $$props2)
      $$invalidate(3, errorMessage = $$props2.errorMessage);
  };
  if ($$props && "$$inject" in $$props) {
    $$self.$inject_state($$props.$$inject);
  }
  return [
    name,
    password,
    email,
    errorMessage,
    dispatch,
    input0_input_handler,
    input1_input_handler,
    input2_input_handler,
    click_handler
  ];
}
class RegistrationForm extends SvelteComponentDev {
  constructor(options) {
    super(options);
    init(this, options, instance$1, create_fragment$1, safe_not_equal, {
      name: 0,
      password: 1,
      email: 2,
      errorMessage: 3
    });
    dispatch_dev("SvelteRegisterComponent", {
      component: this,
      tagName: "RegistrationForm",
      options,
      id: create_fragment$1.name
    });
  }
  get name() {
    throw new Error("<RegistrationForm>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  set name(value) {
    throw new Error("<RegistrationForm>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  get password() {
    throw new Error("<RegistrationForm>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  set password(value) {
    throw new Error("<RegistrationForm>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  get email() {
    throw new Error("<RegistrationForm>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  set email(value) {
    throw new Error("<RegistrationForm>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  get errorMessage() {
    throw new Error("<RegistrationForm>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
  set errorMessage(value) {
    throw new Error("<RegistrationForm>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
  }
}
const { console: console_1 } = globals;
const file = "C:/git/keen-auth-permissions-demo/assets/apps/registration/App.svelte";
function create_else_block(ctx) {
  let div;
  const block = {
    c: function create() {
      div = element("div");
      div.textContent = "Registration successfull, click on link in email we send you to activate\r\n      account";
      attr_dev(div, "class", "alert alert-success");
      attr_dev(div, "role", "alert");
      add_location(div, file, 66, 4, 1568);
    },
    m: function mount(target, anchor) {
      insert_dev(target, div, anchor);
    },
    p: noop,
    i: noop,
    o: noop,
    d: function destroy(detaching) {
      if (detaching)
        detach_dev(div);
    }
  };
  dispatch_dev("SvelteRegisterBlock", {
    block,
    id: create_else_block.name,
    type: "else",
    source: "(66:2) {:else}",
    ctx
  });
  return block;
}
function create_if_block(ctx) {
  let registrationform;
  let updating_name;
  let updating_password;
  let updating_email;
  let updating_errorMessage;
  let current;
  function registrationform_name_binding(value) {
    ctx[7](value);
  }
  function registrationform_password_binding(value) {
    ctx[8](value);
  }
  function registrationform_email_binding(value) {
    ctx[9](value);
  }
  function registrationform_errorMessage_binding(value) {
    ctx[10](value);
  }
  let registrationform_props = {};
  if (ctx[0] !== void 0) {
    registrationform_props.name = ctx[0];
  }
  if (ctx[1] !== void 0) {
    registrationform_props.password = ctx[1];
  }
  if (ctx[2] !== void 0) {
    registrationform_props.email = ctx[2];
  }
  if (ctx[3] !== void 0) {
    registrationform_props.errorMessage = ctx[3];
  }
  registrationform = new RegistrationForm({
    props: registrationform_props,
    $$inline: true
  });
  binding_callbacks.push(() => bind(registrationform, "name", registrationform_name_binding));
  binding_callbacks.push(() => bind(registrationform, "password", registrationform_password_binding));
  binding_callbacks.push(() => bind(registrationform, "email", registrationform_email_binding));
  binding_callbacks.push(() => bind(registrationform, "errorMessage", registrationform_errorMessage_binding));
  registrationform.$on("register", ctx[6]);
  const block = {
    c: function create() {
      create_component(registrationform.$$.fragment);
    },
    m: function mount(target, anchor) {
      mount_component(registrationform, target, anchor);
      current = true;
    },
    p: function update2(ctx2, dirty) {
      const registrationform_changes = {};
      if (!updating_name && dirty & 1) {
        updating_name = true;
        registrationform_changes.name = ctx2[0];
        add_flush_callback(() => updating_name = false);
      }
      if (!updating_password && dirty & 2) {
        updating_password = true;
        registrationform_changes.password = ctx2[1];
        add_flush_callback(() => updating_password = false);
      }
      if (!updating_email && dirty & 4) {
        updating_email = true;
        registrationform_changes.email = ctx2[2];
        add_flush_callback(() => updating_email = false);
      }
      if (!updating_errorMessage && dirty & 8) {
        updating_errorMessage = true;
        registrationform_changes.errorMessage = ctx2[3];
        add_flush_callback(() => updating_errorMessage = false);
      }
      registrationform.$set(registrationform_changes);
    },
    i: function intro(local) {
      if (current)
        return;
      transition_in(registrationform.$$.fragment, local);
      current = true;
    },
    o: function outro(local) {
      transition_out(registrationform.$$.fragment, local);
      current = false;
    },
    d: function destroy(detaching) {
      destroy_component(registrationform, detaching);
    }
  };
  dispatch_dev("SvelteRegisterBlock", {
    block,
    id: create_if_block.name,
    type: "if",
    source: "(58:2) {#if !complete}",
    ctx
  });
  return block;
}
function create_default_slot(ctx) {
  let current_block_type_index;
  let if_block;
  let if_block_anchor;
  let current;
  const if_block_creators = [create_if_block, create_else_block];
  const if_blocks = [];
  function select_block_type(ctx2, dirty) {
    if (!ctx2[4])
      return 0;
    return 1;
  }
  current_block_type_index = select_block_type(ctx);
  if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
  const block = {
    c: function create() {
      if_block.c();
      if_block_anchor = empty();
    },
    m: function mount(target, anchor) {
      if_blocks[current_block_type_index].m(target, anchor);
      insert_dev(target, if_block_anchor, anchor);
      current = true;
    },
    p: function update2(ctx2, dirty) {
      let previous_block_index = current_block_type_index;
      current_block_type_index = select_block_type(ctx2);
      if (current_block_type_index === previous_block_index) {
        if_blocks[current_block_type_index].p(ctx2, dirty);
      } else {
        group_outros();
        transition_out(if_blocks[previous_block_index], 1, 1, () => {
          if_blocks[previous_block_index] = null;
        });
        check_outros();
        if_block = if_blocks[current_block_type_index];
        if (!if_block) {
          if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx2);
          if_block.c();
        } else {
          if_block.p(ctx2, dirty);
        }
        transition_in(if_block, 1);
        if_block.m(if_block_anchor.parentNode, if_block_anchor);
      }
    },
    i: function intro(local) {
      if (current)
        return;
      transition_in(if_block);
      current = true;
    },
    o: function outro(local) {
      transition_out(if_block);
      current = false;
    },
    d: function destroy(detaching) {
      if_blocks[current_block_type_index].d(detaching);
      if (detaching)
        detach_dev(if_block_anchor);
    }
  };
  dispatch_dev("SvelteRegisterBlock", {
    block,
    id: create_default_slot.name,
    type: "slot",
    source: "(57:0) <Loader bind:loading>",
    ctx
  });
  return block;
}
function create_fragment(ctx) {
  let loader;
  let updating_loading;
  let current;
  function loader_loading_binding(value) {
    ctx[11](value);
  }
  let loader_props = {
    $$slots: { default: [create_default_slot] },
    $$scope: { ctx }
  };
  if (ctx[5] !== void 0) {
    loader_props.loading = ctx[5];
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
      if (dirty & 8223) {
        loader_changes.$$scope = { dirty, ctx: ctx2 };
      }
      if (!updating_loading && dirty & 32) {
        updating_loading = true;
        loader_changes.loading = ctx2[5];
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
  let name, password, email;
  let errorMessage = "", complete = false;
  let loading = false;
  function register() {
    if (!isValid()) {
      return;
    }
    $$invalidate(5, loading = true);
    Manager.Register(name, email, password).then((res) => {
      $$invalidate(4, complete = true);
      redirectHome(1500);
    }).catch((res) => {
      var _a;
      console.warn(res);
      if (res == null ? void 0 : res.error) {
        $$invalidate(3, errorMessage = (_a = res == null ? void 0 : res.error) == null ? void 0 : _a.msg);
      }
    }).finally(() => {
      $$invalidate(5, loading = false);
    });
  }
  function isValid() {
    if (isEmpty(name) || name.lenght > 4) {
      $$invalidate(3, errorMessage = "Name has to be at least 4 characters long");
      return false;
    }
    if (isEmpty(email) || !isValidEmail(email)) {
      $$invalidate(3, errorMessage = "Email need to be valid");
      return false;
    }
    if (isEmpty(password) || password.lenght < 8) {
      $$invalidate(3, errorMessage = "Password has to be at least 4 characters long");
      return false;
    }
    $$invalidate(3, errorMessage = "");
    return true;
  }
  const writable_props = [];
  Object.keys($$props).forEach((key) => {
    if (!~writable_props.indexOf(key) && key.slice(0, 2) !== "$$" && key !== "slot")
      console_1.warn(`<App> was created with unknown prop '${key}'`);
  });
  function registrationform_name_binding(value) {
    name = value;
    $$invalidate(0, name);
  }
  function registrationform_password_binding(value) {
    password = value;
    $$invalidate(1, password);
  }
  function registrationform_email_binding(value) {
    email = value;
    $$invalidate(2, email);
  }
  function registrationform_errorMessage_binding(value) {
    errorMessage = value;
    $$invalidate(3, errorMessage);
  }
  function loader_loading_binding(value) {
    loading = value;
    $$invalidate(5, loading);
  }
  $$self.$capture_state = () => ({
    Loader,
    redirectHome,
    isEmpty,
    isValidEmail,
    Manager,
    RegistrationForm,
    name,
    password,
    email,
    errorMessage,
    complete,
    loading,
    register,
    isValid
  });
  $$self.$inject_state = ($$props2) => {
    if ("name" in $$props2)
      $$invalidate(0, name = $$props2.name);
    if ("password" in $$props2)
      $$invalidate(1, password = $$props2.password);
    if ("email" in $$props2)
      $$invalidate(2, email = $$props2.email);
    if ("errorMessage" in $$props2)
      $$invalidate(3, errorMessage = $$props2.errorMessage);
    if ("complete" in $$props2)
      $$invalidate(4, complete = $$props2.complete);
    if ("loading" in $$props2)
      $$invalidate(5, loading = $$props2.loading);
  };
  if ($$props && "$$inject" in $$props) {
    $$self.$inject_state($$props.$$inject);
  }
  return [
    name,
    password,
    email,
    errorMessage,
    complete,
    loading,
    register,
    registrationform_name_binding,
    registrationform_password_binding,
    registrationform_email_binding,
    registrationform_errorMessage_binding,
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
window.AppsManager.register("registration", constructor);
//# sourceMappingURL=main.mjs.map
