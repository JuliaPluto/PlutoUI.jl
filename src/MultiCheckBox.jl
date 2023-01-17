### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 499ca710-1a50-4aa1-87d8-d213416e8e30
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
end
  ╠═╡ =#

# ╔═╡ b65c67ec-b79f-4f0e-85e6-78ff22b279d4
using HypertextLiteral

# ╔═╡ a8c1e0d2-3604-4e1d-a87c-c8f5b86b79ed
md"""
# MultiCheckBox
"""

# ╔═╡ 1c914889-9c98-4aa5-b24f-3027b74feb4a
# ╠═╡ skip_as_script = true
#=╠═╡
animals_count = Ref(0)
  ╠═╡ =#

# ╔═╡ ba2cf480-ff5e-43a3-8cba-5a4754b776f5
md"""
# MultiSelect
"""

# ╔═╡ 775c49e9-bb4d-42ca-8ed0-d259d0d18725
teststr = "<x>\"\" woa"

# ╔═╡ c8350f43-0d30-45d0-873b-ff56c5801ac1
md"""
## Definitions
"""

# ╔═╡ 693f0bc4-2076-44e4-84f4-5ef1f3f43dd7
import AbstractPlutoDingetjes

# ╔═╡ 631c14bf-e2d3-4a24-8ddc-095a3dab80ef
import AbstractPlutoDingetjes.Bonds

# ╔═╡ a666d4df-dbbb-4837-b850-363caa576fe9
function initially_selected(options, defaults)
	# Given pairs of `bound_value => display_value` 
	# (for MultiSelect or MultiCheckBox),
	# and list of default bound values,
	# return a bool array of which options should be initially selected to result
	# in the supplied defaults as the widget's value.
	# This is a bit tricky due to the possibility of duplicate bound values.
	# See https://github.com/JuliaPluto/PlutoUI.jl/issues/106
	defaults_copy = copy(defaults)
	[
		let
			i = findfirst(isequal(k), defaults_copy)
			if i === nothing
				false
			else
				deleteat!(defaults_copy, i)
				true
			end
		end
	for (k,v) in options]
end

# ╔═╡ c38de38d-e900-4309-a9f6-1392af2f245b
subarrays(x) = (
	x[collect(I)]
	for I in Iterators.product(Iterators.repeated([true,false],length(x))...) |> collect |> vec
)

# ╔═╡ cd217cac-658a-44b7-8c88-348ae1af9b64
subarrays([2,3,3]) |> collect

# ╔═╡ 2c634e7f-428f-4655-951b-2a8e4efce548
multi_possible_values(options) = subarrays(string.(eachindex(options)))

# ╔═╡ d7d9f4f3-4bac-4431-b3af-0af651a483b7
function multi_transform_value(options, val_from_js)
	# val_from_js will be a vector of Strings, but let's allow Integers as well, there's no harm in that
	@assert val_from_js isa Vector
	
	val_nums = (
		v isa Integer ? v : tryparse(Int64, v)
		for v in val_from_js
	)
	
	[options[v].first for v in val_nums]
end

# ╔═╡ 9cd42452-149e-4080-972f-a31f7023f67d
function multi_validate_value(options, val_from_js)
	allunique(val_from_js) && all(val_from_js) do v
		val_num = v isa Integer ? v : tryparse(Int64, v)
		1 ≤ val_num ≤ length(options)
	end
end

