export Timer

struct Timer
	interval::Real
	fixed::Bool
	Timer(interval=1, fixed=false) = interval >= 0 ? new(interval, fixed) : error("interval must be non-negative")
end

function show(io::IO, ::MIME"text/html", timer::Timer)
    # We split the HTML string into multiple files, but you could also write all of this into a single (long) string 🎈
	tb = read(joinpath(PKG_ROOT_DIR, "assets", "timer_back.svg"), String)
	tf = read(joinpath(PKG_ROOT_DIR, "assets", "timer_front.svg"), String)
	tz = read(joinpath(PKG_ROOT_DIR, "assets", "timer_zoof.svg"), String)
	js = read(joinpath(PKG_ROOT_DIR, "assets", "timer.js"), String)
	css = read(joinpath(PKG_ROOT_DIR, "assets", "timer.css"), String)
	
	result = """
	<timer$(timer.fixed ? " class='fixed'" : "")>
		<clock>
			<back>$(tb)</back>
			<front>$(tf)</front>
			<zoof style="opacity: 0">$(tz)</zoof>
		</clock>
		<button></button>
		<span>speed: </span>
		<input type="number" value="$(timer.interval)"  min=0 step=any lang="en-001">
		<span id="unit" title="Click to invert"></span>
	</timer>
	<script>
		$(js)
	</script>
	<style>
		$(css)
	</style>
    """
    write(io, result)
end

peek(timer::Timer) = 1