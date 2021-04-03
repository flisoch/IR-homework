### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ b985c3a2-bdee-4d23-9de7-fa5e56670153
using DataStructures

# ╔═╡ 5f6091d0-932d-11eb-1ff2-81e7f2a1a69a
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

# ╔═╡ d4dca4f0-09fb-47db-a6bd-f32f275d32e8
InverseIndex = ingredients("inverse_index.jl")

# ╔═╡ 33c22acb-5b4d-4fd7-bbb7-7ec13ed1bad7
corpus = InverseIndex.loadtexts([x for x=1:98])

# ╔═╡ 40f7ff8c-3d9d-4f50-accc-34b0db05652c
# corpus.lexicon["gautama"]

# ╔═╡ f368dac6-2ced-4077-ae57-10576264eac2
invidx = InverseIndex.saved_inverseindex()

# ╔═╡ 7f3a0391-2010-421f-a20c-76e3ecacf92a
function withoutsecond(list1, list2)
	both = unique([list1; list2])
	findall(x -> (x in list1) && !(x in list2), both)
end

# ╔═╡ c28d26c9-c18f-41cd-9286-035ab0f7f56b
query = "buddha god"

# ╔═╡ 8702638f-ab5c-4e45-87f0-7795dfb45476
s = split(query)

# ╔═╡ 334ffc1c-4992-4306-9c78-ddde65ae542b
function booleansearch(invidx, query)
	s = split(query)
	s = map(x -> String(x) , s)
	hasbool = true
	if !("AND" in s) && !("OR" in s) && !("NOT" in s)
		hasbool = false
	end
	@show hasbool
	result = invidx[s[1]]
		
	for i = 2:length(s)
		if !hasbool
			result = unique([result; invidx[s[i]]])
		else
			if (i != length(s))
				nextword = s[i+1]
				if s[i] == "AND"
					result = intersect(result, invidx[nextword])
				elseif s[i] == "OR"
					result = unique([result; invidx[nextword]])
				elseif s[i] == "NOT"
					result = withoutsecond(result, invidx[nextword])
				else
					result = unique([result; invidx[s[i]]])
				end
			end
		end
	end
	result
end

# ╔═╡ 196c68e1-0fbe-4858-9fac-e1851e51f756
booleansearch(invidx, query)

# ╔═╡ Cell order:
# ╠═b985c3a2-bdee-4d23-9de7-fa5e56670153
# ╠═5f6091d0-932d-11eb-1ff2-81e7f2a1a69a
# ╠═d4dca4f0-09fb-47db-a6bd-f32f275d32e8
# ╠═33c22acb-5b4d-4fd7-bbb7-7ec13ed1bad7
# ╠═40f7ff8c-3d9d-4f50-accc-34b0db05652c
# ╠═f368dac6-2ced-4077-ae57-10576264eac2
# ╠═7f3a0391-2010-421f-a20c-76e3ecacf92a
# ╠═c28d26c9-c18f-41cd-9286-035ab0f7f56b
# ╠═8702638f-ab5c-4e45-87f0-7795dfb45476
# ╠═334ffc1c-4992-4306-9c78-ddde65ae542b
# ╠═196c68e1-0fbe-4858-9fac-e1851e51f756
