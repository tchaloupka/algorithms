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

struct Vertex
{
	Appender!(int[]) asc;
	bool visited;
}

Graph graph;
Graph graphInv;

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("File with data must be specified!");
		return;
	}

	loadGraphs(File(argv[1]).byLine);

	auto leaders = getLeaders(graph);
	auto components = getComponents(graphInv, leaders);

	components.sort!((a,b) => a > b)();

	writeln("Components sizes: ", components.take(5));
}

void loadGraphs(T)(T source)
{
	Appender!(Graph) g;
	Appender!(Graph) gi;

	size_t arcsCount;

	// parse input lines to arcs range (tuple with from and to vertex indexes)
	auto arcs = source
		.map!(a => a.stripRight)
		.filter!(a => a.length > 0 && a.canFind(' '))
		.map!((a)
		{
			auto i = a.indexOf(' ');
			auto r = tuple(a[0..i].to!int, a[i+1..$].to!int);
			return r;
		});

	// build both graphs at once
	foreach (arc; arcs)
	{
		arcsCount++;

		auto m = max(arc[0], arc[1]); // to get highest vertex index

		// ensure vertex existance in both graphs (append missing ones)
		if (g.data.length < m)
			g ~= repeat(Vertex()).take(m - g.data.length);

		if (gi.data.length < m)
			gi ~= repeat(Vertex()).take(m - gi.data.length);

		// add new arc to vertex
		g.data[arc[0]-1].asc ~= arc[1] - 1;
		gi.data[arc[1]-1].asc ~= arc[0] - 1;
	}

	// set globals
	graph = g.data;
	graphInv = gi.data;

	assert(g.data.length == gi.data.length);

	writeln("G(V,E): ", g.data.length, ", ", arcsCount);
}

// first pass - get ordered list of vertex indexes for the second pass
auto getLeaders(Graph g)
{
	size_t[] leaders = new size_t[g.length];
	size_t li = leaders.length - 1;

	void visit(size_t i)
	{
		if (!g[i].visited)
		{
			g[i].visited = true;
			foreach(a; g[i].asc.data) visit(a);
			leaders[li--] = i;
		}
	}

	foreach(i; 0..g.length) visit(i);

	return leaders;
}

// DFS through vertices in leaders order to count SCCs and their vertices
auto getComponents(Graph g, size_t[] leaders)
{
	int[] components;

	void assign(size_t i)
	{
		if (!g[i].visited)
		{
			g[i].visited = true;
			components[$-1]++;
			foreach(a; g[i].asc.data) assign(a);
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

	loadGraphs(testData.lineSplitter);

	auto leaders = getLeaders(graph);
	auto components = getComponents(graphInv, leaders);
	components.sort!((a,b) => a > b)();
	assert(components == [3,3,3]);
}

