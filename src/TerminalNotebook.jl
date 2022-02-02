### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 2da76520-1615-11ec-1ad7-8f93957b2e6e
import IOCapture

# ╔═╡ 1810dc75-f4c1-4d3f-963d-0f881abeee19
import UUIDs: UUID

# ╔═╡ 8f1483c0-49f0-4882-92d8-780d84e63d8d
import HypertextLiteral: @htl, @htl_str

# ╔═╡ e3975303-9295-489a-b0a5-cb6624eab890
md"## Library"

# ╔═╡ 6124c693-f752-4036-a011-b06300f61a6d
"""
    force_color_stdout(f::Function)

Because `IOCapture`, even when specifying `color=true`, still just inherits the color property from the current stdout and stderr, we need to add one layer extra just to force color to true.

I hope nothing gets accidentally written to the streams I make, because they redirect to `devnull` 😅
"""
function force_color_stdout(f)
	default_stdout = stdout
 	default_stderr = stderr

	try
		redirect_stdout(IOContext(devnull, :color => true))
		redirect_stderr(IOContext(devnull, :color => true))
		f()
	finally
		redirect_stdout(default_stdout)
		redirect_stderr(default_stderr)
	end
end

# ╔═╡ c98e0f1b-c489-48ed-b69e-5cbc06267429
"""
    force_color_crayons(f::Function)

It never stops... Crayons also has some other way of determining if it should actually show the colors... I DON'T CARE I JUST WANT COLORS.

So I'm using `Crayons.FORCE_COLOR[] = true` and hope it listens
"""
function force_color_crayons(f)
	CRAYONS_PKGID = Base.PkgId(UUID("a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"), "Crayons")
	if haskey(Base.loaded_modules, CRAYONS_PKGID)
		Crayons = Base.loaded_modules[CRAYONS_PKGID]
		original_crayons_force_color = Crayons.FORCE_COLOR[] 
		try
			Crayons.FORCE_COLOR[] = true
			f()
		finally
			Crayons.FORCE_COLOR[] = original_crayons_force_color
		end
	else
		f()
	end
end

# ╔═╡ bf684e0c-e0f2-452c-b9a4-8452233ff920
Base.@kwdef struct WithTerminalOutput
	value
	output
	show_value
end

# ╔═╡ d416b336-a6ee-4059-93af-08b12d59defd
function Base.show(io::IO, ::MIME"text/html", terminal_output::WithTerminalOutput)
	value_to_show = if (
		terminal_output.show_value &&
		terminal_output.value !== nothing
	)
        if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
            Main.PlutoRunner.embed_display(terminal_output.value)
        else
            htl"<span>$(value)</span>"
        end
    else
		""
	end

	show(io, MIME("text/html"), @htl("""
		<div style="display: inline; white-space: normal;">
			$(value_to_show)
			
			<script src="https://cdn.jsdelivr.net/npm/ansi_up@5.0.1/ansi_up.min.js"></script>
			<script type="text/javascript">
				var txt = $(terminal_output.output)

				var container = html`
					<pre
						class="PlutoUI_terminal"
						style="
							max-height: 300px;
							overflow: auto;
							white-space: pre;
							color: white;
							background-color: black;
							border-radius: 3px;
							margin-top: 8px;
							margin-bottom: 8px;
							padding: 15px;
							display: block;
						"
					></pre>
				`
				container.innerHTML = new AnsiUp().ansi_to_html(txt);
				return container
			</script>
		</div>
	"""))
end

# ╔═╡ a0df0558-6b19-471d-b609-df3ee65dadbb
"""
    with_terminal(f::Function; color::Bool=true, show_value::Bool=true)

Run the function, and capture all messages to `stdout`. The result will be a small terminal displaying the captured text.

This allows you to to see the messages from `println`, `dump`, `Pkg.status`, etc.

Example:

```julia
with_terminal() do
    x=1+1
    println(x)
    @warn "Oopsie!"
end 
```

```julia
with_terminal(show_value=false) do
    @time x=sum(1:100000)
end 
```

```julia
with_terminal(dump, [1,2,[3,4]])
```

See also [PlutoUI.Dump](@ref).
"""
function with_terminal(f, args...; color=true, show_value=true)
	if color
		force_color_stdout() do
			force_color_crayons() do
				value, output = IOCapture.capture(color=true) do
					f(args...)
				end
				WithTerminalOutput(
					value=value,
					output=output,
					show_value=show_value,
				)
			end
		end
	else
		value, output = IOCapture.capture() do
			f(args...)
		end
		WithTerminalOutput(
			value=value,
			output=output,
			show_value=show_value,
		)
	end
end

# ╔═╡ bb087be9-fc7e-46a1-9ff3-2a5f97a27add
function is_inside_pluto(m::Module)::Bool
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) === Main
	end
end

