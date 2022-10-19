export ScrubbableMatrix


function ScrubbableMatrix2(A::Matrix{<:Real}; kwargs...)
	# Create a new widget that combines existing ones
	PlutoUI.combine() do Child
		
		# Create a matrix of scrubbables
		# (Note that each `Scrubbable` is wrapped in the `Child` function!)
		scrubbables = map(A) do x
			Child(PlutoUI.Scrubbable(x); kwargs...)
		end

		# use Layout to display them in a grid
		PlutoUI.ExperimentalLayout.grid(
			scrubbables;
			scrubbable_matrix_style...
		)
	end
end


function ScrubbableMatrix3(A::Matrix{T}; kwargs...) where {T<:Real}
	# Use our previous function:
	display = ScrubbableMatrix2(A; kwargs...)

	# Overlay the Tuple -> Matrix transformation
	PlutoUI.Experimental.transformed_value(display) do input::Tuple
		# 1. Tuple to Vector
		vector = collect(input)
		
		# 2. Squish the Vector into a Matrix (lazy)
		flipped_matrix = reshape(vector, size(A) |> reverse)
		
		# 3. Take the adjoint (lazy)
		matrix = PermutedDimsArray(flipped_matrix, (2,1))

		# 4. Convert into the right type
		Matrix{T}(matrix)
	end
end

"""
```julia
ScrubbableMatrix(A::Matrix{<:Real}; kwargs...)
```

The [`PlutoUI.Scrubbable`](@ref) widget, but in a 2D grid. Additional keyword arguments will apply to all scrubbables.
"""
const ScrubbableMatrix = ScrubbableMatrix3