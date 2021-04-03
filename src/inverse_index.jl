### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 7c8adb4b-7039-48b7-81a5-21bcd63984fb
using TextAnalysis

# ╔═╡ 78387644-932d-11eb-33e1-47040dd4d2e4
function loadtexts(indices, path="../data/texts/")
	texts = []
	for i = 1:length(indices)
		filepath = path * string(indices[i]) * ".txt"
		if isfile(filepath)
			@show filepath
			io = open(filepath, "r")
			text = readline(io)
			
			sd1 = StringDocument(text)
			prepare!(sd1, strip_punctuation| strip_non_letters| strip_articles| strip_indefinite_articles| strip_prepositions| strip_pronouns| strip_stopwords)
			remove_case!(sd1)
			
			push!(texts, sd1)
			close(io)
		end
	end
	Corpus(texts)
end
			

# ╔═╡ a7f3db01-1759-45f2-abf2-de2e78196811
function inverseindex(corpus)
	update_lexicon!(corpus)
	update_inverse_index!(corpus)
	inverse_index(corpus)
end

# ╔═╡ 51297f05-60db-4091-99b8-273acaa8b85a
function saved_inverseindex(path = "../data/inverted_index.txt")
	invidx = Dict()
	io = open(path, "r")
	lines = readlines(io)
	for line in lines
		s = split(line, " ")
		word = s[1]
		nums = []
		@show line
		@show word
		for i=2:length(s)
			if (s[i] != "")
				push!(nums, parse(Int32, s[i]))
			end
		end
		invidx[word] = nums
	end
	invidx
end

# ╔═╡ b7cb8d94-fd8e-4113-aa8c-942c3e25c925
function loadlinks(indeces, path="../data/index.txt")
	links = []
	io = open(path, "r")
	lines = readlines(io)
	for line in lines
		s = split(line, " ")
		index = s[1]
		link = s[2]
		if index in indeces
			@show link
			push!(links, link)
		end
	end
	close(io)
	links
end

# ╔═╡ Cell order:
# ╠═7c8adb4b-7039-48b7-81a5-21bcd63984fb
# ╠═78387644-932d-11eb-33e1-47040dd4d2e4
# ╠═a7f3db01-1759-45f2-abf2-de2e78196811
# ╠═51297f05-60db-4091-99b8-273acaa8b85a
# ╠═b7cb8d94-fd8e-4113-aa8c-942c3e25c925
