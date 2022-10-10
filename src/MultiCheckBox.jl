### A Pluto.jl notebook ###
# v0.19.12

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

# ╔═╡ c8350f43-0d30-45d0-873b-ff56c5801ac1
md"""
## Definition
"""

# ╔═╡ 631c14bf-e2d3-4a24-8ddc-095a3dab80ef
import AbstractPlutoDingetjes.Bonds

# ╔═╡ c38de38d-e900-4309-a9f6-1392af2f245b
subarrays(x) = (
	x[collect(I)]
	for I in Iterators.product(Iterators.repeated([true,false],length(x))...) |> collect |> vec
)

# ╔═╡ 430e2c1a-832f-11eb-024a-13e3989fd7c2
begin
	export MultiCheckBox
    local result = begin
    """
    ```julia
    MultiCheckBox(options::Vector; [default::Vector], [orientation ∈ [:row, :column]], [select_all::Bool])
    ```
    
    A group of checkboxes - the user can choose which of the `options` to return.
    The value returned via `@bind` is a list containing the currently checked items.

    See also: [`MultiSelect`](@ref).

    `options` can also be an array of pairs `key::Any => value::String`. The `key` is returned via `@bind`; the `value` is shown.

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
        default::Union{Missing,AbstractVector{BT}}
        orientation::Symbol
        select_all::Bool
    end
    end

    MultiCheckBox(options::AbstractVector{<:Pair{BT,DT}}; default=missing, orientation=:row, select_all=false) where {BT,DT} = MultiCheckBox(options, default, orientation, select_all)
        
    MultiCheckBox(options::AbstractVector{BT}; default=missing, orientation=:row, select_all=false) where BT = MultiCheckBox{BT,BT}(Pair{BT,BT}[o => o for o in options], default, orientation, select_all)

    function Base.show(io::IO, m::MIME"text/html", mc::MultiCheckBox)
        @assert mc.orientation == :column || mc.orientation == :row "Invalid orientation $(mc.orientation). Orientation should be :row or :column"

        defaults = coalesce(mc.default, [])

		# Old:
		# checked = [k in defaults for (k,v) in mc.options]
		# 
		# More complicated to fix https://github.com/JuliaPluto/PlutoUI.jl/issues/106
		defaults_copy = copy(defaults)
		checked = [
			let
				i = findfirst(isequal(k), defaults_copy)
				if i === nothing
					false
				else
					deleteat!(defaults_copy, i)
					true
				end
			end
		for (k,v) in mc.options]
		
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

    Base.get(select::MultiCheckBox) = Bonds.initial_value(select)
    Bonds.initial_value(select::MultiCheckBox{BT,DT}) where {BT,DT} = 
        ismissing(select.default) ? BT[] : select.default
    Bonds.possible_values(select::MultiCheckBox) = 
        subarrays((string(i) for i in 1:length(select.options)))
    
    function Bonds.transform_value(select::MultiCheckBox{BT,DT}, val_from_js) where {BT,DT}
        # val_from_js will be a vector of Strings, but let's allow Integers as well, there's no harm in that
        @assert val_from_js isa Vector
        
        val_nums = (
            v isa Integer ? v : tryparse(Int64, v)
            for v in val_from_js
        )
        
        BT[select.options[v].first for v in val_nums]
    end
    
    function Bonds.validate_value(select::MultiCheckBox, val)
        val isa Vector && all(val_from_js) do v
            val_num = v isa Integer ? v : tryparse(Int64, v)
            1 ≤ val_num ≤ length(select.options)
        end
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
# ╟─c8350f43-0d30-45d0-873b-ff56c5801ac1
# ╠═499ca710-1a50-4aa1-87d8-d213416e8e30
# ╠═631c14bf-e2d3-4a24-8ddc-095a3dab80ef
# ╠═b65c67ec-b79f-4f0e-85e6-78ff22b279d4
# ╠═430e2c1a-832f-11eb-024a-13e3989fd7c2
# ╠═c38de38d-e900-4309-a9f6-1392af2f245b
