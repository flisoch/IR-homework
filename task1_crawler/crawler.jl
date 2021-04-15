### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 610d8c4e-9188-11eb-02e5-8156c59d770e
using HTTP, Gumbo, Cascadia

# ╔═╡ 5105efa4-9191-11eb-0b12-eb2eecb8aadd
using AbstractTrees

# ╔═╡ 9bdcec02-9188-11eb-3825-a160c20d6e8d
using TextAnalysis

# ╔═╡ a0b00e12-9188-11eb-2cb2-9dcd0d8924ad
function open_urlfile(filename)
	urls = []
	io = open(filename, "r")
	for url in eachline(io)
		push!(urls, url)
	end
	close(io)
	urls
end

# ╔═╡ acc8ca84-918a-11eb-0f55-8f9ea520a649
filename = "/home/flisoch/Desktop/searchJl/index.txt"

# ╔═╡ dec196f6-918a-11eb-2ade-099b7bd95125
begin
	urls = []
	if isfile(filename)
		urls = open_urlfile(filename)
	else
		@warn "Could not open the file to write. filename: " * filename
	end
end

# ╔═╡ 1bb7fda6-918c-11eb-11a4-09ab6aa1d79b
function readurl(url)
	try
		response = HTTP.get(url)
		response
	catch err
		@error err.msg
		return HTTP.Response(400, string(err.msg))
	end
end

# ╔═╡ 14775726-918c-11eb-1d6c-b14d346f775a
if isempty(urls)
	@warn "no urls provided. "
else
	for url in urls[1:10]
		response = readurl(url)
		response.body
	end
end

# ╔═╡ 61e2ded4-918e-11eb-2a70-85121f4cbad5
response = readurl(urls[1])

# ╔═╡ 6ea5309a-918e-11eb-0215-75d202b8ff99
h = parsehtml(String(response.body))

# ╔═╡ 97c80514-918f-11eb-2408-c1b34bb1b3f2
eachmatch(Selector("*"), h.root)

# ╔═╡ f3280832-918f-11eb-3e0f-73405ceff05d


# ╔═╡ f3aa8cee-918f-11eb-3e25-bb8e734f84ca


# ╔═╡ Cell order:
# ╠═610d8c4e-9188-11eb-02e5-8156c59d770e
# ╠═5105efa4-9191-11eb-0b12-eb2eecb8aadd
# ╠═9bdcec02-9188-11eb-3825-a160c20d6e8d
# ╠═a0b00e12-9188-11eb-2cb2-9dcd0d8924ad
# ╠═acc8ca84-918a-11eb-0f55-8f9ea520a649
# ╠═dec196f6-918a-11eb-2ade-099b7bd95125
# ╠═1bb7fda6-918c-11eb-11a4-09ab6aa1d79b
# ╠═14775726-918c-11eb-1d6c-b14d346f775a
# ╠═61e2ded4-918e-11eb-2a70-85121f4cbad5
# ╠═6ea5309a-918e-11eb-0215-75d202b8ff99
# ╠═97c80514-918f-11eb-2408-c1b34bb1b3f2
# ╠═f3280832-918f-11eb-3e0f-73405ceff05d
# ╠═f3aa8cee-918f-11eb-3e25-bb8e734f84ca
