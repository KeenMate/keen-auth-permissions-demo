<script>
	import { createEventDispatcher } from "svelte";
	import { Multiselect } from "svelte-multiselect";
	const types = ["role", "group"],
		providers = ["aad"];

	const dispatch = createEventDispatcher();

	export let mappings;
	let type = "group";
	let provider = "aad";
	let name;
	let value;

	function beforeCreate() {
		if (!type || !provider || !name || !value) {
			return;
		}
		const mappingObject = { type, provider, name, value };
		dispatch("create", mappingObject);
	}
</script>

<div class="card my-3">
	<div class="card-header mb-0 pb-0">
		<div class="row">
			<div class="col-6">
				<Multiselect
					allowEmpty={false}
					bind:value={type}
					options={types}
					searchable={false}
					showLabels={false}
					placeholder="Select type"
					class="mb-3"
					small
				/>
			</div>
			<div class="col-6">
				<Multiselect
					bind:value={provider}
					options={providers}
					allowEmpty={false}
					searchable={false}
					showLabels={false}
					placeholder="Select type"
					class="mb-3"
					small
				/>
			</div>
		</div>
		<div class="row">
			<div class="col-6">
				<div class="input-group input-group-static">
					<input
						class="form-control"
						type="text"
						bind:value
						placeholder="value"
					/>
				</div>
			</div>
			<div class="col-6">
				<div class="input-group input-group-static">
					<input
						class="form-control"
						type="text"
						bind:value={name}
						placeholder="name"
					/>
				</div>
			</div>
		</div>

		<button class="btn btn-success mt-3" on:click={beforeCreate}>
			Create new mappings</button
		>
	</div>
	<hr class="m-0" />
	<div class="card-body mt-1">
		<table class="table">
			<thead>
				<tr>
					<th style="width: 1px;" />
					<th style="width: 1px;">Type</th>
					<th>Name</th>
					<th>Value</th>
				</tr>
			</thead>
			<tbody>
				{#each mappings as mapping}
					<tr>
						<td style="width: 1px;">
							<button
								class="btn btn-outline btn-sm"
								on:click={() => dispatch("remove", mapping.ugMappingId)}
							>
								<i class="fa-sharp fa-solid fa-xmark" />
							</button>
						</td>
						<td style="width: 1px;">{mapping.type}</td>
						<td>{mapping.mappedValue}</td>
						<td>{mapping.name}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
</div>

<style>
	.form-control {
		height: calc(1.5em + 0.75rem + 2px);
	}

	.btn-sm {
		padding: 0.25rem 0.5rem;
		font-size: 0.875rem;
		line-height: 1.5;
		border-radius: 0.2rem;
	}
</style>
