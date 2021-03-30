### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 24b0d61a-916e-11eb-199e-7bb722e57bf2
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

# ╔═╡ 7c8af730-916b-11eb-329d-17cd114675d3
task2 = ingredients("../task2 - tokens/Task2.jl")

# ╔═╡ ccdb279e-9140-11eb-3d8b-bd419f3c6d41
sds = []

# ╔═╡ c5624a56-9140-11eb-38dd-033c51745656
filescount = 10

# ╔═╡ 9f047860-913f-11eb-12eb-e9134d976b91
for i = 0:filescount
	text = task2.readfile(i)
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

# ╔═╡ c72ff30c-916f-11eb-239a-7162f4820ad9
# Task4

# ╔═╡ 83eaa4dc-9171-11eb-32d2-4b6ea4a95dc7
function tfDict(doclexicon)
	tfDict = Dict()
	doclexicon.count
	for (word, count) in doclexicon
		tfDict[word] = count / doclexicon.count
	end
	tfDict
end

# ╔═╡ fea8e130-9170-11eb-0a92-8fbec55ff9b4
crps1 = Corpus([StringDocument(text(crps[1]))])

# ╔═╡ 4fd3851c-9171-11eb-276b-33281d411ab0
update_lexicon!(crps1)

# ╔═╡ 75a36b86-9171-11eb-228c-319c5ff28fe1
tfDict(crps1.lexicon)

# ╔═╡ e3d8e25c-9171-11eb-14c7-31759386a2a2
n = length(crps)

# ╔═╡ 363e366c-9179-11eb-3696-254e10b7ebc5
function corpustfs(crps)
	tfs = []
	for stringdocument in crps
		corpus1 = Corpus([stringdocument])
		update_lexicon!(corpus1)
		push!(tfs, tfDict(corpus1.lexicon))
	end
	tfs
end

# ╔═╡ f4d44314-9179-11eb-05e6-6bc7292d86b9
function corpusidf(crps, invidx)
	idfdict = Dict()
	lexicon = crps.lexicon
	for (word, count) in lexicon
		docsmatchcount = length(invidx[word])
		idf = log(count/docsmatchcount)
		idfdict[word] = idf
	end
	idfdict
end

# ╔═╡ e7fde0e2-917d-11eb-1ab6-0bb572387144
function corpustfidf(crps, tfs, idf)
	tfidfs = []
	for i = 1: length(crps)
		# corpus1 = Corpus([crps[i])
		doctfdict = tfs[i]
		# update_lexicon!(corpus1)
		# lexicon = corpus1.lexicon
		doctfidfdict = Dict()
		for (word, tfvalue) in doctfdict
			tfidf = tfvalue * idf[word]
			doctfidfdict[word] = tfidf
		end
		push!(tfidfs, doctfidfdict)
	end
	tfidfs
end

# ╔═╡ 21e355e6-9179-11eb-351c-1314596be039
tfs = corpustfs(crps)

# ╔═╡ 33fd00ea-9179-11eb-1077-53cdac8e42e2
idf = corpusidf(crps, invidx)

# ╔═╡ a5d4e154-917b-11eb-0bbe-cbc399c0a83e
tfidf = corpustfidf(crps, tfs, idf) 

# ╔═╡ 2719c00a-9180-11eb-10bd-03f314316696
function save_idf_tfidf(idfs, tfidfs)
	io = open("tfidf_idf.txt", "a+")
	for tfidf in tfidfs
		write(io, "{\n")
		for (word, value) in tfidf
			write(io, word * " " * string(idfs[word]) * " " * string(value) * "\n")
		end
		write(io, "},\n")
	end
	close(io)
end

# ╔═╡ c34205f2-917e-11eb-371c-c9fcb0ee8ae0
save_idf_tfidf(idf, tfidf)

# ╔═╡ 1daecb18-9181-11eb-0226-6f4a3a1a936f


# ╔═╡ Cell order:
# ╠═9170c1a6-913f-11eb-0d5e-41f097fd770f
# ╠═f70b8200-914c-11eb-1e9e-f31b3927d722
# ╠═24b0d61a-916e-11eb-199e-7bb722e57bf2
# ╠═7c8af730-916b-11eb-329d-17cd114675d3
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
# ╠═c72ff30c-916f-11eb-239a-7162f4820ad9
# ╠═83eaa4dc-9171-11eb-32d2-4b6ea4a95dc7
# ╠═fea8e130-9170-11eb-0a92-8fbec55ff9b4
# ╠═4fd3851c-9171-11eb-276b-33281d411ab0
# ╠═75a36b86-9171-11eb-228c-319c5ff28fe1
# ╠═e3d8e25c-9171-11eb-14c7-31759386a2a2
# ╠═363e366c-9179-11eb-3696-254e10b7ebc5
# ╠═f4d44314-9179-11eb-05e6-6bc7292d86b9
# ╠═e7fde0e2-917d-11eb-1ab6-0bb572387144
# ╠═21e355e6-9179-11eb-351c-1314596be039
# ╠═33fd00ea-9179-11eb-1077-53cdac8e42e2
# ╠═a5d4e154-917b-11eb-0bbe-cbc399c0a83e
# ╠═2719c00a-9180-11eb-10bd-03f314316696
# ╠═c34205f2-917e-11eb-371c-c9fcb0ee8ae0
# ╠═1daecb18-9181-11eb-0226-6f4a3a1a936f
