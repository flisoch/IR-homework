### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 3eadb1e8-9326-11eb-046b-9b64278a7052
using TextAnalysis

# ╔═╡ f165a2dc-9326-11eb-0d42-9176c9592d15
function tf(doclexicon, crpslexicon)
	if !(doclexicon isa Dict)
		error("Passed variable doclexicon(bag of words) of document is not a Dict type")
	end
	if !(crpslexicon isa Dict)
		error("Passed variable crpslexicon(bag of words) is not a Dict type")
	end
	
	tf_dict = Dict()
	doclexicon.count
	for (word, count) in crpslexicon

		if haskey(doclexicon, word)
			tf_dict[word] = doclexicon[word] # /crpslexicon.len to normalize
		else
			tf_dict[word] = 0
		end
	end
	tf_dict
end

# ╔═╡ 24b2999c-9327-11eb-2cc8-59b82fe0c86b
function corpustfs(crps)
	if !(crps isa Corpus)
		error("Passed variable crps(Corpus of documents) is not a Corpus type")
	end
	tfs = []
	for stringdocument in crps
		corpus1 = Corpus([stringdocument])
		update_lexicon!(corpus1)
		push!(tfs, tf(corpus1.lexicon, crps.lexicon))
	end
	tfs
end

# ╔═╡ 53d04762-9327-11eb-2946-add9ce93f589
function corpusidf(crps, invidx)
	if !(crps isa Corpus)
	error("Passed variable  crps(Corpus of documents) is not a Corpus type")
	end
	if !(invidx isa Dict)
		error("Passed variable invidx(Inverted Index) is not a Dict type")
	end
	
	idfdict = Dict()
	lexicon = crps.lexicon
	for (word, count) in lexicon
		docsmatchcount = length(invidx[word])
		idf = log2(length(crps)/docsmatchcount)
		idfdict[word] = idf
	end
	idfdict
end

# ╔═╡ 6dbc018c-9327-11eb-07fc-41efc2473885
function tfidf(doc_tf, idf)
	if !(doc_tf isa Dict)
		error("Passed tf of document is not a Dict")
	end
	if !(doc_tf isa Dict)
		error("Passed idf is not a Dict")
	end
	
	doc_tfidf = Dict()
	for (word, tf) in doc_tf
		tfidf_value = tf * idf[word]
		doc_tfidf[word] = tfidf_value
	end
	doc_tfidf
end

# ╔═╡ 739f8240-9327-11eb-02e2-b14c15fab4f0
function corpustfidf(crps, tfs, idf)
	if !(crps isa Corpus)
		error("Passed variable  crps(Corpus of documents) is not a Corpus type")
	end
	if !(tfs isa Array)
		error("Passed variable tfs is not an Array type")
	end
	if !(idf isa Dict)
		error("Passed variable idf is not a Dict type")
	end
	
	tfidfs = []
	for i = 1: length(crps)
		doc_tf = tfs[i]
		doc_tfidf = tfidf(doc_tf, idf)

		push!(tfidfs, doc_tfidf)
	end
	tfidfs
end

# ╔═╡ 6ce3509e-9327-11eb-10fd-ab1a8f23512d


# ╔═╡ Cell order:
# ╠═3eadb1e8-9326-11eb-046b-9b64278a7052
# ╠═f165a2dc-9326-11eb-0d42-9176c9592d15
# ╠═24b2999c-9327-11eb-2cc8-59b82fe0c86b
# ╠═53d04762-9327-11eb-2946-add9ce93f589
# ╠═6dbc018c-9327-11eb-07fc-41efc2473885
# ╠═739f8240-9327-11eb-02e2-b14c15fab4f0
# ╠═6ce3509e-9327-11eb-10fd-ab1a8f23512d
