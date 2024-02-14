
![](https://user-images.githubusercontent.com/6933510/174067690-50c8128d-748b-4f50-8a76-2ce18166642b.png)

# PlutoUI.jl

[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://featured.plutojl.org/basic/plutoui.jl) [![Run with binder](https://mybinder.org/badge_logo.svg)](https://pluto-featured-notebooks.netlify.app/classic%20samples/plutoui.jl?preamble_html=%0A%3Cscript%3E%0ArequestIdleCallback(()%20%3D%3E%20window.start_binder())%0A%3C%2Fscript%3E%0A)

A small package with interactive elements to be used in [Pluto.jl](https://plutojl.org/).

```julia
@bind x PlutoUI.Slider(1:100)
```
```julia
repeat("Hello ", x)
```

For **documentation**, read the [**PlutoUI.jl featured notebook**](https://featured.plutojl.org/basic/plutoui.jl).
