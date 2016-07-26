import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;
import std.random;
import std.range;
import std.typecons;

alias Vertex[] Graph;

struct Arcs
{
	size_t max;
	Tuple!(int,int)[] arcs;
	alias arcs this;
}

struct Vertex
{
	int[] asc;
	bool visited;
}

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("File with data must be specified!");
		return;
	}

	auto arcs = loadArcs(File(argv[1]).byLine);
	auto graph = buildGraph(arcs);
	auto graphInv = buildGraph!(1,0)(arcs);

	auto leaders = getLeaders(graph);
	auto components = getComponents(graphInv, leaders);
	components.sort!((a,b) => a > b)();
	writeln("Components sizes: ", components.take(5));
}

auto loadArcs(T)(T source)
{
	Arcs res;
	res.arcs = source
		.map!(a => a.stripRight)
		.filter!(a => a.length > 0 && a.canFind(' '))
		.map!((a)
		{
			auto i = a.indexOf(' ');
			auto r = tuple(a[0..i].to!int - 1, a[i+1..$].to!int - 1);

			res.max = max(res.max, r[0], r[1]);

			return r;
		})
		.array;

	return res;
}

auto buildGraph(int F = 0, int T = 1)(Arcs arcs)
{
	arcs.arcs.sort!((a,b) => a[F] < b[F]);

	Graph g = new Vertex[arcs.max + 1];

	arcs.chunkBy!(a => a[F])
		.each!(a => g[a[0]].asc = a[1].map!(a => a[T]).array);

	writeln("G(V,E): ", g.length, ", ", arcs.length);

	return g;
}

//first pass
auto getLeaders(Graph g)
{
	size_t[] leaders = new size_t[g.length];
	size_t li = leaders.length - 1;

	void visit(size_t i)
	{
		if (!g[i].visited)
		{
			g[i].visited = true;
			foreach(a; g[i].asc) visit(a);
			leaders[li--] = i;
		}
	}

	foreach(i; 0..g.length) visit(i);

	return leaders;
}

auto getComponents(Graph g, size_t[] leaders)
{
	int[] components;

	void assign(size_t i)
	{
		if (!g[i].visited)
		{
			g[i].visited = true;
			components[$-1]++;
			foreach(a; g[i].asc) assign(a);
		}
	}

	foreach(i; leaders)
	{
		if (!g[i].visited) components ~= 0;
		assign(i);
	}

	return components;
}

unittest
{
	import std.string;

	enum testData = `1 4
2 8
3 6
4 7
5 2
6 9
7 1
8 5
8 6
9 7
9 3`;

	auto arcs = loadArcs(testData.lineSplitter);
	auto graph = buildGraph(arcs);
	auto graphInv = buildGraph!(1,0)(arcs);

	auto leaders = getLeaders(graph);
	auto components = getComponents(graphInv, leaders);
	components.sort!((a,b) => a > b)();
	assert(components == [3,3,3]);
}

