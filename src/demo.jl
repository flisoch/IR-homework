### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 7bfc0f62-94d0-11eb-00df-75708bed0bfc
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

# ╔═╡ 117b2dd5-a855-43d9-acef-a4e66f5b2e07
VectorSearch = ingredients("vector_search.jl")

# ╔═╡ 60a4b5a2-6e0c-4885-9996-72c406493511
searcher = VectorSearch.searcher()

# ╔═╡ e2328b1e-deec-4a05-8b50-bb0dcaf4bf20
query = "president"

# ╔═╡ 7fba7bbc-40f8-4425-8414-36b8b122d4fc
VectorSearch.search(query, searcher)

# ╔═╡ Cell order:
# ╟─7bfc0f62-94d0-11eb-00df-75708bed0bfc
# ╠═117b2dd5-a855-43d9-acef-a4e66f5b2e07
# ╠═60a4b5a2-6e0c-4885-9996-72c406493511
# ╠═e2328b1e-deec-4a05-8b50-bb0dcaf4bf20
# ╠═7fba7bbc-40f8-4425-8414-36b8b122d4fc
