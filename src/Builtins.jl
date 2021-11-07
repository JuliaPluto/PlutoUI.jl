### A Pluto.jl notebook ###
# v0.17.0

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

# ╔═╡ a0fb4f28-bfe4-4877-bf07-31acb9a56d2c
using HypertextLiteral

# ╔═╡ 57232d88-b74f-4823-be61-8db450c93f5c
using Markdown: withtag, htmlesc

# ╔═╡ d738b448-387b-4942-af82-cc93042705a4
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ e8c5ba24-10e9-49e8-8c11-0add092637f8
"""
	@skip_as_script expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ e1bbe1d7-68ef-4ee1-8174-d1ae1f822acb
macro only_as_script(ex) skip_as_script(__module__) ? nothing : esc(ex) end

# ╔═╡ 81adbd39-5780-4cc6-a53f-a4472bacf1c0
if skip_as_script(@__MODULE__)
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Text("Project env active")
end

# ╔═╡ d8f907cd-2f89-4d54-a311-998dc8ee148e
teststr = "<x>\"\"woa"

# ╔═╡ ac542b84-dbc8-47e2-8835-9e43582b6ad7
import Random: randstring

# ╔═╡ 6da84fb9-a629-4e4c-819e-dd87a3e267ce
import Dates

# ╔═╡ dc3b6628-f453-46d9-b6a1-957608a20764
import AbstractPlutoDingetjes

# ╔═╡ a203d9d4-cd7b-4368-9f6d-e040a5757565
import AbstractPlutoDingetjes.Bonds

# ╔═╡ d088bcdb-d851-4ad7-b5a0-751c1f348995
begin
	local result = begin
		"""A Slider on the given `range`.

	## Examples
	`@bind x OldSlider(1:10)`

	`@bind x OldSlider(0.00 : 0.01 : 0.30)`

	`@bind x OldSlider(1:10; default=8, show_value=true)`

	"""
	struct OldSlider
		range::AbstractRange
		default::Real
		show_value::Bool
	end
	end
	
	
	OldSlider(range::AbstractRange; default=missing, show_value=false) = OldSlider(range, (default === missing) ? first(range) : default, show_value)
	
	function Base.show(io::IO, m::MIME"text/html", slider::OldSlider)
		show(io, m, @htl("""
				<input 
				type="range" 
				min=$(first(slider.range))
				step=$(step(slider.range))
				max=$(last(slider.range))

				value=$(slider.default)
				oninput=$(slider.show_value ? "this.nextElementSibling.value=this.value" : "")
				>

				$(
				slider.show_value ? @htl("<output>$(slider.default)</output>") : nothing
				)
				
				"""))
	end

	Base.get(slider::OldSlider) = slider.default
	Bonds.initial_value(slider::OldSlider) = slider.default
	Bonds.possible_values(slider::OldSlider) = slider.range
	function Bonds.validate_value(slider::OldSlider, val)
		val isa Real && (minimum(slider.range) - 0.0001 <= val <= maximum(slider.range) + 0.0001)
	end

	result
end

# ╔═╡ 96084236-68f1-49b4-b866-027e7c80b5d8
begin
	local result = begin
		"""A slider over the given values.

	## Examples
	`@bind x Slider(1:10)`

	`@bind x Slider(0.00 : 0.01 : 0.30)`

	`@bind x Slider(1:10; default=8, show_value=true)`

	`@bind x Slider(["hello", "world!"])`
	"""
	struct Slider{T <: Any}
		values::AbstractVector{T}
		default::T
		show_value::Bool
	end
	end
	
	
	function Slider(values::AbstractVector{T}; default=missing, show_value=false) where T
		Slider(values, (default === missing) ? first(values) : convert(T, default), show_value)
	end
	
	function Base.show(io::IO, m::MIME"text/html", slider::Slider)

		# compat code
		if !AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value)
			compat_slider = try
				OldSlider(slider.values, slider.default, slider.show_value)
			catch
				HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>")
			end
			return show(io, m, compat_slider)
		end

		start_index = findfirst(isequal(slider.default), slider.values)
		
		show(io, m, @htl("""
				<input 
				type="range" 
				min=1
				max=$(length(slider.values))
				value=$(start_index)
				>
				$(slider.show_value ? @htl(
					"""<script>
					const input_el = currentScript.previousElementSibling
					const output_el = currentScript.nextElementSibling
					const displays = $(string.(slider.values))
					
					input_el.addEventListener("input", () => {
						output_el.value = displays[input_el.valueAsNumber - 1]
					})
					</script>
					<output>$(string(slider.default))</output>"""
				) : nothing)
				
				"""))
	end

	Base.get(slider::Slider) = slider.default
	Bonds.initial_value(slider::Slider) = slider.default
	
	Bonds.possible_values(slider::Slider) = slider.range
	
	function Bonds.transform_value(slider::Slider, val_from_js)
		slider.values[val_from_js]
	end
	
	function Bonds.validate_value(slider::Slider, val)
		val isa Integer && 1 <= val <= length(slider.values)
	end

	result
end

# ╔═╡ e440a357-1656-4cc4-8191-146fe82fbc8c
@bind os3 HTML(repr(MIME"text/html"(), Slider(0:.1:1, default=.5, show_value=true)))

# ╔═╡ 629e5d68-580f-4d6b-be14-5a109091e6b7
HTML(repr(MIME"text/html"(), Slider([sin, cos])))

# ╔═╡ f59eef32-4732-46db-87b0-3564433ce43e
begin
	local result = begin
	"""A box where you can type in a number, within a specific range.

	## Examples
	`@bind x NumberField(1:10)`

	`@bind x NumberField(0.00 : 0.01 : 0.30)`

	`@bind x NumberField(1:10; default=8)`

	"""
	struct NumberField
		range::AbstractRange
		default::Number
	end
	end
	
	NumberField(range::AbstractRange; default=missing) = NumberField(range, (default === missing) ? first(range) : default)
	
	function Base.show(io::IO, ::MIME"text/html", numberfield::NumberField)
		print(io, """<input type="number" min="$(first(numberfield.range))" step="$(step(numberfield.range))" max="$(last(numberfield.range))" value="$(numberfield.default)">""")
	end
	
	Base.get(numberfield::NumberField) = numberfield.default
	Bonds.initial_value(nf::NumberField) = nf.default
	Bonds.possible_values(nf::NumberField) = nf.range
	function Bonds.validate_value(nf::NumberField, val)
		val isa Real && (minimum(nf.range) - 0.0001 <= val <= maximum(nf.range) + 0.0001)
	end

	result
end

# ╔═╡ b7c21c22-17f5-44b8-98de-a261d5c7192b
begin
	local result = begin
	"""A button that sends back the same value every time that it is clicked.

	You can use it to _trigger reactive cells_.

	**See also [`CounterButton`](@ref)** to get the *number of times* the button was clicked.

	## Examples

	In one cell:

	```julia
	@bind go Button("Go!")
	```

	and in a second cell:

	```julia
	begin
		# reference the bound variable - clicking the button will run this cell
		go

		md"My favorite number is $(rand())!"
	end
	```
	"""
	struct LabelButton
		label::AbstractString
	end
	end
	LabelButton() = LabelButton("Click")
	
	function Base.show(io::IO, m::MIME"text/html", button::LabelButton)
		show(io, m, @htl("""<input type="button" value="$(button.label)">"""))
	end
	
	Base.get(button::LabelButton) = button.label
	Bonds.initial_value(b::LabelButton) = b.label
	Bonds.possible_values(b::LabelButton) = [b.label]
	function Bonds.validate_value(b::LabelButton, val)
		val == b.label
	end

	result
end

# ╔═╡ 7f8e4abf-e7e7-47bc-b1cc-514fa1af106c
const Button = LabelButton

# ╔═╡ 3ae2351b-ac4a-4669-bb11-39a1c029b301
Button()

# ╔═╡ 548bda96-2461-48a3-a3ad-6d113337826e
begin
	local result = begin
	"""A button that sends back the number of times that it was clicked.

	You can use it to _trigger reactive cells_.

	## Examples

	In one cell:

	```julia
	@bind go CounterButton("Go!")
	```

	and in a second cell:

	```julia
	begin
		# reference the bound variable - clicking the button will run this cell
		go

		md"My favorite number is $(rand())!"
	end
	```
	"""
	struct CounterButton
		label::AbstractString
	end
	end
	CounterButton() = CounterButton("Click")
	
	function Base.show(io::IO, m::MIME"text/html", button::CounterButton)
		show(io, m, @htl("""
		<span>
		<input type="button" value="$(button.label)">
		<script>
		let count = 0
		const span = currentScript.parentElement
		const button = span.firstElementChild
		
		span.value = count
		
		button.addEventListener("click", (e) => {
		count += 1
		span.value = count
		span.dispatchEvent(new CustomEvent("input"))
		e.stopPropagation()
			
		})
		</script>
		</span>
		"""))
	end
	
	Base.get(button::CounterButton) = button.label
	Bonds.initial_value(b::CounterButton) = 0
	Bonds.possible_values(b::CounterButton) = Bonds.InfinitePossibilities()
	function Bonds.validate_value(b::CounterButton, val)
		val isa Integer && val >= 0
	end

	result
end

# ╔═╡ 76c3b77b-08aa-4899-bbdd-4f8faa8d1486
begin
	local result = begin
	"""A checkbox to choose a Boolean value `true`/`false`.

	## Examples

	`@bind programming_is_fun CheckBox()`

	`@bind julia_is_fun CheckBox(default=true)`

	`md"Would you like the thing? \$(@bind enable_thing CheckBox())"`
	"""
	struct CheckBox
		default::Bool
	end
	end
	
	CheckBox(;default::Bool=false) = CheckBox(default)
	
	function Base.show(io::IO, ::MIME"text/html", button::CheckBox)
		print(io, """<input type="checkbox"$(button.default ? " checked" : "")>""")
	end
	
	Base.get(checkbox::CheckBox) = checkbox.default
	Bonds.initial_value(b::CheckBox) = b.default
	Bonds.possible_values(b::CheckBox) = [false, true]
	function Bonds.validate_value(b::CheckBox, val)
		val isa Bool
	end

	result
end

# ╔═╡ f81bb386-203b-4392-b974-a1e2146b1a08
begin
	local result = begin
	"""A text input (`<input type="text">`) - the user can type text, the text is returned as `String` via `@bind`.

	If `dims` is a tuple `(cols::Integer, row::Integer)`, a `<textarea>` will be shown, with the given dimensions

	Use `default` to set the initial value.

	See the [Mozilla docs about `<input type="text">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text) and [`<textarea>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea)

	# Examples
	`@bind poem TextField()`

	`@bind poem TextField((30,5); default="Hello\nJuliaCon!")`"""
	struct TextField
		dims::Union{Tuple{Integer,Integer},Nothing}
		default::AbstractString
	end
	end
	
	TextField(dims::Union{Tuple{Integer,Integer},Nothing}=nothing; default::AbstractString="") = TextField(dims, default)
	
	function Base.show(io::IO, m::MIME"text/html", textfield::TextField)
		show(io, m, 
		if textfield.dims === nothing
			@htl("""<input type="text" value=$(textfield.default)>""")
		else
			@htl("""<textarea cols=$(textfield.dims[1]) rows=$(textfield.dims[2])>$(textfield.default)</textarea>""")
		end
		)
	end
	
	Base.get(textfield::TextField) = textfield.default
	Bonds.initial_value(t::TextField) = t.default
	Bonds.possible_values(t::TextField) = Bonds.InfinitePossibilities()
	function Bonds.validate_value(t::TextField, val)
		val isa AbstractString
	end

	result
end

# ╔═╡ 4363f31e-1d71-4ad8-bfe8-04403d2d3621
TextField((30,2), default=teststr);

# ╔═╡ c9614498-54a8-4925-9353-7a13d3303916
begin
	Base.@kwdef struct PasswordField
		default::AbstractString=""
	end
	local result = begin
	@doc """A password input (`<input type="password">`) - the user can type text, the text is returned as `String` via `@bind`.

	This does not provide any special security measures, it just renders black dots (•••) instead of the typed characters.

	Use `default` to set the initial value.

	See the [Mozilla docs about `<input type="password">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/password)

	# Examples
	`@bind secret_poem PasswordField()`

	`@bind secret_poem PasswordField(default="Te dansen omdat men leeft")`"""
	PasswordField
	end
	
	function Base.show(io::IO, m::MIME"text/html", passwordfield::PasswordField)
		show(io, m, @htl("""<input type="password" value=$(passwordfield.default)>"""))
	end
	
	Base.get(passwordfield::PasswordField) = passwordfield.default
	Bonds.initial_value(t::PasswordField) = t.default
	Bonds.possible_values(t::PasswordField) = Bonds.InfinitePossibilities()
	function Bonds.validate_value(t::PasswordField, val)
		val isa AbstractString
	end

	result
end

# ╔═╡ 519f4da9-0205-486e-aea6-9dd5db6b38e0


# ╔═╡ edfdbaee-ec31-40c2-9ad5-28250fe6b651
begin
	local result = begin
	"""
	A dropdown menu (`<select>`) - the user can choose one of the `options`, an array of `String`s.

	See [`MultiSelect`](@ref) for a version that allows multiple selected items.

	`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

	See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

	# Examples
	`@bind veg OldSelect(["potato", "carrot"])`

	`@bind veg OldSelect(["potato" => "🥔", "carrot" => "🥕"])`

	`@bind veg OldSelect(["potato" => "🥔", "carrot" => "🥕"], default="carrot")`
	"""
	struct OldSelect
		options::Vector{Pair{<:AbstractString,<:Any}}
		default::Union{Missing, AbstractString}
	end
	end
	
	OldSelect(options::AbstractVector{<:AbstractString}; default=missing) = OldSelect([o => o for o in options], default)
	
	OldSelect(options::AbstractVector{<:Pair{<:AbstractString,<:Any}}; default=missing) = OldSelect(options, default)
	
	function Base.show(io::IO, m::MIME"text/html", select::OldSelect)
		show(io, m, @htl("""
				<select>$(
		map(select.options) do o
				@htl(
				"<option value=$(o.first) selected=$(!ismissing(select.default) && o.first == select.default)>$(
				o.second
				)</option>")
			end
		)</select>"""))
	end
	
	result
end

# ╔═╡ eb4e17fd-07ba-4031-a39f-0d9fccd3d886
begin
	local result = begin
	"""
	A dropdown menu (`<select>`) - the user can choose one of the `options`, an array of `String`s.

	See [`MultiSelect`](@ref) for a version that allows multiple selected items.

	`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

	See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

	# Examples
	`@bind veg Select(["potato", "carrot"])`

	`@bind veg Select(["potato" => "🥔", "carrot" => "🥕"])`

	The *key* can be any object, like a string, number, or even a function:
	
	```julia
	@bind f Select([cos => "cosine function", sin => "sine function"])

	f(0.5)
	```

	`@bind veg Select(["potato" => "🥔", "carrot" => "🥕"], default="carrot")`
	"""
	struct Select
		options::AbstractVector{Pair}
		default::Union{Missing, Any}
	end
	end
	
	Select(options::AbstractVector; default=missing) = Select([o => o for o in options], default)
	
	Select(options::AbstractVector{<:Pair}; default=missing) = Select(options, default)
	
	function Base.show(io::IO, m::MIME"text/html", select::Select)

		
		# compat code
		if !AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value)
			compat_element = try
				OldSelect(select.options, select.default)
			catch
				HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>")
			end
			return show(io, m, compat_element)
		end

		
		show(io, m, @htl("""
				<select>$(
		map(enumerate(select.options)) do (i,o)
				@htl(
				"<option value=$(i) selected=$(!ismissing(select.default) && o.first == select.default)>$(
				string(o.second)
				)</option>")
			end
		)</select>"""))
	end

	Base.get(select::Select) = select.default
	Bonds.initial_value(select::Select) = select.default
	
	Bonds.possible_values(select::Select) = (o.first for o in select.options)
	
	function Bonds.transform_value(select::Select, val_from_js)
		val_num = val_from_js isa Integer ? val_from_js : tryparse(Int64, val_from_js)
		select.options[val_num].first
	end
	
	function Bonds.validate_value(select::Select, val_from_js)
		val_num = val_from_js isa Integer ? val_from_js : tryparse(Int64, val_from_js)
		val_num isa Integer && 1 <= val_num <= length(select.options)
	end
	
	result
end

# ╔═╡ d64bb805-b700-4fd6-8894-2980152ce250
Select(["a" => "✅", "b" => "🆘", "c" => "🆘"])

# ╔═╡ 4f3ba840-28ce-4790-b929-ce6af8920189
Select(["a" => "🆘", "b" => "✅", "c" => "🆘"]; default="b")

# ╔═╡ b34d3a01-f8d6-4586-b655-5da84d586cd5
OldSelect(["a" => "✅", "b" => "🆘", "c" => "🆘"])

# ╔═╡ 609ab7f4-4fc4-4122-986d-9bfe54fa715d
OldSelect(["a" => "🆘", "b" => "✅", "c" => "🆘"]; default="b")

# ╔═╡ 6459df3f-143f-4d1a-a238-4447b11cc56c
HTML(repr(MIME"text/html"(), Select(["a" => "✅", "b" => "🆘", "c" => "🆘"])))

# ╔═╡ f3bef89c-61ac-4dcf-bf47-3824f11db26f
@skip_as_script HTML(repr(MIME"text/html"(), Select([sin, cos])))

# ╔═╡ f21db694-2acb-417d-9f4d-0d2400aa067e
subarrays(x) = (
	x[collect(I)]
	for I in Iterators.product(Iterators.repeated([true,false],length(x))...) |> collect |> vec
)

# ╔═╡ 5bacf96d-f24b-4e8b-81c7-47140f286e27
begin
local result = begin
	"""A multi-selector (`<select multi>`) - the user can choose one or more of the `options`, an array of `Strings.

See [`Select`](@ref) for a version that allows only one selected item.

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

The `size` keyword argument may be used to specify how many rows should be visible at once.

See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

# Examples
`@bind veg MultiSelect(["potato", "carrot"])`

`@bind veg MultiSelect(["potato" => "🥔", "carrot" => "🥕"])`

`@bind veg MultiSelect(["potato" => "🥔", "carrot" => "🥕"], default=["carrot"])`

`@bind letters MultiSelect(string.('a':'z'), size=20)`"""
struct MultiSelect
    options::Vector{Pair{<:AbstractString,<:Any}}
    default::Union{Missing, AbstractVector{AbstractString}}
	size::Int
	MultiSelect(options::AbstractVector{<:Pair{<:AbstractString,<:Any}}, default, size=missing) = 
			new(options, default, coalesce(size, min(10, length(options))))
end
end
MultiSelect(options::AbstractVector{<:AbstractString}; default=missing, size=missing) = MultiSelect([o => o for o in options], default, size)
MultiSelect(options::AbstractVector{<:Pair{<:AbstractString,<:Any}}; default=missing, size=missing) = MultiSelect(options, default, size)

function Base.show(io::IO, m::MIME"text/html", select::MultiSelect)
	show(io, m, @htl("""
			<select multiple size=$(select.size)>$(
	map(select.options) do o
			@htl(
			"<option value=$(o.first) selected=$(!ismissing(select.default) && o.first ∈ select.default)>$(
			o.second
			)</option>")
		end
	)</select>"""))
end

Base.get(select::MultiSelect) = ismissing(select.default) ? Any[] : select.default

	Bonds.initial_value(select::MultiSelect) = 
		ismissing(select.default) ? Any[] : select.default
	Bonds.possible_values(select::MultiSelect) = 
		subarrays(first.(select.options))
	function Bonds.validate_value(select::MultiSelect, val)
		val isa Vector && val ⊆ (first(p) for p in select.options)
	end

	result
end

# ╔═╡ 4d8ea460-ff2b-4e92-966e-89e76d4806af
subarrays([2,3,3]) |> collect

# ╔═╡ 998a3bd7-2d09-4b3f-8a41-50736b666dea
MultiSelect(["a" => "🆘", "b" => "✅", "c" => "🆘",  "d" => "✅", "c" => "🆘2", "c3" => "🆘"]; default=["b","d"])

# ╔═╡ e058076f-46fc-4435-ab45-530e27c95478
begin
local result = begin
"""A file upload box. The chosen file will be read by the browser, and the bytes are sent back to Julia.

The optional `accept` argument can be an array of `MIME`s. The user can only select files with these MIME. If only `image/*` MIMEs are allowed, then smartphone browsers will open the camera instead of a file browser.

## Examples

`@bind file_data FilePicker()`

`file_data["data"]`

You can limit the allowed MIME types:

```julia
@bind image_data FilePicker([MIME("image/jpg"), MIME("image/png")])
# and use MIME groups:
@bind image_data FilePicker([MIME("image/*")])
```
"""
struct FilePicker
    accept::Array{MIME,1}
end
end
FilePicker() = FilePicker(MIME[])

function Base.show(io::IO, m::MIME"text/html", filepicker::FilePicker)
	show(io, m, @htl("""<input type='file' accept=$(
    join(string.(filepicker.accept), ",")
    )>"""))
end

Base.get(select::FilePicker) = nothing

	Bonds.initial_value(select::FilePicker) = 
		nothing
	Bonds.possible_values(select::FilePicker) = 
		Bonds.InfinitePossibilities()
	function Bonds.validate_value(select::FilePicker, val)
		val isa Nothing || (
			val isa Dict && keys(val) == ["name", "data", "type"] && val["data"] isa Vector{UInt8} && val["name"] isa String && val["type"] isa String
		)
	end

	result
end

# ╔═╡ db65293b-891a-43a3-8a42-b23bf542755f
FilePicker([MIME"image/png"()])

# ╔═╡ 42e9e5ab-7d34-4300-a6c0-47f5cde658d8
begin
	local result = begin
"""A group of radio buttons - the user can choose one of the `options`, an array of `String`s. 

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.


# Examples
`@bind veg Radio(["potato", "carrot"])`

`@bind veg Radio(["potato" => "🥔", "carrot" => "🥕"])`

`@bind veg Radio(["potato" => "🥔", "carrot" => "🥕"], default="carrot")`

"""
struct Radio
    options::Vector{Pair{<:AbstractString,<:Any}}
    default::Union{Nothing, AbstractString}
end
	end
Radio(options::AbstractVector{<:AbstractString}; default=nothing) = Radio([o => o for o in options], default)
Radio(options::AbstractVector{<:Pair{<:AbstractString,<:Any}}; default=nothing) = Radio(options, default)

function Base.show(io::IO, m::MIME"text/html", radio::Radio)
    groupname = randstring('a':'z')
		
	h = @htl("""
		<form>$(
		map(radio.options) do o
			@htl("""<div>
				<input 
					type="radio" 
					id=$(groupname * o.first) 
					name=$(groupname) 
					value=$(o.first)
					checked=$(radio.default === o.first)
					>

                <label for=$(groupname * o.first)>$(
					o.second
				)</label>
            </div>""")
        end	
		)
		<script>
		const form = currentScript.parentElement
		const groupname = $(groupname)
		
        const selected_radio = form.querySelector('input[checked]')

		let val = selected_radio?.value

		Object.defineProperty(form, "value", {
			get: () => val,
			set: (newval) => {
				val = newval
				const i = document.getElementById(groupname + newval)
				if(i != null){
					i.checked = true
				}
			},
		})

        form.oninput = (e) => {
            val = e.target.value
            // and bubble upwards
        }

        
		</script>
		</form>
	""")
	show(io, m, h)
end

Base.get(radio::Radio) = radio.default

	
	Bonds.initial_value(select::Radio) = select.default
	Bonds.possible_values(select::Radio) = 
		first.(select.options)
	function Bonds.validate_value(select::Radio, val)
		val ∈ (first(p) for p in select.options)
	end
	result
end

# ╔═╡ 7c4303a1-19be-41a2-a6c7-90146e01401d
md"""
nothing checked by defualt, the initial value should be `nothing`
"""

# ╔═╡ d9522557-07e6-4a51-ae92-3abe7a7d2732
r1s = [];

# ╔═╡ d611e6f7-c574-4f0f-a46f-48ec8cf4b5aa
begin
	local result = begin
Base.@kwdef struct DateField
    default::Union{Dates.TimeType,Nothing}=nothing
end
@doc """A date input (`<input type="date">`) - the user can pick a date, the date is returned as `Dates.DateTime` via `@bind`.

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="date">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/date)

