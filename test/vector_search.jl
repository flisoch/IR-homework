### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 3eb7816a-92e9-11eb-2394-d326ed6a5bb2
using Test

# ╔═╡ 2be27ea4-92ea-11eb-25b9-45b02ee0a935
using TextAnalysis

# ╔═╡ cb9b9902-9327-11eb-05ab-07f6c6ecdb8e
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

# ╔═╡ d921102a-9327-11eb-120d-5febd1acab0f
TfIdf = ingredients("../src/tf_idf.jl")

# ╔═╡ dd730764-92e9-11eb-3f4d-41c014719785
# doc1 = StringDocument("new york times")

# ╔═╡ e46ce0b4-92e9-11eb-06eb-83d1557cd320
# doc2 = StringDocument("new york post")

# ╔═╡ ea9d551a-92e9-11eb-2afb-0b4afee0bcd7
# doc3 = StringDocument("los angeles times")

# ╔═╡ ef536c3c-92e9-11eb-3c4b-e764fb13bdac
# corpus = Corpus([doc1, doc2, doc3])

# ╔═╡ 303ac7bc-92eb-11eb-3d2b-a1d7f6802808
# update_lexicon!(corpus)

# ╔═╡ 73e4ed22-92ea-11eb-036f-75454739dbc5
# update_inverse_index!(corpus)

# ╔═╡ 99e899c6-92ea-11eb-119a-873a4900bfd9
# function corpusidf(crps, invidx)
# 	idfdict = Dict()
# 	lexicon = crps.lexicon
# 	for (word, count) in lexicon
# 		docsmatchcount = length(invidx[word])
# 		@show word
# 		@show count
# 		@show docsmatchcount
# 		idf = log2(length(crps)/docsmatchcount)
# 		idfdict[word] = idf
# 	end
# 	idfdict
# end

# ╔═╡ 7dee0f9c-92ea-11eb-05d9-bf6e65b2a4b0
# inverseindex = inverse_index(corpus)

# ╔═╡ a1377530-92ea-11eb-0e39-f1f455d70f49
# corpusidf(corpus, inverseindex)

# ╔═╡ 74c80dba-92e9-11eb-19be-3197d590998d
# @testset "idf test" begin
# 	doc1 = StringDocument("new york times")
# 	doc2 = StringDocument("new york post")
# 	doc3 = StringDocument("los angeles times")
# 	corpus = Corpus([doc1, doc2, doc3])
# 	update_lexicon!(corpus)
# 	update_inverse_index!(corpus)
	
# 	function corpusidf(crps, invidx)
# 		idfdict = Dict()
# 		lexicon = crps.lexicon
# 		for (word, count) in lexicon
# 			docsmatchcount = length(invidx[word])
# 			@show word
# 			@show count
# 			@show docsmatchcount
# 			idf = log2(length(crps)/docsmatchcount)
# 			idfdict[word] = idf
# 		end
# 		idfdict
# 	end
	
# 	inverseindex = inverse_index(corpus)
# 	corpusidf(corpus, inverseindex)
	
	
# 	correct = Dict()
# 	correct["new"] = 0.584
# 	correct["los"] = 1.584
# 	correct["angeles"] = 1.584
# 	correct["post"] = 1.584
# 	correct["times"] = 0.584
# 	correct["york"] = 0.584	
	
# 	@test corpusidf(corpus)["new"] == correct["new"]
# 	@test correct isa Dict
# end

# ╔═╡ f773a72c-92ee-11eb-1f4b-d56b2d9e2489


