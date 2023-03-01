import { get } from "svelte/store";
import { location, push, querystring, replace } from "svelte-spa-router";
import { parse, stringify } from "qs";

export function updateQuerystringPartial(object, shouldReplace = false) {
	return updateQuerystring(
		{
			...parse(get(querystring)),
			...object,
		},
		shouldReplace
	);
}

export function updateQuerystring(object, shouldReplace = false) {
	const newQuery = stringifyFilters(object);

	const magic = (shouldReplace && replace) || push;
	return magic(`${get(location)}?${newQuery}`);
}

export function stringifyFilters(filters, partial, mapper = (x) => x) {
	let effectiveFilters = partial
		? {
				...filters,
				...partial,
		  }
		: filters;

	const mappedFilters = mapper(effectiveFilters);

	Object.keys(mappedFilters).forEach((key) => {
		if (!mappedFilters[key]) delete mappedFilters[key];
	});

	return stringify(mappedFilters, { arrayFormat: "brackets" });
}

export function parseQuerystringFilters(querystring, parser = (x) => x) {
	if (!querystring) return parser({});

	const qsParsed = parse(querystring);

	return parser(qsParsed);
}
