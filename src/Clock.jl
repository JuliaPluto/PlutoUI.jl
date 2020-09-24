export Clock

struct Clock
	interval::Real
	fixed::Bool
	stopped::Bool
	Clock(interval=1; fixed=false, stopped=false) = interval >= 0 ? new(interval, fixed, stopped) : error("interval must be non-negative")
end

function show(io::IO, ::MIME"text/html", clock::Clock)
    # We split the HTML string into multiple files, but you could also write all of this into a single (long) string 🎈
	cb = read(joinpath(PKG_ROOT_DIR, "assets", "clock_back.svg"), String)
	cf = read(joinpath(PKG_ROOT_DIR, "assets", "clock_front.svg"), String)
	cz = read(joinpath(PKG_ROOT_DIR, "assets", "clock_zoof.svg"), String)
	js = read(joinpath(PKG_ROOT_DIR, "assets", "clock.js"), String)
	css = read(joinpath(PKG_ROOT_DIR, "assets", "clock.css"), String)
	
	result = """
	<clock$(if clock.fixed && clock.stopped
                " class='fixed stopped'"
            elseif clock.fixed
                " class='fixed'"
            elseif clock.stopped
                " class='stopped'"
            else
                ""
            end
            )>
		<analog>
			<back>$(cb)</back>
			<front>$(cf)</front>
			<zoof style="opacity: 0">$(cz)</zoof>
		</analog>
		<button></button>
		<span>speed: </span>
		<input type="number" value="$(clock.interval)"  min=0 step=any lang="en-001">
		<span id="unit" title="Click to invert"></span>
	</clock>
	<script>
		$(js)
	</script>
	<style>
		$(css)
	</style>
    """
    write(io, result)
end

get(clock::Clock) = 1