# Examples
`@bind best_day_of_my_live DateField()`

`@bind best_day_of_my_live DateField(default=today())`"""
DateField
	end

function Base.show(io::IO, m::MIME"text/html", datefield::DateField)
	show(io, m, @htl("""<input
				type="date"
				value=$(datefield.default === nothing ? "" : Dates.format(datefield.default, "Y-mm-dd"))
			>"""))
end
Base.get(datefield::DateField) = datefield.default === nothing ? nothing : Dates.DateTime(datefield.default)
	Bonds.initial_value(datefield::DateField) = 
		datefield.default === nothing ? nothing : Dates.DateTime(datefield.default)
	Bonds.possible_values(datefield::DateField) = 
		Bonds.InfinitePossibilities()

	result
end

# ╔═╡ ea7c4d05-c516-4f07-9d48-7df9ce997939
begin
local result = begin
	Base.@kwdef struct TimeField
    default::Union{Dates.TimeType,Nothing}=nothing
end
	
@doc """A time input (`<input type="time">`) - the user can pick a time, the time is returned as `String` via `@bind` (e.g. `"15:45"`). Value is `""` until a time is picked.

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="time">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/time)

# Examples
`@bind lunch_time TimeField()`

`@bind lunch_time TimeField(default=now())`"""
TimeField
end

function Base.show(io::IO, m::MIME"text/html", timefield::TimeField)
	show(io, m, @htl("<input
		type='time'
		value=$(
			timefield.default === nothing ? nothing : Dates.format(timefield.default, "HH:MM")
		)
	>"))
end
Base.get(timefield::TimeField) = timefield.default === nothing ?  "" : Dates.format(timefield.default, "HH:MM")
	Bonds.initial_value(timefield::TimeField) = 
		timefield.default === nothing ?  "" : Dates.format(timefield.default, "HH:MM")
	Bonds.possible_values(timefield::TimeField) = 
		Bonds.InfinitePossibilities()

	result
end

# ╔═╡ 4c9c1e24-235f-44f6-83f3-9f985f7fb536
# bti

# ╔═╡ e9feb20c-3667-4ea9-9278-6b68ece1de6c
begin
local result = begin
	Base.@kwdef struct ColorStringPicker
	    default::String="#000000"
	end
@doc """A color input (`<input type="color">`) - the user can pick an RGB color, the color is returned as color hex `String` via `@bind`. The value is lowercase and starts with `#`.

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="color">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color)