# ╔═╡ 41515a2f-81d7-4a47-8139-e0e4096c8cd4
begin
	local result = begin
	"""
	```julia
	MultiSelect(options::Vector; [default], [size::Int])
	# or with a custom display value:
	MultiSelect(options::Vector{Pair}; [default], [size::Int])
	```
	
	A multi-selector - the user can choose one or more of the `options`.
	
	See [`Select`](@ref) for a version that allows only one selected item.
	
	# Examples
	```julia
	@bind vegetables MultiSelect(["potato", "carrot"])
	
	if "carrot" ∈ vegetables
		"yum yum!"
	end
	```
	
	```julia
	@bind chosen_functions MultiSelect([sin, cos, tan, sqrt])
	
	[f(0.5) for f in chosen_functions]
	```
	
	You can also specify a display value by giving pairs `bound_value => display_value`:
	
	```julia
	@bind chosen_functions MultiSelect([
		cos => "cosine function", 
		sin => "sine function",
	])
	
	[f(0.5) for f in chosen_functions]
	```
	
	The `size` keyword argument may be used to specify how many rows should be visible at once.
	
	```julia
	@bind letters MultiSelect(string.('a':'z'), size=20)
	```
	"""
	struct MultiSelect{BT,DT}
		options::AbstractVector{Pair{BT,DT}}
		default::Vector{BT}
		size::Int
		
		MultiSelect{BT,DT}(options::AbstractVector{<:Pair{BT,DT}}, default, size) where {BT,DT} = new{BT,DT}(options, default, coalesce(size, min(10, length(options))))
	end
	end
	MultiSelect(options::AbstractVector{<:Pair{BT,DT}}; default = BT[], size = missing) where {BT,DT} = MultiSelect{BT,DT}(options, default, size)
	MultiSelect(options::AbstractVector{BT}; default = BT[], size = missing) where BT = MultiSelect{BT,BT}(Pair{BT,BT}[o => o for o in options], default, size)
	
	function Base.show(io::IO, m::MIME"text/html", select::MultiSelect)
	
		# compat code
		if !AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value)
			compat_element = try
				OldMultiSelect(select.options, select.default, select.size)
			catch
				HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>")
			end
			return show(io, m, compat_element)
		end

		selected = initially_selected(select.options, select.default)
		
		show(io, m, @htl(
			"""<select title='Cmd+Click or Ctrl+Click to select multiple items.' multiple size=$(select.size)>$(
		map(enumerate(select.options)) do (i,o)
				@htl(
				"<option value=$(i) selected=$(selected[i])>$(
				string(o.second)
				)</option>")
			end
		)</select>"""))
	end
	
	Base.get(select::MultiSelect) = Bonds.initial_value(select)
	Bonds.initial_value(select::MultiSelect) = select.default
	Bonds.possible_values(select::MultiSelect) = multi_possible_values(select.options)
	Bonds.transform_value(select::MultiSelect, val_from_js) = multi_transform_value(select.options, val_from_js)
	Bonds.validate_value(select::MultiSelect, val_from_js) = multi_validate_value(select.options, val_from_js)
	
	result
end

# ╔═╡ 112a576c-66fa-4336-a538-3843b8306587
MultiSelect(["a" => "🆘", "b" => "✅", "c" => "🆘",  "d" => "✅", "c" => "🆘2", "c3" => "🆘"]; default=["b","d"])

# ╔═╡ 11fbe522-4596-418c-b1d4-076a83a8408b
MultiSelect([[1 => "1.$i" for i=1:5]; [2 => "2.$i" for i=1:50]]; default=[1,1,1,2,2])

