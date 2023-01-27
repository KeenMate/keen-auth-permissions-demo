export const emptyPromise = new Promise(() => {});

export function timeout(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}
