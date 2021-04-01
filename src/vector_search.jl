### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 02d140f4-9585-4699-b306-d99c63451afc
using PlutoUI

# ╔═╡ b6ab3fe0-688d-4c26-800d-a0beaea7ad58
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

# ╔═╡ 2ae193d5-def1-44ab-ba16-4c3418e43e7f
@bind query TextField()

# ╔═╡ e2e3caf4-fe6b-4d82-a4a4-e2f47e427f44
query

# ╔═╡ cc606c37-ea00-40ea-affa-b4b3e39c2e6a


# ╔═╡ Cell order:
# ╠═02d140f4-9585-4699-b306-d99c63451afc
# ╠═b6ab3fe0-688d-4c26-800d-a0beaea7ad58
# ╠═2ae193d5-def1-44ab-ba16-4c3418e43e7f
# ╠═e2e3caf4-fe6b-4d82-a4a4-e2f47e427f44
# ╠═cc606c37-ea00-40ea-affa-b4b3e39c2e6a
