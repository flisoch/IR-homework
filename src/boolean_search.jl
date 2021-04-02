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
corpus.lexicon["gautama"]

# ╔═╡ f368dac6-2ced-4077-ae57-10576264eac2
invidx = InverseIndex.saved_inverseindex()

# ╔═╡ 7f3a0391-2010-421f-a20c-76e3ecacf92a
function withoutsecond(list1, list2)
	both = unique([list1; list2])
	findall(x -> (x in list1) && !(x in list2), both)
end

# ╔═╡ e08f1917-b5ad-4dd1-85cb-c47eff10e5ff
function bothwords(invidx, word1, word2)
	list1 = invidx[word1]
	list2 = invidx[word2]
	intersect(list1, list2)
end

# ╔═╡ e4ddb8af-4143-448f-9973-eaf9de669cbc
function anyword(invidx, word1, word2)
	list1 = invidx[word1]
	list2 = invidx[word2]
	unique([list1; list2])
end

# ╔═╡ 683c4ac4-95b1-4276-8c83-dddbd5e6c141
function booleansearch(invidx, word1, word2, command)
	if command == "AND"
		bothwords(invidx, word1, word2)
	elseif command == "OR"
		anyword(invidx, word1, word2)
	elseif command == "NOT"
		withoutsecond(invidx, word1, word2)
	else 
		[]
	end
end

# ╔═╡ c28d26c9-c18f-41cd-9286-035ab0f7f56b
query = "belief AND god NOT gautama AND buddha"

# ╔═╡ 8702638f-ab5c-4e45-87f0-7795dfb45476
s = split(query)

# ╔═╡ 334ffc1c-4992-4306-9c78-ddde65ae542b
function booleansearch(invidx, query)
	s = split(query)
	result = invidx[s[1]]
		
	for i = 2:length(s)
		@show i
		@show s[i]
		if (i != length(s))
			nextword = s[i+1]
			if s[i] == "AND"
				result = intersect(result, invidx[nextword])
			elseif s[i] == "OR"
				result = unique([result; invidx[nextword]])
			elseif s[i] == "NOT"
				result = withoutsecond(result, invidx[nextword])
			end
		end
	end
	result
end

# ╔═╡ 196c68e1-0fbe-4858-9fac-e1851e51f756
booleansearch(invidx, query)

# ╔═╡ 7a3fb5c4-19b9-4820-8561-32ad73014e5c
ands = findall(x -> x=="AND", s)

# ╔═╡ e58b75c2-6ab6-4f2c-bab8-caccded8d1fa
ors = findall(x -> x=="OR", s)

# ╔═╡ 9950203f-56e0-4120-a907-182041cdf4a0
nots = findall(x -> x=="NOT", s)

# ╔═╡ 43ac6ee9-d3a9-45a5-ac78-e8345b7d88e4
ands_stack = Stack{Int}()

# ╔═╡ 4971b8d8-78d9-4f4a-ad51-1d789cd454eb
ors_stack = Stack{Int}()

# ╔═╡ 0953e184-f245-4061-97ea-eb22db501bd4
nots_stack = Stack{Int}()

# ╔═╡ a874e867-f05e-4b92-bfd2-f2ce54e7e326
queue = Queue{Stack}()

# ╔═╡ fbadb8f4-d763-4b74-a4de-a5d80af7fc86
begin 
	for index in ands
		push!(ands_stack, index)
	end

	for index in ors
		push!(ors_stack, index)
	end
	
	for index in nots
		push!(nots_stack, index)
	end
	
	enqueue!(queue, ands_stack)
	enqueue!(queue, ors_stack)
	enqueue!(queue, nots_stack)
end

# ╔═╡ f390659f-5732-4cb8-8293-297b0aa0166b
used = [] 

# ╔═╡ 7301aa3f-db2f-49a4-aa4b-9a20d9e58b0e
isempty(queue)

# ╔═╡ 77669d0b-bb76-42d8-97da-9ddb87302562
totalqueue = Queue{Array}()

# ╔═╡ 002fb40a-460c-46ee-b490-1e77a22dacc6
while !isempty(queue)
	stack = dequeue!(queue)
	while !isempty(stack)
		idx = pop!(stack)
		if !(idx - 1 in used)
			word = s[idx-1]
			result1 = invidx[word]
		end
		push!(used, idx - 1)
		push!(used, idx)
		push!(used, idx + 1)
	end
end

# ╔═╡ Cell order:
# ╠═b985c3a2-bdee-4d23-9de7-fa5e56670153
# ╠═5f6091d0-932d-11eb-1ff2-81e7f2a1a69a
# ╠═d4dca4f0-09fb-47db-a6bd-f32f275d32e8
# ╠═33c22acb-5b4d-4fd7-bbb7-7ec13ed1bad7
# ╠═40f7ff8c-3d9d-4f50-accc-34b0db05652c
# ╠═f368dac6-2ced-4077-ae57-10576264eac2
# ╠═683c4ac4-95b1-4276-8c83-dddbd5e6c141
# ╠═7f3a0391-2010-421f-a20c-76e3ecacf92a
# ╠═e08f1917-b5ad-4dd1-85cb-c47eff10e5ff
# ╠═e4ddb8af-4143-448f-9973-eaf9de669cbc
# ╠═c28d26c9-c18f-41cd-9286-035ab0f7f56b
# ╠═8702638f-ab5c-4e45-87f0-7795dfb45476
# ╠═334ffc1c-4992-4306-9c78-ddde65ae542b
# ╠═196c68e1-0fbe-4858-9fac-e1851e51f756
# ╠═7a3fb5c4-19b9-4820-8561-32ad73014e5c
# ╠═e58b75c2-6ab6-4f2c-bab8-caccded8d1fa
# ╠═9950203f-56e0-4120-a907-182041cdf4a0
# ╠═43ac6ee9-d3a9-45a5-ac78-e8345b7d88e4
# ╠═4971b8d8-78d9-4f4a-ad51-1d789cd454eb
# ╠═0953e184-f245-4061-97ea-eb22db501bd4
# ╠═fbadb8f4-d763-4b74-a4de-a5d80af7fc86
# ╠═a874e867-f05e-4b92-bfd2-f2ce54e7e326
# ╠═f390659f-5732-4cb8-8293-297b0aa0166b
# ╠═7301aa3f-db2f-49a4-aa4b-9a20d9e58b0e
# ╠═77669d0b-bb76-42d8-97da-9ddb87302562
# ╠═002fb40a-460c-46ee-b490-1e77a22dacc6
