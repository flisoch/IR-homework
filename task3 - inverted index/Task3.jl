### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 9170c1a6-913f-11eb-0d5e-41f097fd770f
using TextAnalysis

# ╔═╡ a36cdab6-913f-11eb-3356-c979b7b5c91f
include("task2 - tokens/Task2.jl")

# ╔═╡ ccdb279e-9140-11eb-3d8b-bd419f3c6d41
sds = []

# ╔═╡ c5624a56-9140-11eb-38dd-033c51745656
filescount = 10

# ╔═╡ 9f047860-913f-11eb-12eb-e9134d976b91
for i = 0:filescount
	text = readfile(i)
	sd1 = StringDocument(text)
	prepare!(sd1, strip_punctuation| strip_non_letters| strip_articles| strip_indefinite_articles| strip_prepositions| strip_pronouns| strip_stopwords)
	remove_case!(sd1)
	push!(sds, sd1)

end

# ╔═╡ 2bb42220-9141-11eb-30ef-811d12e92a06
crps = Corpus(sds)

# ╔═╡ 85b85bb0-9141-11eb-0871-d15dc9506e33
update_lexicon!(crps)

# ╔═╡ 86fc3a82-9141-11eb-3a57-bf1cd0aaeb22
lexico = lexicon(crps)

# ╔═╡ ac317b00-9141-11eb-2459-9bd6ff872fe1
update_inverse_index!(crps)

# ╔═╡ a377575a-9141-11eb-10f0-d3b6e743f731
invidx = inverse_index(crps)

# ╔═╡ 86a0a130-9147-11eb-311e-974ce98d39c8
function saveindex(invidx)
	io = open("inverted_index.txt", "a+")
	for (key, value) in invidx
		countstring = " "
		for num in value
			countstring = countstring * string(num) * " "
		end
		write(io, key * countstring * "\n")
	end
	close(io)
end

# ╔═╡ d18d5204-9147-11eb-102d-c1c036f4330d
saveindex(invidx)

# ╔═╡ Cell order:
# ╠═9170c1a6-913f-11eb-0d5e-41f097fd770f
# ╠═a36cdab6-913f-11eb-3356-c979b7b5c91f
# ╠═ccdb279e-9140-11eb-3d8b-bd419f3c6d41
# ╠═c5624a56-9140-11eb-38dd-033c51745656
# ╠═9f047860-913f-11eb-12eb-e9134d976b91
# ╠═2bb42220-9141-11eb-30ef-811d12e92a06
# ╠═85b85bb0-9141-11eb-0871-d15dc9506e33
# ╠═86fc3a82-9141-11eb-3a57-bf1cd0aaeb22
# ╠═ac317b00-9141-11eb-2459-9bd6ff872fe1
# ╠═a377575a-9141-11eb-10f0-d3b6e743f731
# ╠═86a0a130-9147-11eb-311e-974ce98d39c8
# ╠═d18d5204-9147-11eb-102d-c1c036f4330d
