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

# ╔═╡ 43cb151c-b7c5-464c-9a70-7af62c9c9f02
using TextAnalysis

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

# ╔═╡ 08f4187c-55b1-44c2-b467-b7f08b2506fa
TfIdf = ingredients("tf_idf.jl")

# ╔═╡ e2d0a89d-e7a7-4202-951c-a3dceab940ad
InverseIndex = ingredients("inverse_index.jl")

# ╔═╡ 00cf7f2c-3904-4658-ae4a-5d3bfa8a9cac
BooleanSearch = ingredients("boolean_search.jl")

# ╔═╡ 2ae193d5-def1-44ab-ba16-4c3418e43e7f
@bind query TextField()

# ╔═╡ e2e3caf4-fe6b-4d82-a4a4-e2f47e427f44
query

# ╔═╡ cc606c37-ea00-40ea-affa-b4b3e39c2e6a
function cossim(doc_tfidf, query_tfidf)
	sum = 0
	doclength = 0
	querylength = 0
	for (word, tfidf) in doc_tfidf
		sum += tfidf * query_tfidf[word]
		doclength += tfidf * tfidf
		querylength += query_tfidf[word] * query_tfidf[word]
	end
	doclength = sqrt(doclength)
	querylength = sqrt(querylength)
	result = sum / (doclength * querylength)
	result

end

# ╔═╡ 7fa4223d-1425-42b6-9870-0b60f090ae78
querycorpus = Corpus([StringDocument(query)])

# ╔═╡ 532982b1-e61b-4925-bfa6-978a3532976f
update_lexicon!(querycorpus)

# ╔═╡ dbacad5f-9572-4508-8468-78168b2d596f
corpus = InverseIndex.loadtexts([x for x=1:98])

# ╔═╡ 572dc393-317a-4e35-96f7-99faf003c7be
update_lexicon!(corpus)

# ╔═╡ a542e28c-600d-4c57-a766-0721f0f38109
query_tf = TfIdf.tf(querycorpus.lexicon, corpus.lexicon)

# ╔═╡ e71f2908-fb04-4443-9560-57ac257d45b2
invidx = InverseIndex.saved_inverseindex()

# ╔═╡ ba4700ca-3963-4b5b-bdb2-d4c1af95d91e
idf = TfIdf.corpusidf(corpus, invidx)

# ╔═╡ 70b67c84-8851-4a2c-b115-0ab973b2a192
query_tfidf = TfIdf.tfidf(query_tf, idf)

# ╔═╡ dc387e35-d994-4be3-ac62-10b9b78c1c76
texts_id = BooleanSearch.booleansearch(invidx, query)

# ╔═╡ 05f6c955-4a1a-4749-8e37-c0a7d7b088d4
InverseIndex.loadtexts(texts_id)

# ╔═╡ b99a8a50-dc53-43cc-8c28-379960a8c773
cprs_tfidf = TfIdf.corpustfidf(corpus)

# ╔═╡ 74ba6add-2f74-429e-8850-201a580044b9
rank = Dict()

# ╔═╡ 37630ef7-503c-4479-ba8c-2bba1f5ebfb9
for textid in texts_id
	cos_sim = cossim(cprs_tfidf[textid], query_tfidf)
	rank[textid] = cos_sim 
end

# ╔═╡ 8495b895-966e-47c3-8636-27d2f76a591d


# ╔═╡ 82a96345-a32a-46ba-89be-d77670f0ccb1
rank

# ╔═╡ 80b4bd89-92ba-4c41-ad5e-0e32cffca8e7
result = sort(collect(rank), by=x->x[2], rev=true)

# ╔═╡ 5a0a0e32-9cd4-45a1-91d3-7e2f50b93c55
top5 = result[1:5]

# ╔═╡ Cell order:
# ╠═02d140f4-9585-4699-b306-d99c63451afc
# ╠═43cb151c-b7c5-464c-9a70-7af62c9c9f02
# ╠═b6ab3fe0-688d-4c26-800d-a0beaea7ad58
# ╠═08f4187c-55b1-44c2-b467-b7f08b2506fa
# ╠═e2d0a89d-e7a7-4202-951c-a3dceab940ad
# ╠═00cf7f2c-3904-4658-ae4a-5d3bfa8a9cac
# ╠═2ae193d5-def1-44ab-ba16-4c3418e43e7f
# ╠═e2e3caf4-fe6b-4d82-a4a4-e2f47e427f44
# ╠═cc606c37-ea00-40ea-affa-b4b3e39c2e6a
# ╠═7fa4223d-1425-42b6-9870-0b60f090ae78
# ╠═532982b1-e61b-4925-bfa6-978a3532976f
# ╠═dbacad5f-9572-4508-8468-78168b2d596f
# ╠═572dc393-317a-4e35-96f7-99faf003c7be
# ╠═a542e28c-600d-4c57-a766-0721f0f38109
# ╠═e71f2908-fb04-4443-9560-57ac257d45b2
# ╠═ba4700ca-3963-4b5b-bdb2-d4c1af95d91e
# ╠═70b67c84-8851-4a2c-b115-0ab973b2a192
# ╠═dc387e35-d994-4be3-ac62-10b9b78c1c76
# ╠═05f6c955-4a1a-4749-8e37-c0a7d7b088d4
# ╠═b99a8a50-dc53-43cc-8c28-379960a8c773
# ╠═74ba6add-2f74-429e-8850-201a580044b9
# ╠═37630ef7-503c-4479-ba8c-2bba1f5ebfb9
# ╠═8495b895-966e-47c3-8636-27d2f76a591d
# ╠═82a96345-a32a-46ba-89be-d77670f0ccb1
# ╠═80b4bd89-92ba-4c41-ad5e-0e32cffca8e7
# ╠═5a0a0e32-9cd4-45a1-91d3-7e2f50b93c55