# Examples
`@bind color ColorStringPicker()`

`@bind color ColorStringPicker(default="#aabbcc")`
"""
ColorStringPicker
end

function Base.show(io::IO, ::MIME"text/html", colorStringPicker::ColorStringPicker)
    withtag(() -> (), io, :input, :type=>"color", :value=>colorStringPicker.default)
end
Base.get(colorStringPicker::ColorStringPicker) = colorStringPicker.default

	Bonds.initial_value(c::ColorStringPicker) = 
		c.default
	Bonds.possible_values(c::ColorStringPicker) = 
		Bonds.InfinitePossibilities()
	function Bonds.validate_value(c::ColorStringPicker, val)
		val isa String && val[1] == "#"
	end

	result
end

# ╔═╡ c2b473f4-b56b-4a91-8377-6c86da895cbe
@bind f Slider([sin, cos, sqrt, "asdf"]; default=sqrt)

# ╔═╡ 5caa34e8-e501-4248-be65-ef9c6303d025
f

# ╔═╡ 46a90b45-8fef-493e-9bd1-a71d1f9c53f6
f(123)

# ╔═╡ 328e9651-0ad1-46ce-904c-afd7deaacf94
bs = @bind s1 Slider(1:10)

# ╔═╡ 38d32393-49be-469c-840b-b58c7339a276
bs

# ╔═╡ 75b008b2-afc0-4bd5-9183-e0e0d392a4c5
@bind s2 Slider(30:.5:40; default=38, show_value=true)

# ╔═╡ 9df251eb-b4f5-46cc-a4fe-ff2fa670b773
@bind s3 Slider([sin, cos, tan], default=cos, show_value=true)

# ╔═╡ 7c5765ae-c10a-4677-97a3-848a423cb8b9
s1, s2, s3

# ╔═╡ ec870eea-36a4-48b6-95d7-f7c083e29856
bos = @bind os1 OldSlider(1:10)

# ╔═╡ b44f1128-32a5-4d1d-a00b-446143074056
bos

# ╔═╡ f6cd1201-da84-4dee-9e88-b65fa1ff749e
@bind os2 OldSlider(0:.1:1, default=.5, show_value=true)

# ╔═╡ 05f6a603-b738-47b1-b335-acaaf480a240
os1, os2, os3

# ╔═╡ c6d68308-53e7-4c60-8649-8f0161f28d70
@bind b1 Button(teststr)

# ╔═╡ c111da12-d0ca-4b9b-8ede-20f4303a1c4b
b1

# ╔═╡ cd08b524-d778-4acd-9fac-851d90df7179
@bind cb1 CounterButton() 

# ╔═╡ 6135dca4-86f9-4675-8a45-fa16b3d2c3eb
cb1

# ╔═╡ 6cb75589-5496-4edd-9b21-ea49d5c0e733
bc = @bind c1 CheckBox()

# ╔═╡ bcee47b1-0f45-4649-8517-0e93fa92bfe5
bc

# ╔═╡ 73656df8-ac9f-466d-a8d0-0a2e5dbdbd8c
@bind c2 CheckBox(true)

# ╔═╡ e89ee9a3-5c78-4ff8-81e9-f44f5150d5f6
c1, c2

# ╔═╡ 1e522148-542a-4a2f-ad92-12421a6530dc
bt1 = @bind t1 TextField()

# ╔═╡ 1ac4abe2-5f06-42c6-b614-fb9a00e65386
bt1

# ╔═╡ 1d81db28-103b-4bde-9a9a-f3038ee9b10b
@bind t2 TextField(default=teststr)

# ╔═╡ e25a2ec1-5dab-461e-bc47-6b3f1fe19d30
bt2 = @bind t3 TextField((30,2), teststr)

# ╔═╡ be68f41c-0730-461c-8782-7e8d7a745509
bt2

# ╔═╡ 00145a3e-cb62-4c54-807b-8d2bce6a9fc9
t1, t2, t3

# ╔═╡ 970681ed-1c3a-4327-b636-8cb0cdd90dbb
bpe = @bind p1 PasswordField()

# ╔═╡ e6032ca6-03a5-4bda-95d2-dcd9ee6b5924
bpe

# ╔═╡ d4bf5249-6027-43c5-bd20-48ad95721e27
@bind p2 PasswordField(teststr)

# ╔═╡ d8c60294-0ca6-4cb0-b51d-9f6d6b370b28
@bind p3 PasswordField(default=teststr)

# ╔═╡ fbc6e4c1-4bd8-43a2-ac82-e6f76033fd8e
p1, p2, p3

# ╔═╡ 57a7d0c9-2f4a-44e6-9b7a-0bbd98611c9d
bse = @bind se1 Select(["a" => "default", teststr => teststr])

# ╔═╡ a58e383a-3837-4b4c-aa84-cf64436cd870
bse

# ╔═╡ c9a291c5-b5f5-40a6-acb3-eff4882c1516
@bind se2 Select(["a" => "✅", "b" => "🆘", "c" => "🆘"])

# ╔═╡ 9729fa52-7cff-4905-9d1c-1d0eefc8ad6e
@bind se3 Select([cos => "cosine", sin => "sine"]; default=sin)

# ╔═╡ d08b571c-fe08-4911-b9f3-5a1075be50ea
@bind se4 Select([[1,Ref(2)], sqrt, cos])

# ╔═╡ 7f05f0b5-051e-4c75-b484-944daf8a274d
se1, se2, se3, se3(123), se4

# ╔═╡ 294263fe-0986-4be1-bff5-cd9f7d261c09
bose = @bind ose1 Select(["a" => "default", teststr => teststr])

# ╔═╡ 59457dc9-edaf-40c2-8503-0c3759d85ba7
bose

# ╔═╡ a238ec69-d38b-464a-9b36-959531574d19
ose1

# ╔═╡ 78473a2f-0a64-4aa5-a60a-94031a4167b8
bms = @bind ms1 MultiSelect(["a" => "default", teststr => teststr])

# ╔═╡ 43f86637-9f0b-480c-826a-bbf583e44646
bms

# ╔═╡ b6697df5-fd21-4553-9e90-1d33c0b51f70
ms1

# ╔═╡ a03af14a-e030-4ac1-b61a-0275c9956454
bf = @bind f1 FilePicker()

# ╔═╡ d4a0e98d-666c-4588-8499-f253a309a403
bf

# ╔═╡ 5ed47c49-9a31-4948-8473-0311b54eb146
f1

# ╔═╡ a95684ea-4612-45d6-b63f-41c051b53ed8
br1 = @bind r1 Radio(["a" => "default", teststr => teststr])

# ╔═╡ a5612030-0781-4cf1-b8f0-409bd3886154
br1

# ╔═╡ c2b3a7a4-8c9e-49cc-b5d0-85ad1c08fd72
r1

# ╔═╡ 69a94f6a-420a-4587-bbad-1219a390862d
push!(r1s, r1)

# ╔═╡ a1666896-baf6-466c-b680-5f3e3dffff68
bd = @bind d1 DateField()

# ╔═╡ b9300522-1b92-459c-87e2-20589d36dbb5
bd

# ╔═╡ 65bdad5e-a51b-4009-8b8e-ce93286ee5e4
d1

# ╔═╡ 4f1a909d-d21a-4e60-a615-8146ba249794
@bind d2 DateField(Dates.Date(2021, 09, 20))

# ╔═╡ d52cc4d9-cdb0-46b6-a59f-5eeaa1990f20
d2

# ╔═╡ 3aefce73-f133-43e0-8680-5c17b7f90979
bti = @bind ti3 TimeField()

# ╔═╡ d128f5ac-7304-486c-8258-f05f4bd18632
ti3

# ╔═╡ 9258586a-2612-48db-be31-cf74220002d4
bti

# ╔═╡ 7a377816-30ed-4f9f-b03f-08da4548e55f
ti3

# ╔═╡ a51dc258-1e80-4cd4-9337-b9f685db244c
@bind ti2 TimeField(Dates.Time(15, 45))

# ╔═╡ 3171441c-a98b-4a5a-aedd-09ad3b445b9e
ti2

# ╔═╡ b123275c-48fd-4e4a-8461-4875f7c18293
bco = @bind co1 ColorStringPicker()

# ╔═╡ 883673fb-b8d0-49fb-ab8c-32e972894ec2
bco

# ╔═╡ 78463563-4d1f-49f0-875f-8a30cf445a2d
co1

# ╔═╡ 1d95c38d-d336-436d-a62e-0a3786c321ca
ColorStringPicker("#ffffff")

# ╔═╡ 724125f3-7699-4103-a5d8-bc6a00fab0ff
ColorStringPicker(default="#abbaff")

# ╔═╡ 9ade9240-1fea-4cb7-a571-a98b13cc29b2
"""
Line break without creating a new paragraph. Useful inside the `md"` macro:

