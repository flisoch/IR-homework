### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7f2dc1b0-90ce-11eb-376e-23dc70b084d7
using TextAnalysis

# ╔═╡ 0c263ba0-90d3-11eb-12c1-a300fafbbcf2
using WordTokenizers

# ╔═╡ 8143c738-90d1-11eb-0190-f3e6f96d6f3a
io = open("/home/flisoch//Desktop/searchJl/task1 - javaCrawler/target/resources/files/0.txt", "r")

# ╔═╡ f09ab678-90d1-11eb-0fba-d97f606b0175
text = readline(io)

# ╔═╡ 8a5ac0a8-90d2-11eb-2bb0-75be8cce5a3b
close(io)

# ╔═╡ d25cda4a-90d1-11eb-18d7-591e20e56b6d
sd1 = StringDocument(text)

# ╔═╡ f4946dbc-90d3-11eb-35df-bb9c56d412c7
prepare!(sd1, strip_punctuation| strip_non_letters| strip_articles)

# ╔═╡ 36c639ea-90d4-11eb-2b75-9f6a0f097515
remove_case!(sd1)

# ╔═╡ d5f36f26-90d2-11eb-0b9c-2daaf631478a
words = tokens(sd1)

# ╔═╡ 619f1f38-90de-11eb-1519-d17e2cee5d45
io1 = open("words.txt", "w")

# ╔═╡ d0a0dc98-90de-11eb-0830-798f45f14b93
for word in words
	write(io1, word * "\n")
end

# ╔═╡ f902ee72-90de-11eb-380b-5780eedd07eb
close(io1)

# ╔═╡ Cell order:
# ╠═7f2dc1b0-90ce-11eb-376e-23dc70b084d7
# ╠═0c263ba0-90d3-11eb-12c1-a300fafbbcf2
# ╠═8143c738-90d1-11eb-0190-f3e6f96d6f3a
# ╠═f09ab678-90d1-11eb-0fba-d97f606b0175
# ╠═8a5ac0a8-90d2-11eb-2bb0-75be8cce5a3b
# ╠═d25cda4a-90d1-11eb-18d7-591e20e56b6d
# ╠═f4946dbc-90d3-11eb-35df-bb9c56d412c7
# ╠═36c639ea-90d4-11eb-2b75-9f6a0f097515
# ╠═d5f36f26-90d2-11eb-0b9c-2daaf631478a
# ╠═619f1f38-90de-11eb-1519-d17e2cee5d45
# ╠═d0a0dc98-90de-11eb-0830-798f45f14b93
# ╠═f902ee72-90de-11eb-380b-5780eedd07eb
