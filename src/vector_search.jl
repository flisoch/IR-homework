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

# ╔═╡ c5183202-7fe2-40a4-adf6-d1972a4714de
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
			push!(links, link * " " * string(index))
		end
	end
	close(io)
	links
end

# ╔═╡ ff401a32-b9d6-4da1-89ff-db8312601ae4
function remove_bool(query)
	cleanquery = ""
	for word in query
		if word != "AND" && word != "OR" && word != "NOT"
			cleanquery = cleanquery * word * " "
		end
	end
	chop(cleanquery)
end

# ╔═╡ d373cb44-e598-40ce-b50c-7d0496c712db
struct Searcher
	corpus
	invidx
	crps_tfidf

	Searcher(corpus, invidx, crps_tfidf) = new(corpus, invidx, crps_tfidf)
	
	function search(query)
		texts_id = BooleanSearch.booleansearch(invidx, query)
		querytfidf = query_tfidf(remove_bool(query), corpus, invidx)
		rank = ranks(texts_id, crps_tfidf, querytfidf)

		top3 = rank[1:3]
		top3_texts_id = map(x -> x[1], top3)
		loadlinks(top3_texts_id)
	end
end

# ╔═╡ ec19ea2a-6d08-421a-96f1-38f2e92d44aa
function searcher()
	corpus = InverseIndex.loadtexts([x for x=1:99])
	invidx = InverseIndex.inverseindex(corpus)
	crps_tfidf = TfIdf.corpustfidf(corpus)
	searcher1 = Searcher(corpus, invidx, crps_tfidf)
	searcher1
end

# ╔═╡ 42940544-4007-4241-bac1-8080e198e264
function search(query, searcher)
	corpus = searcher.corpus
	invidx = searcher.invidx
	crps_tfidf = searcher.crps_tfidf
	querytfidf = query_tfidf(remove_bool(query), corpus, invidx)
	
	texts_id = BooleanSearch.booleansearch(invidx, query)
	rank = ranks(texts_id, crps_tfidf, querytfidf)
	
	maxresults = length(rank)
	if maxresults < 5
		top = rank[1:maxresults]
	else
		top = rank[1:5]
	end
	@show top
	top_texts_id = map(x -> x[1], top)
	loadlinks(top_texts_id)
end

# ╔═╡ b12fbb52-58a7-45f0-90d7-63f319291a8b
# @bind query TextField()

# ╔═╡ Cell order:
# ╠═c5183202-7fe2-40a4-adf6-d1972a4714de
# ╟─b6ab3fe0-688d-4c26-800d-a0beaea7ad58
# ╠═08f4187c-55b1-44c2-b467-b7f08b2506fa
# ╠═e2d0a89d-e7a7-4202-951c-a3dceab940ad
# ╠═00cf7f2c-3904-4658-ae4a-5d3bfa8a9cac
# ╠═cc606c37-ea00-40ea-affa-b4b3e39c2e6a
# ╠═79c98301-c35c-47e2-abb8-ce606b95ed21
# ╠═92bbfbab-4915-40cc-8fd4-9e9c91a51119
# ╠═d300c3cd-9f6f-4e0c-a643-1c4a0f4fdbbe
# ╠═ff401a32-b9d6-4da1-89ff-db8312601ae4
# ╠═d373cb44-e598-40ce-b50c-7d0496c712db
# ╠═ec19ea2a-6d08-421a-96f1-38f2e92d44aa
# ╠═42940544-4007-4241-bac1-8080e198e264
# ╟─b12fbb52-58a7-45f0-90d7-63f319291a8b