# Example
```julia
md"\""
Hello \$br world!
"\""
```
"""
const br = HTML("<br>")

# ╔═╡ 98d251ff-67e7-4b16-b2e0-3e2102918ca2
export Slider, NumberField, Button, LabelButton, CounterButton, CheckBox, TextField, PasswordField, Select, MultiSelect, Radio, FilePicker, DateField, TimeField, ColorStringPicker, br

# ╔═╡ Cell order:
# ╟─e8c5ba24-10e9-49e8-8c11-0add092637f8
# ╟─e1bbe1d7-68ef-4ee1-8174-d1ae1f822acb
# ╟─d738b448-387b-4942-af82-cc93042705a4
# ╟─81adbd39-5780-4cc6-a53f-a4472bacf1c0
# ╠═d8f907cd-2f89-4d54-a311-998dc8ee148e
# ╠═a0fb4f28-bfe4-4877-bf07-31acb9a56d2c
# ╠═ac542b84-dbc8-47e2-8835-9e43582b6ad7
# ╠═6da84fb9-a629-4e4c-819e-dd87a3e267ce
# ╠═dc3b6628-f453-46d9-b6a1-957608a20764
# ╠═a203d9d4-cd7b-4368-9f6d-e040a5757565
# ╠═98d251ff-67e7-4b16-b2e0-3e2102918ca2
# ╟─96084236-68f1-49b4-b866-027e7c80b5d8
# ╠═c2b473f4-b56b-4a91-8377-6c86da895cbe
# ╠═5caa34e8-e501-4248-be65-ef9c6303d025
# ╠═46a90b45-8fef-493e-9bd1-a71d1f9c53f6
# ╠═328e9651-0ad1-46ce-904c-afd7deaacf94
# ╠═38d32393-49be-469c-840b-b58c7339a276
# ╠═75b008b2-afc0-4bd5-9183-e0e0d392a4c5
# ╠═9df251eb-b4f5-46cc-a4fe-ff2fa670b773
# ╠═7c5765ae-c10a-4677-97a3-848a423cb8b9
# ╟─d088bcdb-d851-4ad7-b5a0-751c1f348995
# ╠═ec870eea-36a4-48b6-95d7-f7c083e29856
# ╠═b44f1128-32a5-4d1d-a00b-446143074056
# ╠═f6cd1201-da84-4dee-9e88-b65fa1ff749e
# ╠═e440a357-1656-4cc4-8191-146fe82fbc8c
# ╠═629e5d68-580f-4d6b-be14-5a109091e6b7
# ╠═05f6a603-b738-47b1-b335-acaaf480a240
# ╟─f59eef32-4732-46db-87b0-3564433ce43e
# ╟─b7c21c22-17f5-44b8-98de-a261d5c7192b
# ╠═7f8e4abf-e7e7-47bc-b1cc-514fa1af106c
# ╠═c6d68308-53e7-4c60-8649-8f0161f28d70
# ╠═c111da12-d0ca-4b9b-8ede-20f4303a1c4b
# ╠═3ae2351b-ac4a-4669-bb11-39a1c029b301
# ╟─548bda96-2461-48a3-a3ad-6d113337826e
# ╠═6135dca4-86f9-4675-8a45-fa16b3d2c3eb
# ╠═cd08b524-d778-4acd-9fac-851d90df7179
# ╟─76c3b77b-08aa-4899-bbdd-4f8faa8d1486
# ╠═6cb75589-5496-4edd-9b21-ea49d5c0e733
# ╠═bcee47b1-0f45-4649-8517-0e93fa92bfe5
# ╠═73656df8-ac9f-466d-a8d0-0a2e5dbdbd8c
# ╠═e89ee9a3-5c78-4ff8-81e9-f44f5150d5f6
# ╟─f81bb386-203b-4392-b974-a1e2146b1a08
# ╠═1e522148-542a-4a2f-ad92-12421a6530dc
# ╠═1ac4abe2-5f06-42c6-b614-fb9a00e65386
# ╠═1d81db28-103b-4bde-9a9a-f3038ee9b10b
# ╠═e25a2ec1-5dab-461e-bc47-6b3f1fe19d30
# ╠═be68f41c-0730-461c-8782-7e8d7a745509
# ╠═4363f31e-1d71-4ad8-bfe8-04403d2d3621
# ╠═00145a3e-cb62-4c54-807b-8d2bce6a9fc9
# ╟─c9614498-54a8-4925-9353-7a13d3303916
# ╠═970681ed-1c3a-4327-b636-8cb0cdd90dbb
# ╠═e6032ca6-03a5-4bda-95d2-dcd9ee6b5924
# ╠═d4bf5249-6027-43c5-bd20-48ad95721e27
# ╠═d8c60294-0ca6-4cb0-b51d-9f6d6b370b28
# ╠═fbc6e4c1-4bd8-43a2-ac82-e6f76033fd8e
# ╟─eb4e17fd-07ba-4031-a39f-0d9fccd3d886
# ╠═519f4da9-0205-486e-aea6-9dd5db6b38e0
# ╠═57a7d0c9-2f4a-44e6-9b7a-0bbd98611c9d
# ╠═c9a291c5-b5f5-40a6-acb3-eff4882c1516
# ╠═9729fa52-7cff-4905-9d1c-1d0eefc8ad6e
# ╠═d08b571c-fe08-4911-b9f3-5a1075be50ea
# ╠═a58e383a-3837-4b4c-aa84-cf64436cd870
# ╠═7f05f0b5-051e-4c75-b484-944daf8a274d
# ╠═d64bb805-b700-4fd6-8894-2980152ce250
# ╠═4f3ba840-28ce-4790-b929-ce6af8920189
# ╟─edfdbaee-ec31-40c2-9ad5-28250fe6b651
# ╠═294263fe-0986-4be1-bff5-cd9f7d261c09
# ╠═59457dc9-edaf-40c2-8503-0c3759d85ba7
# ╠═a238ec69-d38b-464a-9b36-959531574d19
# ╠═b34d3a01-f8d6-4586-b655-5da84d586cd5
# ╠═609ab7f4-4fc4-4122-986d-9bfe54fa715d
# ╠═6459df3f-143f-4d1a-a238-4447b11cc56c
# ╠═f3bef89c-61ac-4dcf-bf47-3824f11db26f
# ╠═42e9e5ab-7d34-4300-a6c0-47f5cde658d8
# ╠═57232d88-b74f-4823-be61-8db450c93f5c
# ╟─7c4303a1-19be-41a2-a6c7-90146e01401d
# ╠═a95684ea-4612-45d6-b63f-41c051b53ed8
# ╠═a5612030-0781-4cf1-b8f0-409bd3886154
# ╠═c2b3a7a4-8c9e-49cc-b5d0-85ad1c08fd72
# ╠═69a94f6a-420a-4587-bbad-1219a390862d
# ╠═d9522557-07e6-4a51-ae92-3abe7a7d2732
# ╟─5bacf96d-f24b-4e8b-81c7-47140f286e27
# ╟─f21db694-2acb-417d-9f4d-0d2400aa067e
# ╠═4d8ea460-ff2b-4e92-966e-89e76d4806af
# ╠═78473a2f-0a64-4aa5-a60a-94031a4167b8
# ╠═43f86637-9f0b-480c-826a-bbf583e44646
# ╠═b6697df5-fd21-4553-9e90-1d33c0b51f70
# ╠═998a3bd7-2d09-4b3f-8a41-50736b666dea
# ╟─e058076f-46fc-4435-ab45-530e27c95478
# ╠═a03af14a-e030-4ac1-b61a-0275c9956454
# ╠═d4a0e98d-666c-4588-8499-f253a309a403
# ╠═5ed47c49-9a31-4948-8473-0311b54eb146
# ╠═db65293b-891a-43a3-8a42-b23bf542755f
# ╟─d611e6f7-c574-4f0f-a46f-48ec8cf4b5aa
# ╠═a1666896-baf6-466c-b680-5f3e3dffff68
# ╠═b9300522-1b92-459c-87e2-20589d36dbb5
# ╠═65bdad5e-a51b-4009-8b8e-ce93286ee5e4
# ╠═4f1a909d-d21a-4e60-a615-8146ba249794
# ╠═d52cc4d9-cdb0-46b6-a59f-5eeaa1990f20
# ╟─ea7c4d05-c516-4f07-9d48-7df9ce997939
# ╠═3aefce73-f133-43e0-8680-5c17b7f90979
# ╠═d128f5ac-7304-486c-8258-f05f4bd18632
# ╠═9258586a-2612-48db-be31-cf74220002d4
# ╠═4c9c1e24-235f-44f6-83f3-9f985f7fb536
# ╠═7a377816-30ed-4f9f-b03f-08da4548e55f
# ╠═a51dc258-1e80-4cd4-9337-b9f685db244c
# ╠═3171441c-a98b-4a5a-aedd-09ad3b445b9e
# ╟─e9feb20c-3667-4ea9-9278-6b68ece1de6c
# ╠═b123275c-48fd-4e4a-8461-4875f7c18293
# ╠═883673fb-b8d0-49fb-ab8c-32e972894ec2
# ╠═78463563-4d1f-49f0-875f-8a30cf445a2d
# ╠═1d95c38d-d336-436d-a62e-0a3786c321ca
# ╠═724125f3-7699-4103-a5d8-bc6a00fab0ff
# ╟─9ade9240-1fea-4cb7-a571-a98b13cc29b2