# ╔═╡ 0ffed232-19c8-47f1-af97-23989687ae6e
"""
	@skip_as_script expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) is_inside_pluto(__module__) ? esc(ex) : nothing end

# ╔═╡ 924c5ca1-f9f1-4b4b-b3d9-e74d6b2feae9
@skip_as_script begin
	import Pkg
	Pkg.activate("..")
end

# ╔═╡ 376b7763-dd17-4147-a246-a530ace698ec
return_value = @skip_as_script with_terminal() do
	@info "Hey!"
	@warn "Wow"
	@error "Hi"
	[1, 2, 3, 4, 5, 6, 7, 8]
end

# ╔═╡ 4a93743e-0700-4049-880a-ac5b0cf0b0f5
inside_array_looks_funky = @skip_as_script [return_value, return_value]

# ╔═╡ 3072a9cf-ad45-463c-866e-ed2bba434a95
md"## Examples"

# ╔═╡ 5cd4a175-2290-441a-989d-f26921d090bb
@skip_as_script with_terminal(color=false) do
	@info "Hey!"
	@error "Hi"
end

# ╔═╡ c2c01f9a-151d-46b5-9ffd-45087fbf9381
@skip_as_script with_terminal(dump, [1,2,[3,4]])

# ╔═╡ 15383b08-1ad9-4f0b-9eb0-e55025ef5c26
md"""
### Crayons

Okay... can't show this demo because of Crayons isn't in PlutoUI
"""

# ╔═╡ 24250f93-16ce-456c-919f-d3a3d57a58f0
#@skip_as_script import Crayons: @crayon_str

# ╔═╡ d501d4fd-975b-4459-b9e0-bfb8947ee538
# @skip_as_script with_terminal() do
# 	println("$(crayon"red")With Crayons! (in red)")
# 	println("$(crayon"blue")Blue!")
# 	println("$(crayon"reset")$(crayon"bold")Bold!")
# end

# ╔═╡ 67e1fdf0-3bf7-4553-9be9-0f38bb2d2ef0
md"### ls --color"

# ╔═╡ 988d2c53-3f4f-40e8-8069-a24a8e10a8ca
# This command doesn't show colors for me... but maybe for someone else it works idk
@skip_as_script with_terminal() do
	run(`ls -lh --color`)
end

# ╔═╡ 342e1498-4dcd-46c3-ab43-75832e5655ff
md"### @code_llvm"

# ╔═╡ e0d49688-ef83-4607-8747-7e4e4f0003c2
@skip_as_script with_terminal() do
	@code_llvm [1,2,3,4,1//3] .* [2,3,4,.5]
end

# ╔═╡ 34a131cb-3f79-4fcf-91f2-828ee9115127
md"""
### Macro version because idk

Just keeping this here in case someone wants to un-@skip\_as\_script it
"""

# ╔═╡ e8f72c6d-1b48-4b30-acee-4ec519682070
macro with_terminal(expr)
	quote
		$(with_terminal)() do
			$(esc(expr))
		end
	end
end

# ╔═╡ fe8c0c2f-8555-44f0-ae30-628ad4860157
export with_terminal, @with_terminal

# ╔═╡ 329d47a4-7ae1-49fb-9411-55cbc113195b
@skip_as_script @with_terminal @info "Hey!"

# ╔═╡ Cell order:
# ╠═924c5ca1-f9f1-4b4b-b3d9-e74d6b2feae9
# ╠═2da76520-1615-11ec-1ad7-8f93957b2e6e
# ╠═1810dc75-f4c1-4d3f-963d-0f881abeee19
# ╠═8f1483c0-49f0-4882-92d8-780d84e63d8d
# ╠═fe8c0c2f-8555-44f0-ae30-628ad4860157
# ╠═376b7763-dd17-4147-a246-a530ace698ec
# ╠═4a93743e-0700-4049-880a-ac5b0cf0b0f5
# ╟─e3975303-9295-489a-b0a5-cb6624eab890
# ╟─6124c693-f752-4036-a011-b06300f61a6d
# ╟─c98e0f1b-c489-48ed-b69e-5cbc06267429
# ╠═bf684e0c-e0f2-452c-b9a4-8452233ff920
# ╠═d416b336-a6ee-4059-93af-08b12d59defd
# ╠═a0df0558-6b19-471d-b609-df3ee65dadbb
# ╟─bb087be9-fc7e-46a1-9ff3-2a5f97a27add
# ╟─0ffed232-19c8-47f1-af97-23989687ae6e
# ╟─3072a9cf-ad45-463c-866e-ed2bba434a95
# ╠═5cd4a175-2290-441a-989d-f26921d090bb
# ╠═c2c01f9a-151d-46b5-9ffd-45087fbf9381
# ╟─15383b08-1ad9-4f0b-9eb0-e55025ef5c26
# ╠═24250f93-16ce-456c-919f-d3a3d57a58f0
# ╠═d501d4fd-975b-4459-b9e0-bfb8947ee538
# ╟─67e1fdf0-3bf7-4553-9be9-0f38bb2d2ef0
# ╠═988d2c53-3f4f-40e8-8069-a24a8e10a8ca
# ╟─342e1498-4dcd-46c3-ab43-75832e5655ff
# ╠═e0d49688-ef83-4607-8747-7e4e4f0003c2
# ╟─34a131cb-3f79-4fcf-91f2-828ee9115127
# ╠═329d47a4-7ae1-49fb-9411-55cbc113195b
# ╠═e8f72c6d-1b48-4b30-acee-4ec519682070
