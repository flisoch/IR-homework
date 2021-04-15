### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ a94449d4-9168-11eb-1039-3b9702b639c4
using TextAnalysis

# ╔═╡ 8e0af7c4-916d-11eb-1ad6-077acec16da2
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 0f67bb9e-916a-11eb-1c23-3f9aa8604928
task2 = ingredients("../task2 - tokens/Task2.jl")

# ╔═╡ e74466ca-916d-11eb-0121-b55cb26560a6
# task3 = ingredients("../task3 - inverted index/Task3.jl")

# ╔═╡ 0eae7edc-916e-11eb-27d8-f926ca445ca7
task3.filescount

# ╔═╡ Cell order:
# ╠═a94449d4-9168-11eb-1039-3b9702b639c4
# ╠═8e0af7c4-916d-11eb-1ad6-077acec16da2
# ╠═0f67bb9e-916a-11eb-1c23-3f9aa8604928
# ╠═e74466ca-916d-11eb-0121-b55cb26560a6
# ╠═0eae7edc-916e-11eb-27d8-f926ca445ca7