# ╔═╡ 204df738-92ef-11eb-1105-553881d6aaf9
@testset "vector search test" begin
	doc1 = StringDocument("new york times")
	doc2 = StringDocument("new york post")
	doc3 = StringDocument("los angeles times")
	corpus = Corpus([doc1, doc2, doc3])
	update_lexicon!(corpus)
	update_inverse_index!(corpus)

	inverseindex = inverse_index(corpus)
	idfs = TfIdf.corpusidf(corpus, inverseindex)
	tfs = TfIdf.corpustfs(corpus)
	tfidfs = TfIdf.corpustfidf(corpus, tfs, idfs)
	
	@testset "idf test" begin
		correct = Dict()
		correct["angeles"] = 1.584
		correct["los"] = 1.584
		correct["new"] = 0.584
		correct["post"] = 1.584
		correct["times"] = 0.584
		correct["york"] = 0.584	

		for (key, value) in idfs
			@test correct[key] == round(value, digits=3, RoundDown)
		end
	end
	
	
	@testset "tf test" begin
		correct = [
			Dict("angeles"=>0, "los"=>0, "new"=>1, "post"=>0, "times"=>1, "york"=>1), 
			Dict("angeles"=>0, "los"=>0, "new"=>1, "post"=>1, "times"=>0, "york"=>1), 
			Dict("angeles"=>1, "los"=>1, "new"=>0, "post"=>0, "times"=>1, "york"=>0),
		]
		
		for i = 1:length(correct)
			@test correct[i] isa Dict
			@test tfs[i] isa Dict
			@test isequal(correct[i], tfs[i])
		end	
	end
	
	@testset "tf_idf test" begin
		correct = [
			Dict("angeles"=>0, "los"=>0, "new"=>0.584, "post"=>0, "times"=>0.584, "york"=>0.584), 
			Dict("angeles"=>0, "los"=>0, "new"=>0.584, "post"=>1.584, "times"=>0, "york"=>0.584), 
			Dict("angeles"=>1.584, "los"=>1.584, "new"=>0, "post"=>0, "times"=>0.584, "york"=>0),
		]
		
		for i = 1:length(correct)
			@test correct[i] isa Dict
			@test tfidfs[i] isa Dict
			# @test isequal(correct[i], tfidfs[i])
			for (key, value) in tfidfs[i]
				@test correct[i][key] == round(value, digits=3, RoundDown)
			end
		end	
	end
	
	@testset "cosine similarity test" begin
		query = "new new times"
	
		dcossim_expected = [0.77, 0.29, 0.11]
		d1cossim_expected = 0.77
		d2cossim_expected = 0.29
		d3cossim_expected = 0.11
		query_tfidf = Dict("angeles"=>0, "los"=>0, "new"=>0.584, "post"=>0, "times"=>0.292, "york"=>0)
		
		function cossim(doc_tfidf, query_tfidf)
			@test doc_tfidf isa Dict
			@test query_tfidf isa Dict
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
		
		
		for i = 1:length(tfidfs)
			dcossim_actual = cossim(tfidfs[i], query_tfidf)		
			@test round(dcossim_actual, digits=2, RoundDown) == dcossim_expected[i]
		end
	end
	
	
end

# ╔═╡ 1ccd309a-92f3-11eb-3c61-9d327ca0aae3
corpus1 = Corpus([StringDocument("sdf"), StringDocument("sdf, qwer"), StringDocument("sdf")])

# ╔═╡ 5c0854b8-92f3-11eb-0be1-49da274393e6
function tfDict1(doclexicon)
	tfDict = Dict()
	doclexicon.count
	for (word, count) in doclexicon
		tfDict[word] = count / doclexicon.count
	end
	tfDict
end

# ╔═╡ f7dbd0bc-92f1-11eb-01f5-a3d915a01990
function corpustfs1(crps)
		tfs = []
		for stringdocument in crps
			corpus1 = Corpus([stringdocument])
			update_lexicon!(corpus1)
			push!(tfs, tfDict1(corpus1.lexicon))
		end
		tfs
	end

# ╔═╡ 33c281a6-92f3-11eb-3084-ad43a9b9f718
corpustfs1(corpus1)

# ╔═╡ 64fce530-92f4-11eb-28aa-ade061004c5a
a = Dict("angeles"=>0, "los"=>0, "new"=>1, "post"=>0, "times"=>1, "york"=>1)

# ╔═╡ 882bc6c4-92f5-11eb-0593-576b01e9c098
tfidf3.tf

# ╔═╡ Cell order:
# ╠═3eb7816a-92e9-11eb-2394-d326ed6a5bb2
# ╠═2be27ea4-92ea-11eb-25b9-45b02ee0a935
# ╠═cb9b9902-9327-11eb-05ab-07f6c6ecdb8e
# ╠═d921102a-9327-11eb-120d-5febd1acab0f
# ╠═dd730764-92e9-11eb-3f4d-41c014719785
# ╠═e46ce0b4-92e9-11eb-06eb-83d1557cd320
# ╠═ea9d551a-92e9-11eb-2afb-0b4afee0bcd7
# ╠═ef536c3c-92e9-11eb-3c4b-e764fb13bdac
# ╠═303ac7bc-92eb-11eb-3d2b-a1d7f6802808
# ╠═73e4ed22-92ea-11eb-036f-75454739dbc5
# ╠═99e899c6-92ea-11eb-119a-873a4900bfd9
# ╠═7dee0f9c-92ea-11eb-05d9-bf6e65b2a4b0
# ╠═a1377530-92ea-11eb-0e39-f1f455d70f49
# ╠═74c80dba-92e9-11eb-19be-3197d590998d
# ╠═f773a72c-92ee-11eb-1f4b-d56b2d9e2489
# ╠═204df738-92ef-11eb-1105-553881d6aaf9
# ╠═f7dbd0bc-92f1-11eb-01f5-a3d915a01990
# ╠═1ccd309a-92f3-11eb-3c61-9d327ca0aae3
# ╠═5c0854b8-92f3-11eb-0be1-49da274393e6
# ╠═33c281a6-92f3-11eb-3084-ad43a9b9f718
# ╠═64fce530-92f4-11eb-28aa-ade061004c5a
# ╠═882bc6c4-92f5-11eb-0593-576b01e9c098
