### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 85a52ed0-86fc-4a12-9578-3683a04c004f
begin
	using AbstractPlutoDingetjes
	using HypertextLiteral
	using Random
end

# ╔═╡ 46e00764-7dba-4dc6-84f4-0d5deb153b9c
begin
    const MicrophoneValue = Vector{Float32}

    struct Microphone end

    function Base.show(io::IO, ::MIME"text/html", microphone::Microphone)
        mic_id = Random.randstring('a':'z', 10)
        mic_btn_id = Random.randstring('a':'z', 10)
        
        htl = HypertextLiteral.@htl("""
        <audio id=$(mic_id)></audio>
        <input type="button" id=$(mic_btn_id) class="mic-button" value="Stop">
        
        <script>
            const player = document.getElementById($(mic_id));
            const stop = document.getElementById($(mic_btn_id));
        
            const handleSuccess = function(stream) {
                const context = new AudioContext({ sampleRate: 44100 });
                const analyser = context.createAnalyser();
                const source = context.createMediaStreamSource(stream);
        
                source.connect(analyser);
                
                const bufferLength = analyser.frequencyBinCount;
                
                let dataArray = new Float32Array(bufferLength);
                let animFrame;
                
                const streamAudio = () => {
                    animFrame = requestAnimationFrame(streamAudio);
                    analyser.getFloatTimeDomainData(dataArray);
                    player.value = Array.from(dataArray);
                    player.dispatchEvent(new CustomEvent("input"));
                }
        
                streamAudio();
        
                stop.onclick = e => {
                    source.disconnect(analyser);
                    cancelAnimationFrame(animFrame);
                }
            }
        
            navigator.mediaDevices.getUserMedia({ audio: true, video: false })
            .then(handleSuccess)
        </script>
        
		<style>
		    .mic-button {
		        background-color: #ff4d4d;  
		        border: 1px solid #b30000;
		        border-radius: 5px;
		        color: black;
		        padding: 10px 20px;
		        text-align: center;
		        font-size: 14px;
		        font-family: "Alegreya Sans", sans-serif;
		        margin: 4px 2px;
		        cursor: pointer;
		        transition: background-color 0.2s ease-in-out; 
		    }
		
		    .mic-button:hover {
		        background-color: #cc0000;
		    }
		</style>
        """)
        
        show(io, MIME"text/html"(), htl)
    end

    # Bonds interface
    function AbstractPlutoDingetjes.Bonds.initial_value(::Microphone)
        return MicrophoneValue()
    end

    function AbstractPlutoDingetjes.Bonds.transform_value(::Microphone, audio_data::AbstractVector{<:Real})
        return convert(MicrophoneValue, audio_data)
    end

    AbstractPlutoDingetjes.Bonds.possible_values(::Microphone) = nothing

    function AbstractPlutoDingetjes.Bonds.validate_value(::Microphone, value)
        value isa AbstractVector{<:Real} || throw(ArgumentError("Value must be a vector of real numbers"))
        return nothing
    end

    export Microphone
end

# ╔═╡ 98ac49ad-9391-4dcb-8fdb-860fdef19cce
md"""
# Example
### Plotting microphone input in real time
"""

# ╔═╡ ecfc7f7a-531d-4f8a-8180-850347866693
md"""
```julia
@bind audio Microphone()

using Plots
using SampledSignals

plot(domain(SampleBuf(Array(audio), 44100)), SampleBuf(Array(audio), 44100), legend=false, ylims=(-1,1))
```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
AbstractPlutoDingetjes = "~1.3.2"
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "4519ab847b380d0900473f1d88e770104525c296"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═85a52ed0-86fc-4a12-9578-3683a04c004f
# ╠═46e00764-7dba-4dc6-84f4-0d5deb153b9c
# ╟─98ac49ad-9391-4dcb-8fdb-860fdef19cce
# ╟─ecfc7f7a-531d-4f8a-8180-850347866693
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
