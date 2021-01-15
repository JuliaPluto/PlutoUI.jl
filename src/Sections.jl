struct Section
  id
  object
end

function Base.show(io::IO, mime::MIME, s::Section)
  iobuff = IOBuffer()
  show(iobuff, mime, s.object)
  cb = HTML("""
  <style>
  pluto-cell.hide_below_$(s.id) {
    display: none;
  }
  </style>
  <script>
  const container = currentScript.parentElement;
  console.log(container)
  const cell = currentScript.closest("pluto-cell")
  const checkbox = container.querySelector("#checkbox");
  const setclass = () => {
    let k = Array.from(cell.parentElement.children)
    for (let i = k.indexOf(cell)+1; i<k.length;i++){
      k[i].classList.toggle("hide_below_$(s.id)", !checkbox.checked)
    }
    container.value = $(s.id) # s.id is the value to be sent to the bound variable
    container.dispatchEvent(new CustomEvent("input"));
  }
  checkbox.addEventListener("input", setclass);
  setclass()
  </script>
  Display Section <input type="checkbox" id="checkbox" checked>
  """ * String(take!(iobuff)))
  show(iobuff, mime, cb)
  write(io, take!(iobuff))
end
PlutoUI.get(s::Section) = s.id
endsection(sid::Int) = HTML("""
  <script>
    let cell = currentScript.closest("pluto-cell")
    let k = Array.from(cell.parentElement.children)
    let i
    for (i = k.indexOf(cell)+1; i<k.length;i++){
      k[i].classList.toggle("hide_below_$(sid)", false)
    }
  </script>
""")


#=
To be used as
```julia
@bind s1 Section(0, md"# I'm Visible")
cells
cells
cells
endsection(s1)
```
The Section works fine, but the s1 being bound is not updated, so the 
endsection cell is not run on Section update, which means that all the cells get hidden
=#
