### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 540c48e0-9094-11eb-1b4a-fdc88fa61d68
using HTTP, Gumbo, Cascadia

# ╔═╡ d27fd980-909e-11eb-190a-8540e220c715
initialarticle = "https://en.wikipedia.org/wiki/Political_philosophy"

# ╔═╡ 0962130a-909f-11eb-05c6-4b6de811b04c
function getwikilinks(site)
	response = HTTP.get(site)
	html = parsehtml(String(response.body))
	s = Selector("a[href^='/wiki/']")
	eachmatch(s, html.root)[1:100]
end

# ╔═╡ bab0250c-909f-11eb-352b-af848237c0b7
function savelinks(links)
	io = open("index.txt", "w")
	for link in links
		link = attrs(link)["href"]
		write(io, "https://en.wikipedia.org" * link * "\n")
	end
	close(io)

end
		

# ╔═╡ 46052c38-9099-11eb-1070-5b1ed32a0233
links = getwikilinks(initialarticle)

# ╔═╡ 8000f930-90aa-11eb-0a6c-3d2448013041
savelinks(links)

# ╔═╡ f7398988-9099-11eb-006e-97f68d704620
print("FINISHED\n")

# ╔═╡ Cell order:
# ╠═540c48e0-9094-11eb-1b4a-fdc88fa61d68
# ╠═d27fd980-909e-11eb-190a-8540e220c715
# ╠═0962130a-909f-11eb-05c6-4b6de811b04c
# ╠═bab0250c-909f-11eb-352b-af848237c0b7
# ╠═46052c38-9099-11eb-1070-5b1ed32a0233
# ╠═8000f930-90aa-11eb-0a6c-3d2448013041
# ╠═f7398988-9099-11eb-006e-97f68d704620
