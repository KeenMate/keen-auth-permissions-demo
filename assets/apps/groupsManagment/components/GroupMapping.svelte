<script>
	import { Multiselect } from "svelte-multiselect";
	const types = ["role", "group"],
		providers = ["aad"];

	export let mappings;
	export let create;
	export let remove;
	let type = "group";
	let provider = "aad";
	let name;
	let value;

	function beforeCreate() {
		if (!type || !provider || !name || !value) {
			return;
		}
		const val = { type, provider, name, value };
		create(val);
	}
</script>

<div style="height: 80vh;">
	<h3>Mappings</h3>

	<!-- create form -->
	<div>
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
				/>
			</div>
		</div>
		<input
			class="form-control"
			type="text"
			bind:value={name}
			placeholder="name"
		/>
		<input class="form-control" type="text" bind:value placeholder="value" />
		<br />

		<button class="btn btn-success" on:click={beforeCreate}> Create new mappings</button>
	</div>
	<br />
	<br />
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
							on:click={() => remove(mapping.ugMappingId)}
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
