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

# ╔═╡ 79c98301-c35c-47e2-abb8-ce606b95ed21
function ranks(texts_id, crps_tfidf, query_tfidf)
	results = Dict()
	for textid in texts_id
		cos_sim = cossim(crps_tfidf[textid], query_tfidf)
		results[textid] = cos_sim 
	end
	rank = sort(collect(results), by=x->x[2], rev=true)
	rank
end

# ╔═╡ 92bbfbab-4915-40cc-8fd4-9e9c91a51119
function query_tfidf(query, corpus, invidx)
	querycorpus = Corpus([StringDocument(query)])
	update_lexicon!(querycorpus)
	update_lexicon!(corpus)
	query_tf = TfIdf.tf(querycorpus.lexicon, corpus.lexicon)
	idf = TfIdf.corpusidf(corpus, invidx)
	query_tfidf = TfIdf.tfidf(query_tf, idf)
	query_tfidf
end

# ╔═╡ d300c3cd-9f6f-4e0c-a643-1c4a0f4fdbbe
function loadlinks(indeces, path="../data/index.txt")
	links = []
	io = open(path, "r")
	lines = readlines(io)
	for line in lines
		s = split(line, " ")
		index = parse(Int32, s[1])
		link = s[2]
		if index in indeces
			@show link
			@show index
			push!(links, link)
		end
	end
	close(io)
	links
end

# ╔═╡ d373cb44-e598-40ce-b50c-7d0496c712db
struct Searcher
	corpus
	invidx
	crps_tfidf
	
	Searcher(corpus, invidx, crps_tfidf) = new(corpus, invidx, crps_tfidf)
	
	function search(query)
		texts_id = BooleanSearch.booleansearch(invidx, query)
		querytfidf = query_tfidf(query, corpus, invidx)
		rank = ranks(texts_id, crps_tfidf, querytfidf)

		top3 = rank[1:3]
		top3_texts_id = map(x -> x[1], top3)
		loadlinks(top3_texts_id)
	end
end

# ╔═╡ 8e8e4e77-ae7f-4ed3-8c7d-3c043f7fc5f2
begin 
	corpus = InverseIndex.loadtexts([x for x=1:98])
	invidx = InverseIndex.saved_inverseindex()
	crps_tfidf = TfIdf.corpustfidf(corpus)
end

# ╔═╡ b157816f-e27c-4ef8-8ee0-0a1fe79c5a23
searcher = Searcher(corpus, invidx, crps_tfidf)

# ╔═╡ 42940544-4007-4241-bac1-8080e198e264
function search(query, searcher)
	corpus = searcher.corpus
	invidx = searcher.invidx
	crps_tfidf = searcher.crps_tfidf
	
	texts_id = BooleanSearch.booleansearch(invidx, query)
	querytfidf = query_tfidf(query, corpus, invidx)
	rank = ranks(texts_id, crps_tfidf, querytfidf)
	
	top3 = rank[1:3]
	top3_texts_id = map(x -> x[1], top3)
	loadlinks(top3_texts_id)
end

# ╔═╡ 6310aab3-5610-4182-a5fa-b5fb61896c80


# ╔═╡ b12fbb52-58a7-45f0-90d7-63f319291a8b
# @bind query TextField()

# ╔═╡ 36ad431a-b1df-46b6-8c82-6aaa29b9ec86
query = "history religion"

# ╔═╡ 15fe5d49-cedb-49b9-bb90-b630096b6019
search(query, searcher)

# ╔═╡ Cell order:
# ╠═02d140f4-9585-4699-b306-d99c63451afc
# ╠═43cb151c-b7c5-464c-9a70-7af62c9c9f02
# ╠═b6ab3fe0-688d-4c26-800d-a0beaea7ad58
# ╠═08f4187c-55b1-44c2-b467-b7f08b2506fa
# ╠═e2d0a89d-e7a7-4202-951c-a3dceab940ad
# ╠═00cf7f2c-3904-4658-ae4a-5d3bfa8a9cac
# ╠═cc606c37-ea00-40ea-affa-b4b3e39c2e6a
# ╠═79c98301-c35c-47e2-abb8-ce606b95ed21
# ╠═92bbfbab-4915-40cc-8fd4-9e9c91a51119
# ╠═d300c3cd-9f6f-4e0c-a643-1c4a0f4fdbbe
# ╠═d373cb44-e598-40ce-b50c-7d0496c712db
# ╠═8e8e4e77-ae7f-4ed3-8c7d-3c043f7fc5f2
# ╠═b157816f-e27c-4ef8-8ee0-0a1fe79c5a23
# ╠═42940544-4007-4241-bac1-8080e198e264
# ╠═6310aab3-5610-4182-a5fa-b5fb61896c80
# ╠═b12fbb52-58a7-45f0-90d7-63f319291a8b
# ╠═36ad431a-b1df-46b6-8c82-6aaa29b9ec86
# ╠═15fe5d49-cedb-49b9-bb90-b630096b6019
