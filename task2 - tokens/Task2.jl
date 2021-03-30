### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7f2dc1b0-90ce-11eb-376e-23dc70b084d7
using TextAnalysis

# ╔═╡ ed998a78-90e3-11eb-146e-e306f16e9324
using PyCall

# ╔═╡ d20baaa4-90e6-11eb-0c52-efd4ef31eb3a
nltk = pyimport("nltk")

# ╔═╡ dd49e354-90e6-11eb-3da6-e7ecb9546a09
nltk.download("wordnet")

# ╔═╡ 11f62a70-90e9-11eb-097c-e961328a301f
nltk.download("averaged_perceptron_tagger")

# ╔═╡ c3e5b98c-90ec-11eb-037b-916fa2b4efbc
 lemmatizer = nltk.WordNetLemmatizer()

# ╔═╡ 8143c738-90d1-11eb-0190-f3e6f96d6f3a
filescount = 7

# ╔═╡ f09ab678-90d1-11eb-0fba-d97f606b0175
function readfile(index)
	filename = "/home/flisoch//Desktop/searchJl/task1 - javaCrawler/target/resources/files/" * string(index) * ".txt"
	io = open(filename)
	text = readline(io)
	close(io)
	text
end

# ╔═╡ 4407e45c-90eb-11eb-0b33-e31905acc15a
function pos_tagger(nltk_tag)
    if startswith(nltk_tag, 'J')
        nltk.corpus.wordnet.ADJ
	elseif startswith(nltk_tag, 'V')
        nltk.corpus.wordnet.VERB
	elseif startswith(nltk_tag, 'N')
        nltk.corpus.wordnet.NOUN
	elseif startswith(nltk_tag, 'R')
        nltk.corpus.wordnet.ADV
    else          
        nothing
	end
end

# ╔═╡ a246427a-90eb-11eb-2e5d-2b129ee07adf


# ╔═╡ f2d680c4-90e1-11eb-3c9c-21588d3f7c66
function savewords(words)
	io = open("words.txt", "a+")
	io1 = open("lemmas.txt", "a+")
	for word in words
		write(io, word * "\n")
		# write(io1, word * " " * lemma * "\n")
	end
	close(io)
	close(io1)
end

# ╔═╡ 840a26d8-90ef-11eb-3373-918c3654e4f1
function savelemmas(words, lemmas)
	io = open("words.txt", "a+")
	io1 = open("lemmas.txt", "a+")
	for i = 1:length(words)
		write(io, words[i] * "\n")
		write(io1, words[i] * " " * lemmas[i] * "\n")
	end
	close(io)
	close(io1)
end

# ╔═╡ 316940f4-90ee-11eb-33d9-d52dae65f2bc
function getlemmas(taggedwords)
	lemmas = []
	for taggedword in taggedwords
		tag = pos_tagger(taggedword[2])
		if tag == nothing
			push!(lemmas, taggedword[1])
		else
			push!(lemmas, lemmatizer.lemmatize(taggedword[1], tag))
		end
	end
	lemmas
end

# ╔═╡ 8a5ac0a8-90d2-11eb-2bb0-75be8cce5a3b
for i = 0:filescount
	text = readfile(i)
	sd1 = StringDocument(text)
	prepare!(sd1, strip_punctuation| strip_non_letters| strip_articles)
	remove_case!(sd1)
	words = tokens(sd1)
	taggedwords = nltk.pos_tag(words)
	lemmas = getlemmas(taggedwords)
	savewords(words)
	savelemmas(words, lemmas)
end

# ╔═╡ 79949dbc-90f1-11eb-1bcc-df4ba3ee7542


# ╔═╡ Cell order:
# ╠═7f2dc1b0-90ce-11eb-376e-23dc70b084d7
# ╠═ed998a78-90e3-11eb-146e-e306f16e9324
# ╠═d20baaa4-90e6-11eb-0c52-efd4ef31eb3a
# ╠═dd49e354-90e6-11eb-3da6-e7ecb9546a09
# ╠═11f62a70-90e9-11eb-097c-e961328a301f
# ╠═c3e5b98c-90ec-11eb-037b-916fa2b4efbc
# ╠═8143c738-90d1-11eb-0190-f3e6f96d6f3a
# ╠═f09ab678-90d1-11eb-0fba-d97f606b0175
# ╠═4407e45c-90eb-11eb-0b33-e31905acc15a
# ╠═a246427a-90eb-11eb-2e5d-2b129ee07adf
# ╠═f2d680c4-90e1-11eb-3c9c-21588d3f7c66
# ╠═840a26d8-90ef-11eb-3373-918c3654e4f1
# ╠═316940f4-90ee-11eb-33d9-d52dae65f2bc
# ╠═8a5ac0a8-90d2-11eb-2bb0-75be8cce5a3b
# ╠═79949dbc-90f1-11eb-1bcc-df4ba3ee7542
