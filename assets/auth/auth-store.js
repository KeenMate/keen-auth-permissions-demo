import { derived, writable } from "svelte/store";

export const currentUser = writable(null);
export const tenant = writable(null);

export const isAuthenticated = derived(
	currentUser,
	(user) => !!user?.uuid,
	false
);
