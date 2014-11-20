
function checkout(path, commit)
	run(`git --git-dir=$path/.git checkout --quiet $commit`)	
end
type Package
	name
	commit
	Package(name, commit="") = new(name, commit)
end
function install(a::Package) 
	Pkg.add(a.name)
	isempty(a.commit) ? nothing : checkout(Pkg.dir(a.name), a.commit)
end

type Git
	url
	commit
	Git(url, commit="") = new(url, commit)
end

function install(a::Git)
	Pkg.clone(a.url)
	if !isempty(a.commit) 
		m = match(r"(?:^|[/\\])(\w+?)(?:\.jl)?(?:\.git)?$", a.url)
		m != nothing || error("can't determine package name from URL: $a.url")
		pkg = m.captures[1]
		checkout(Pkg.dir(pkg), a.commit)
	end
end

function parseline(a)
	parts = split(a)
	package = parts[1]
	commit = length(parts)>1 ? parts[2] : ""
	if length(split(commit,"."))==3
		commit = "v"*commit
	end
	if contains(package, "/")
		return Git(package, commit)
	else
		return Package(package, commit)
	end
end

print("Parsing REQUIRE.jwp ... ")
lines = filter(x->!isempty(x) && x[1]!='#', split(readall("REQUIRE.jwp"), '\n'))

packages = map(parseline, lines)
println("ok")


Pkg.init()
map(install, packages)

print("Making $(Pkg.dir()) read only ...")
run(`chmod -R a-w $(Pkg.dir())`)
println(" done")

println("Finished installing packages from REQUIRE.jwp.")




