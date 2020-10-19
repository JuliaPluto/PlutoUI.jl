include("parser.jl")

@widget FilePicker """<input type='file' accept='{{#accepts}}{{.}}, {{/accepts}}'>""" accepts=[] default=Dict("name" => "", "data" => UInt8[], "type" => "")

@widget Slider """<input type="range"
min="{{start}}"  step="{{step}}" max="{{stop}}"
value="{{default}}" {{#show_value}} oninput="this.nextElementSibling.value=this.value" {{/show_value}}>""" default=start show_value=false
function Slider(range; default=first(range), show_value=false)
    Slider(start=first(range), step=step(range), stop=last(range), default=default, show_value=show_value)
end

@widget NumberField """
<input type="number" min="{{start}}" step="{{step}}" max="{{stop}}" value="{{default}}">
""" default=start
function NumberField(range; default=first(range))
    Slider(start=first(range), step=step(range), stop=last(range), default=default)
end

@widget Button """<input type="button" value="{{label}}">""" default=label

@widget CheckBox """<input type="checkbox" {{#default}}checked{{/default}}>""" default=false

@widget TextField """{{^dims}}<input type="text" value="{{default}}">{{/dims}}
{{@dims}}<textarea {{#dims}}{{#.[1]}}cols="{{.}}"{{/.[1]}} {{#.[2]}}rows="{{.}}"{{/.[2]}}{{/dims}}>{{default}}</textarea>{{/dims}}""" default="" dims=missing

@widget PasswordField """<input type="password" value="{{default}}">""" default=""

@widget Select """<select id="{{id}}" value={{default}}>
{{#options}}{{#.}}<option value={{first}}>{{second}}</option>{{/.}}{{/options}}
</select>
<script>
var element = document.getElementById("{{id}}");
element.value = {{default}};
</script>
""" default=options[1].first id=randstring('a':'z')

@widget MultiSelect """<select multiple id="{{id}}">
{{#options}}{{#.}}<option value="{{first}}">{{second}}</option>{{/.}}{{/options}}
</select>
<script>
var element = document.getElementById("{{id}}");
element.value = {{{default}}};
</script>
""" default=[] id=randstring('a':'z')

@widget Radio """
<form id="{{groupname}}">
{{#options}}<div>{{#.}}
<input type="radio" id="{{groupname}}{{first}}" name="{{groupname}}" value="{{first}}">{{second}}
{{/.}}</div>{{/options}}
</form>
<script>
    const form = this.querySelector('#{{groupname}}')

    form.oninput = (e) => {
        form.value = e.target.value
        // and bubble upwards
    }

    // set initial value:
    const selected_radio = form.querySelector('input[checked]')
    if(selected_radio != null){
        form.value = selected_radio.value
    }
</script>
""" groupname = randstring('a':'z') default=""

@widget DateField """<input type="date", value={{default}}>""" default=""
@widget TimeField """<input type="time", value={{default}}>""" default=""
@widget ColorStringPicker """<input type="color", value={{default}}>""" default="#000000"

@widget Clock """
<clock class='{{@fixed}}fixed{{/fixed}} {{^start_running}}stopped{{/start_running}}'>
	<analog>
        <back>{{cb}}</back>
        <front>{{cf}}</front>
        <zoof style="opacity: 0">{{cz}}</zoof>
    </analog>
    <button></button>
    <span>speed: </span>
    <input type="number" value="{{interval}}"  min=0 step=any lang="en-001">
    <span id="unit" title="Click to invert"></span>
</clock>
<script>
{{js}}
</script>
<style>
{{css}}
</style>
""" fixed=false start_running=false default=1 interval=1 cb=read(joinpath(PKG_ROOT_DIR, "assets", "clock_back.svg"), String) cf=read(joinpath(PKG_ROOT_DIR, "assets", "clock_front.svg"), String) cz=read(joinpath(PKG_ROOT_DIR, "assets", "clock_zoof.svg"), String) js=read(joinpath(PKG_ROOT_DIR, "assets", "clock.js"), String) css=read(joinpath(PKG_ROOT_DIR, "assets", "clock.css"), String)

