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
			

# ╔═╡ e8bcf9bc-bc40-4f91-aed2-0de5c09f03a3
# for test. Republic, Philosophy, Gautama Buddha
# texts = loadtexts([32, 78, 82])
# sd = StringDocument(texts[2])

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

# ╔═╡ 04d7b0ff-7554-4aac-9cd0-12a7b4cdcf90
corpus = loadtexts([x for x=1:97])

# ╔═╡ caf285b0-b1d4-4731-b55e-9cf9be61d579
# update_inverse_index!(corpus)

# ╔═╡ 8ab2244f-06ec-4ead-9d31-4a61d32ea2c9
update_lexicon!(corpus)

# ╔═╡ 53e435dc-94e1-4d44-98e4-f44cedf4ba97
update_inverse_index!(corpus)

# ╔═╡ 71640944-8081-4fb2-92be-3687238eff06
invidx = saved_inverseindex()

# ╔═╡ 50dd6751-3d52-4203-936a-fd4410e073d6
invidx["gautama"]

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
# ╠═e8bcf9bc-bc40-4f91-aed2-0de5c09f03a3
# ╠═a7f3db01-1759-45f2-abf2-de2e78196811
# ╠═51297f05-60db-4091-99b8-273acaa8b85a
# ╠═04d7b0ff-7554-4aac-9cd0-12a7b4cdcf90
# ╠═caf285b0-b1d4-4731-b55e-9cf9be61d579
# ╠═8ab2244f-06ec-4ead-9d31-4a61d32ea2c9
# ╠═53e435dc-94e1-4d44-98e4-f44cedf4ba97
# ╠═71640944-8081-4fb2-92be-3687238eff06
# ╠═50dd6751-3d52-4203-936a-fd4410e073d6
# ╠═b7cb8d94-fd8e-4113-aa8c-942c3e25c925
