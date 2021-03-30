### A Pluto.jl notebook ###
# v0.12.4

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

# ╔═╡ 9170c1a6-913f-11eb-0d5e-41f097fd770f
using TextAnalysis

# ╔═╡ f70b8200-914c-11eb-1e9e-f31b3927d722
using PlutoUI

# ╔═╡ a36cdab6-913f-11eb-3356-c979b7b5c91f
include("task2 - tokens/Task2.jl")

# ╔═╡ ccdb279e-9140-11eb-3d8b-bd419f3c6d41
sds = []

# ╔═╡ c5624a56-9140-11eb-38dd-033c51745656
filescount = 10

# ╔═╡ 9f047860-913f-11eb-12eb-e9134d976b91
for i = 0:filescount
	text = readfile(i)
	sd1 = StringDocument(text)
	prepare!(sd1, strip_punctuation| strip_non_letters| strip_articles| strip_indefinite_articles| strip_prepositions| strip_pronouns| strip_stopwords)
	remove_case!(sd1)
	push!(sds, sd1)

end

# ╔═╡ 2bb42220-9141-11eb-30ef-811d12e92a06
crps = Corpus(sds)

# ╔═╡ 85b85bb0-9141-11eb-0871-d15dc9506e33
update_lexicon!(crps)

# ╔═╡ 86fc3a82-9141-11eb-3a57-bf1cd0aaeb22
lexico = lexicon(crps)

# ╔═╡ ac317b00-9141-11eb-2459-9bd6ff872fe1
update_inverse_index!(crps)

# ╔═╡ a377575a-9141-11eb-10f0-d3b6e743f731
invidx = inverse_index(crps)

# ╔═╡ 86a0a130-9147-11eb-311e-974ce98d39c8
function saveindex(invidx)
	io = open("inverted_index.txt", "a+")
	for (key, value) in invidx
		countstring = " "
		for num in value
			countstring = countstring * string(num) * " "
		end
		write(io, key * countstring * "\n")
	end
	close(io)
end

# ╔═╡ d18d5204-9147-11eb-102d-c1c036f4330d
saveindex(invidx)

# ╔═╡ 639624ce-914e-11eb-3e9f-d97221ea109e
function bothwords(invidx, word1, word2)
	list1 = invidx[word1]
	list2 = invidx[word2]
	intersect(list1, list2)
end

# ╔═╡ 58b4c9ce-914f-11eb-3cbf-99c436e2e293
function withoutsecond(invidx, word1, word2)
	list1 = invidx[word1]
	list2 = invidx[word2]
	both = unique([list1; list2])
	findall(x -> (x in list1) && !(x in list2), both)
end

# ╔═╡ bceedcd6-914f-11eb-3337-954c38a501ae
function anyword(invidx, word1, word2)
	list1 = invidx[word1]
	list2 = invidx[word2]
	unique([list1; list2])
end

# ╔═╡ e122ed88-914d-11eb-0350-212db87d2f94
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

# ╔═╡ b72ac27c-9151-11eb-30c5-bf8ae3348d04
@bind query TextField()

# ╔═╡ c25504f0-9151-11eb-26a7-cba04e3373cc
splitquery = split(query)

# ╔═╡ c5feb540-9151-11eb-018a-0d274c8f6ee2
command = splitquery[2]

# ╔═╡ caf1b090-9151-11eb-10a2-f925d1dae2ba
word1 = splitquery[1]

# ╔═╡ da9373b2-9151-11eb-2def-5b7c5b928240
word2 = splitquery[3]

# ╔═╡ 11f87974-9152-11eb-06dd-2d769e955f27
invidx[word1]

# ╔═╡ 13ba956c-9152-11eb-2fc9-51df80f75015
invidx[word2]

# ╔═╡ 4053ee14-914f-11eb-2780-f75fc25a13b3
booleansearch(invidx, word1, word2, command)

# ╔═╡ 35ef1e42-9151-11eb-0179-8f8afd3e55f8
booleansearch(invidx, word1, word2, "AND")

# ╔═╡ 286d7fec-9152-11eb-33d3-756c2a8f991d
booleansearch(invidx, word1, word2, "OR")

# ╔═╡ Cell order:
# ╠═9170c1a6-913f-11eb-0d5e-41f097fd770f
# ╠═f70b8200-914c-11eb-1e9e-f31b3927d722
# ╠═a36cdab6-913f-11eb-3356-c979b7b5c91f
# ╠═ccdb279e-9140-11eb-3d8b-bd419f3c6d41
# ╠═c5624a56-9140-11eb-38dd-033c51745656
# ╠═9f047860-913f-11eb-12eb-e9134d976b91
# ╠═2bb42220-9141-11eb-30ef-811d12e92a06
# ╠═85b85bb0-9141-11eb-0871-d15dc9506e33
# ╠═86fc3a82-9141-11eb-3a57-bf1cd0aaeb22
# ╠═ac317b00-9141-11eb-2459-9bd6ff872fe1
# ╠═a377575a-9141-11eb-10f0-d3b6e743f731
# ╠═86a0a130-9147-11eb-311e-974ce98d39c8
# ╠═d18d5204-9147-11eb-102d-c1c036f4330d
# ╠═639624ce-914e-11eb-3e9f-d97221ea109e
# ╠═58b4c9ce-914f-11eb-3cbf-99c436e2e293
# ╠═bceedcd6-914f-11eb-3337-954c38a501ae
# ╠═e122ed88-914d-11eb-0350-212db87d2f94
# ╠═b72ac27c-9151-11eb-30c5-bf8ae3348d04
# ╠═c25504f0-9151-11eb-26a7-cba04e3373cc
# ╠═c5feb540-9151-11eb-018a-0d274c8f6ee2
# ╠═caf1b090-9151-11eb-10a2-f925d1dae2ba
# ╠═da9373b2-9151-11eb-2def-5b7c5b928240
# ╠═11f87974-9152-11eb-06dd-2d769e955f27
# ╠═13ba956c-9152-11eb-2fc9-51df80f75015
# ╠═4053ee14-914f-11eb-2780-f75fc25a13b3
# ╠═35ef1e42-9151-11eb-0179-8f8afd3e55f8
# ╠═286d7fec-9152-11eb-33d3-756c2a8f991d
