"""
```julia
PlutoUI.wrapped(render_function::Function)
```

Wrap an existing widget inside HTML content.

`render_function` is a function that you write yourself, take a look at the examples below.

# Examples

## 🐶

We use the [`do` syntax](https://docs.julialang.org/en/v1/manual/functions/#Do-Block-Syntax-for-Function-Arguments) to write our `render_function`. The `Child` function is wrapped around the input that we want to capture.

```julia
DogsSlider(range) = wrapped() do Child
	md""\"
	### How many dogs do you have?

	I have \$(
		Child(Slider(range))
	) dogs.
	""\"
end

@bind num_dogs DogsSlider(5:10)

num_dogs == 5 # (initially)
```


> The output looks like:
> 
> ![screenshot of running the code above inside Pluto](https://user-images.githubusercontent.com/6933510/148256466-4c525a00-de86-40c4-a6c4-388b5be3dc1c.png)

"""
wrapped(f::Function) = transformed_value(only, combine(f))

# that's just 1 line of code, pretty cool right!
