### A Pluto.jl notebook ###
# v0.19.25

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

# ╔═╡ a51721ca-f300-4ba3-a56b-86a32aaf8040
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project())
end
  ╠═╡ =#

# ╔═╡ 09d5bcb2-aea8-4c4a-b506-2b859b89da7b
using Dates

# ╔═╡ 2fd45be4-e19b-4843-954d-890caa374633
using PlutoUI

# ╔═╡ c9f5cfdc-43f3-4cb5-94f5-616e5fa40e05
md"""
# DateRangePicker

The DateRangePicker provides two date pickers and returns the selected range of dates as a StepRange.
"""

# ╔═╡ 0927d8e5-4df7-43e5-8439-a6f5fae1a5e2
# Use the helper combine() and grid() functions to construct the range picker,
# which just consists of two date pickers side-by-side.
function _DateRangeLayout(;
	default_start::Union{Dates.Date,Nothing}=nothing,
	default_stop::Union{Dates.Date,Nothing}=nothing
)
	PlutoUI.combine() do Child
		start = Child(PlutoUI.DatePicker(;default=default_start))
		stop = Child(PlutoUI.DatePicker(;default=default_stop))
		PlutoUI.ExperimentalLayout.grid([start md"⟶" stop],
			fill_width=false, column_gap="1pt"
		)
	end
end;

# ╔═╡ 316daaf4-5003-4753-92a7-6f11c6b32ce3
"""
```julia
DateRangePicker(; [default_start::Dates.Date,] [default_stop::Dates.Date])
```
A date range picker that lets the user select a start and end date.
Returns a StepRange containing the start, intervening and end dates.
"""
function DateRangePicker(; kwargs...)
	display = _DateRangeLayout(;kwargs...)
	PlutoUI.Experimental.transformed_value(display) do input
		@assert !any(isnothing, input) "Both dates must be set"
		@assert input[1] <= input[2] "Start date cannot be after end date"
		input[1]:input[2]
	end
end

# ╔═╡ d60e2528-a283-4c3b-97a8-6880277f5ccb
export DateRangePicker

# ╔═╡ 97b75ff0-fa0d-4613-b1a2-5c2e0d343cf5
md"""
## Examples

Select a date range and I'll tell you if it includes today.
"""

# ╔═╡ 24d03838-f224-4224-95de-851f9bd3c2de
@bind dr DateRangePicker(; default_start=today()-Day(10), default_stop=today()-Day(3))

# ╔═╡ d6d62034-bcb9-42e9-8761-13b3d4105b39
if today() ∈ dr
	Markdown.parse("**Yes**, today ($(today())) is in the range $(dr.start) to $(dr.stop).")
else
	Markdown.parse("**No**, today ($(today())) is not in the range $(dr.start) to $(dr.stop).")
end

# ╔═╡ Cell order:
# ╠═a51721ca-f300-4ba3-a56b-86a32aaf8040
# ╠═09d5bcb2-aea8-4c4a-b506-2b859b89da7b
# ╠═2fd45be4-e19b-4843-954d-890caa374633
# ╟─c9f5cfdc-43f3-4cb5-94f5-616e5fa40e05
# ╠═0927d8e5-4df7-43e5-8439-a6f5fae1a5e2
# ╠═316daaf4-5003-4753-92a7-6f11c6b32ce3
# ╠═d60e2528-a283-4c3b-97a8-6880277f5ccb
# ╟─97b75ff0-fa0d-4613-b1a2-5c2e0d343cf5
# ╟─24d03838-f224-4224-95de-851f9bd3c2de
# ╟─d6d62034-bcb9-42e9-8761-13b3d4105b39