# ╔═╡ 430e2c1a-832f-11eb-024a-13e3989fd7c2
begin
	export MultiCheckBox, MultiSelect
    local result = begin
    """
    ```julia
    MultiCheckBox(options::Vector; [default::Vector], [orientation ∈ [:row, :column]], [select_all::Bool])
    ```
    
    A group of checkboxes - the user can choose which of the `options` to return.
    The value returned via `@bind` is a list containing the currently checked items.

    See also: [`MultiSelect`](@ref).

    `options` can also be an array of pairs `key => value`. The `key` is returned via `@bind`; the `value` is shown.

    # Keyword arguments
    - `defaults` specifies which options should be checked initally.
    - `orientation` specifies whether the options should be arranged in `:row`'s `:column`'s.
    - `select_all` specifies whether or not to include a "Select All" checkbox.

    # Examples
    ```julia
    @bind snacks MultiCheckBox(["🥕", "🐟", "🍌"]))
    
    if "🥕" ∈ snacks
        "Yum yum!"
    end
    ```
    
    ```julia
    @bind functions MultiCheckBox([sin, cos, tan])
    
    [f(0.5) for f in functions]
    ```

    ```julia
    @bind snacks MultiCheckBox(["🥕" => "🐰", "🐟" => "🐱", "🍌" => "🐵"]; default=["🥕", "🍌"])
    ```

    ```julia
    @bind animals MultiCheckBox(["🐰", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, select_all=true)
    ```
    """
    struct MultiCheckBox{BT,DT}
        options::AbstractVector{Pair{BT,DT}}
        default::Vector{BT}
        orientation::Symbol
        select_all::Bool
		
		function MultiCheckBox{BT,DT}(options::AbstractVector{<:Pair{BT,DT}}, default, orientation, select_all) where {BT,DT}
			@assert orientation == :column || orientation == :row "Invalid orientation $(mc.orientation). Orientation should be :row or :column"
			new{BT,DT}(options, default, orientation, select_all)
		end
    end
    end

    MultiCheckBox(options::AbstractVector{<:Pair{BT,DT}}; default=BT[], orientation=:row, select_all=false) where {BT,DT} = MultiCheckBox{BT,DT}(options, default, orientation, select_all)
        
    MultiCheckBox(options::AbstractVector{BT}; default=BT[], orientation=:row, select_all=false) where BT = MultiCheckBox{BT,BT}(Pair{BT,BT}[o => o for o in options], default, orientation, select_all)


    Base.get(select::MultiCheckBox) = Bonds.initial_value(select)
    Bonds.initial_value(select::MultiCheckBox) = select.default
    Bonds.possible_values(select::MultiCheckBox) = multi_possible_values(select.options)
    Bonds.transform_value(select::MultiCheckBox, val_from_js) = multi_transform_value(select.options, val_from_js)
    Bonds.validate_value(select::MultiCheckBox, val_from_js) = multi_validate_value(select.options, val_from_js)

	function Base.show(io::IO, m::MIME"text/html", mc::MultiCheckBox)

		checked = initially_selected(mc.options, mc.default)
		
        show(io, m, @htl("""
        <plj-multi-checkbox style="flex-direction: $(mc.orientation);"></plj-multi-checkbox>
        <script type="text/javascript">
		const labels = $([string(v) for (k,v) in mc.options]);
		const values = $(1:length(mc.options));
		const checked = $(checked);
		const includeSelectAll = $(mc.select_all);

		const container = (currentScript ? currentScript : this.currentScript).previousElementSibling
		
		const my_id = crypto.getRandomValues(new Uint32Array(1))[0].toString(36)
		
		// Add checkboxes
		const inputEls = []
		for (let i = 0; i < labels.length; i++) {
			const boxId = `\${my_id}-box-\${i}`
		
			const item = document.createElement('div')
		
			const checkbox = document.createElement('input')
			checkbox.type = 'checkbox'
			checkbox.id = boxId
			checkbox.name = labels[i]
			checkbox.value = values[i]
			checkbox.checked = checked[i]
			inputEls.push(checkbox)
			item.appendChild(checkbox)
		
			const label = document.createElement('label')
			label.htmlFor = boxId
			label.innerText = labels[i]
			item.appendChild(label)
		
			container.appendChild(item)
		}
		
		function setValue() {
			container.value = inputEls.filter((o) => o.checked).map((o) => o.value)
		}
		// Add listeners
		function sendEvent() {
			setValue()
			container.dispatchEvent(new CustomEvent('input'))
		}
		
		function updateSelectAll() {}
		
		if (includeSelectAll) {
			// Add select-all checkbox.
			const selectAllItem = document.createElement('div')
			selectAllItem.classList.add(`select-all`)
		
			const selectID = `\${my_id}-select-all`
		
			const selectAllInput = document.createElement('input')
			selectAllInput.type = 'checkbox'
			selectAllInput.id = selectID
			selectAllItem.appendChild(selectAllInput)
		
			const selectAllLabel = document.createElement('label')
			selectAllLabel.htmlFor = selectID
			selectAllLabel.innerText = 'Select All'
			selectAllItem.appendChild(selectAllLabel)
		
			container.prepend(selectAllItem)
		
			function onSelectAllClick(event) {
				event.stopPropagation()
				inputEls.forEach((o) => (o.checked = this.checked))
				sendEvent()
			}
			selectAllInput.addEventListener('click', onSelectAllClick)
            selectAllInput.addEventListener('input', e => e.stopPropagation())
		
			/// Taken from: https://stackoverflow.com/questions/10099158/how-to-deal-with-browser-differences-with-indeterminate-checkbox
			/// Determine the checked state to give to a checkbox
			/// with indeterminate state, so that it becomes checked
			/// on click on IE, Chrome and Firefox 5+
			function getCheckedStateForIndeterminate() {
				// Create a unchecked checkbox with indeterminate state
				const test = document.createElement('input')
				test.type = 'checkbox'
				test.checked = false
				test.indeterminate = true
		
				// Try to click the checkbox
				const body = document.body
				body.appendChild(test) // Required to work on FF
				test.click()
				body.removeChild(test) // Required to work on FF
		
				// Check if the checkbox is now checked and cache the result
				if (test.checked) {
					getCheckedStateForIndeterminate = function () {
						return false
					}
					return false
				} else {
					getCheckedStateForIndeterminate = function () {
						return true
					}
					return true
				}
			}
		
			updateSelectAll = function () {
				const checked = inputEls.map((o) => o.checked)
				if (checked.every((x) => x)) {
					selectAllInput.checked = true
					selectAllInput.indeterminate = false
				} else if (checked.some((x) => x)) {
					selectAllInput.checked = getCheckedStateForIndeterminate()
					selectAllInput.indeterminate = true
				} else {
					selectAllInput.checked = false
					selectAllInput.indeterminate = false
				}
			}
			// Call once at the beginning to initialize.
			updateSelectAll()
		}
		
		function onItemClick(event) {
			event.stopPropagation()
			updateSelectAll()
			sendEvent()
		}
		setValue()
		inputEls.forEach((el) => el.addEventListener('click', onItemClick))
		inputEls.forEach((el) => el.addEventListener('input', e => e.stopPropagation()))
		
        </script>
        <style type="text/css">
		plj-multi-checkbox {
			display: flex;
			flex-wrap: wrap;
			/* max-height: 8em; */
		}
		
		plj-multi-checkbox * {
			display: flex;
		}
		
		plj-multi-checkbox > div {
			margin: 0.1em 0.3em;
			align-items: center;
		}
		
		plj-multi-checkbox label,
		plj-multi-checkbox input {
			cursor: pointer;
		}
		
		plj-multi-checkbox .select-all {
			font-style: italic;
			color: hsl(0, 0%, 25%, 0.7);
		}
		</style>
        """))
    end

	result
