include("parser.jl")

@widget FilePicker """<input type='file' accept='{{#accepts}}{{.}}, {{/accepts}}'>""" accepts=[] default=Dict("name" => "", "data" => UInt8[], "type" => "")

@widget Slider3 """<input type="range"
{{#range}} min="{{start}}"  step="{{step}}" max="{{stop}}" {{/range}}
value="{{default}}" {{#show_value}} oninput="this.nextElementSibling.value=this.value" {{/show_value}}>""" show_value=false default=range.start

@widget NumberField """
<input type="number" {{#range}}min="{{range.start}}" step="{{range.step}}" max="{{range.stop}}" {{/range}}value="{{default}}">
""" default=range.start

@widget Button """<input type="button" value="{{label}}">""" default=label

@widget CheckBox """<input type="checkbox" {{#default}}checked{{/default}}>""" default=false

@widget TextField """{{^dims}}<input type="text" value="{{default}}">{{/dims}}
<textarea {{#dims}}{{#.[1]}}cols="{{.}}"{{/.[1]}} {{#.[2]}}rows="{{.}}"{{/.[2]}}{{/dims}}>{{default}}</textarea>""" default="" dims=missing

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
