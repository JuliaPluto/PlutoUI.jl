export Clock, ClockChecker, checks, ticking, ticks_per_check

struct Clock
	interval::Real
	fixed::Bool
	Clock(interval=1, fixed=false) = interval >= 0 ? new(interval, fixed) : error("interval must be non-negative")
end

function show(io::IO, ::MIME"text/html", clock::Clock)
    # We split the HTML string into multiple files, but you could also write all of this into a single (long) string 🎈
	cb = read(joinpath(PKG_ROOT_DIR, "assets", "clock_back.svg"), String)
	cf = read(joinpath(PKG_ROOT_DIR, "assets", "clock_front.svg"), String)
	cz = read(joinpath(PKG_ROOT_DIR, "assets", "clock_zoof.svg"), String)
	js = read(joinpath(PKG_ROOT_DIR, "assets", "clock.js"), String)
	css = read(joinpath(PKG_ROOT_DIR, "assets", "clock.css"), String)
	
	result = """
	<clock$(clock.fixed ? " class='fixed'" : "")>
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

"""
    Clock checker tests if the clock is running.

````
@bind ticker Clock(0.2)
````

````
checker=ClockChecker()
````

````
with_terminal() do
     if ticking(checker,ticker)
           println(round(ticks_per_check(checker,ticker),digits=2))
           println(collect(1:checks(checker)))
     end
end
````

"""
mutable struct ClockChecker
	previous_tick
	checks
	ClockChecker()=new(1,0)
end


"""
    Return number of successful checks after last restart of the clock.
"""
checks(checker::ClockChecker)=checker.checks

"""
    Return number of clock ticks per checks
"""
ticks_per_check(checker::ClockChecker,ticker)=checker.checks>0 ?  Float64(ticker)/Float64(checker.checks) : 0


"""
    Check if the clock is ticking, increase checks if yes.
"""
function ticking(checker::ClockChecker,ticker)
	if ticker==1
		checker.previous_tick=1
		checker.checks=1
		return true
	end
	if ticker>checker.previous_tick
		checker.previous_tick=ticker
		checker.checks+=1
		return true
	end
	false
end