end

# ╔═╡ 8bfaf4c8-557d-433e-a228-aac493746efc
# ╠═╡ skip_as_script = true
#=╠═╡
@bind animals MultiCheckBox(["🐰", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, select_all=true)
  ╠═╡ =#

# ╔═╡ 8e9f3962-d86c-4e07-b5d3-f31ee5361ca2
#=╠═╡
animals
  ╠═╡ =#

# ╔═╡ 430475b3-7db2-4e09-9422-ac1d6ef32ee7
#=╠═╡
let
	animals
	animals_count[] += 1
end
  ╠═╡ =#

# ╔═╡ d8613c4f-6936-4fb2-9b9f-acf34377091f
# ╠═╡ skip_as_script = true
#=╠═╡
@bind funcs MultiCheckBox([sin, cos, tan]; default=[sin, tan])
  ╠═╡ =#

# ╔═╡ 92fe974e-cc6c-4387-8c6e-85813b222f25
#=╠═╡
funcs
  ╠═╡ =#

# ╔═╡ 1dd8a041-60c0-4b26-8207-3dc9cca0d3eb
#=╠═╡
[f(0.5) for f in funcs]
  ╠═╡ =#

# ╔═╡ a8a7e90d-8bbf-4ab6-90a8-24a10885fb0a
# ╠═╡ skip_as_script = true
#=╠═╡
@bind animals2 MultiCheckBox(["\"🐰\\\"", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, default=["🐿️" , "🐝"])
  ╠═╡ =#

# ╔═╡ 6123cf6d-fc29-4a8f-a5a1-4366cc6457b6
#=╠═╡
animals2
  ╠═╡ =#

# ╔═╡ 60183ad1-4919-4402-83fb-d53b86dda0a6
# ╠═╡ skip_as_script = true
#=╠═╡
MultiCheckBox(["🐰 &&\\a \$\$", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"])
  ╠═╡ =#

# ╔═╡ ad6dcdec-2fc9-45d2-8828-62ac857b4afa
# ╠═╡ skip_as_script = true
#=╠═╡
@bind snacks MultiCheckBox(
	["🐱" => "🐝", "🐵" => "🦝", "🐱" => "🐿️"]; 
	default=["🐱", "🐱"]
)
  ╠═╡ =#

# ╔═╡ abe4c3e0-6e1e-4e26-a4fa-bd60f31c1a4c
#=╠═╡
snacks
  ╠═╡ =#

# ╔═╡ c8bf9a17-14ce-4802-b578-81eb10bdd7be
bms = @bind ms1 MultiSelect(["a" => "default", teststr => teststr])

# ╔═╡ 9b8efd9f-8c24-4cf0-97a1-87fb8f4dadd2
bms

# ╔═╡ 9b888e03-242f-4a41-bb25-c62fa7daf12a
ms1

# ╔═╡ 1f8f2492-8624-496d-9aba-a3d5e1d1accb
@bind fs MultiSelect([sin, cos, tan])

# ╔═╡ ad25b07b-fa5b-41eb-a928-6012e2f2c0ec
fs

# ╔═╡ 5d14aaa7-587e-4c39-8e54-2c46a1581a11
[f(0.5) for f in fs]

# ╔═╡ Cell order:
# ╟─a8c1e0d2-3604-4e1d-a87c-c8f5b86b79ed
# ╠═8bfaf4c8-557d-433e-a228-aac493746efc
# ╠═8e9f3962-d86c-4e07-b5d3-f31ee5361ca2
# ╠═1c914889-9c98-4aa5-b24f-3027b74feb4a
# ╠═430475b3-7db2-4e09-9422-ac1d6ef32ee7
# ╠═d8613c4f-6936-4fb2-9b9f-acf34377091f
# ╠═92fe974e-cc6c-4387-8c6e-85813b222f25
# ╠═1dd8a041-60c0-4b26-8207-3dc9cca0d3eb
# ╠═a8a7e90d-8bbf-4ab6-90a8-24a10885fb0a
# ╠═6123cf6d-fc29-4a8f-a5a1-4366cc6457b6
# ╠═60183ad1-4919-4402-83fb-d53b86dda0a6
# ╠═abe4c3e0-6e1e-4e26-a4fa-bd60f31c1a4c
# ╠═ad6dcdec-2fc9-45d2-8828-62ac857b4afa
# ╟─ba2cf480-ff5e-43a3-8cba-5a4754b776f5
# ╠═775c49e9-bb4d-42ca-8ed0-d259d0d18725
# ╠═cd217cac-658a-44b7-8c88-348ae1af9b64
# ╠═c8bf9a17-14ce-4802-b578-81eb10bdd7be
# ╠═9b8efd9f-8c24-4cf0-97a1-87fb8f4dadd2
# ╠═9b888e03-242f-4a41-bb25-c62fa7daf12a
# ╠═112a576c-66fa-4336-a538-3843b8306587
# ╠═11fbe522-4596-418c-b1d4-076a83a8408b
# ╠═1f8f2492-8624-496d-9aba-a3d5e1d1accb
# ╠═ad25b07b-fa5b-41eb-a928-6012e2f2c0ec
# ╠═5d14aaa7-587e-4c39-8e54-2c46a1581a11
# ╟─c8350f43-0d30-45d0-873b-ff56c5801ac1
# ╠═499ca710-1a50-4aa1-87d8-d213416e8e30
# ╠═693f0bc4-2076-44e4-84f4-5ef1f3f43dd7
# ╠═631c14bf-e2d3-4a24-8ddc-095a3dab80ef
# ╠═b65c67ec-b79f-4f0e-85e6-78ff22b279d4
# ╟─a666d4df-dbbb-4837-b850-363caa576fe9
# ╟─c38de38d-e900-4309-a9f6-1392af2f245b
# ╟─2c634e7f-428f-4655-951b-2a8e4efce548
# ╠═d7d9f4f3-4bac-4431-b3af-0af651a483b7
# ╠═9cd42452-149e-4080-972f-a31f7023f67d
# ╠═430e2c1a-832f-11eb-024a-13e3989fd7c2
# ╟─41515a2f-81d7-4a47-8139-e0e4096c8cd4
