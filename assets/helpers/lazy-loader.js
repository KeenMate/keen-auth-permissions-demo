//TODO move to constants
export const waitForLoader = 0;
export const leaveLoaderFor = 234;

import { emptyPromise } from "./promise-helpers";

export default function lazyLoader(resourceTask, showLoader, hideLoader) {
	if (!(resourceTask instanceof Promise)) return emptyPromise;

	let loaderShowed = false;

	//! THIS IS CHANGED
	// show loader instantly to prevent template beiing rendered with async data
	showLoader();

	const beforeShowTimer = setTimeout(() => {
		loaderShowed = new Date();
		showLoader();
	}, waitForLoader);

	return resourceTask
		.then((res) => {
			if (!loaderShowed) {
				clearTimeout(beforeShowTimer);
				hideLoader();
				return res;
			}

			if (new Date() - loaderShowed > leaveLoaderFor) {
				hideLoader();
				return res;
			}

			// this leaves the loader showed for additional time
			return new Promise((resolve) => {
				setTimeout(() => {
					hideLoader();
					resolve(res);
				}, leaveLoaderFor - (new Date() - loaderShowed));
			});
		})
		.catch((err) => {
			hideLoader();
			throw err;
		});
}
