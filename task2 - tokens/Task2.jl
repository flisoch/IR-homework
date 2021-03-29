### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7f2dc1b0-90ce-11eb-376e-23dc70b084d7
using TextAnalysis

# ╔═╡ 0c263ba0-90d3-11eb-12c1-a300fafbbcf2
using WordTokenizers

# ╔═╡ 8143c738-90d1-11eb-0190-f3e6f96d6f3a
filescount = 30

# ╔═╡ f09ab678-90d1-11eb-0fba-d97f606b0175
function readfile(index)
	filename = "/home/flisoch//Desktop/searchJl/task1 - javaCrawler/target/resources/files/" * string(index) * ".txt"
	io = open(filename)
	text = readline(io)
	close(io)
	text
end

# ╔═╡ f2d680c4-90e1-11eb-3c9c-21588d3f7c66
function savewords(words)
	io = open("words.txt", "a+")
	for word in words
		write(io, word * "\n")
	end
	close(io)
end

# ╔═╡ 8a5ac0a8-90d2-11eb-2bb0-75be8cce5a3b
for i = 0:filescount
	text = readfile(i)
	sd1 = StringDocument(text)
	prepare!(sd1, strip_punctuation| strip_non_letters| strip_articles)
	words = tokens(sd1)
	savewords(words)
end

# ╔═╡ Cell order:
# ╠═7f2dc1b0-90ce-11eb-376e-23dc70b084d7
# ╠═0c263ba0-90d3-11eb-12c1-a300fafbbcf2
# ╠═8143c738-90d1-11eb-0190-f3e6f96d6f3a
# ╠═f09ab678-90d1-11eb-0fba-d97f606b0175
# ╠═f2d680c4-90e1-11eb-3c9c-21588d3f7c66
# ╠═8a5ac0a8-90d2-11eb-2bb0-75be8cce5a3b
