import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;
import std.random;
import std.range;
import std.typecons;

alias Tuple!(int, int) Edge;
enum REPEAT = 100;

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("File with data must be specified!");
		return;
	}

	// Load data
	Appender!(Edge[]) edges;
	foreach(line; File(argv[1]).byLine())
	{
		auto r = line.strip.splitter('\t').map!(a => a.to!int);
		auto v = r.front; r.popFront;
		edges ~= r.map!(a => tuple(v, a));
	}

	writeln("G(V,E): ", countVertexes(edges.data, edges.data.length), ", ", edges.data.length);

	auto minCount = int.max;
	foreach(i; 0..REPEAT)
	{
		minCount = min(minCount, minCut(edges.data.dup));
	}

	writeln("Min cut edges#: ", minCount);
}

auto minCut(Edge[] edges)
{
	auto valid = edges.length;
	while (edges.countVertexes(valid) > 2)
	{
		//select random edge
		auto edge = edges[uniform(0, valid)];

		//join vertexes
		auto from = edge[0];
		auto to_ = edge[1];

		int i;
		while (i < valid)
		{
			if (edges[i][0] == from) edges[i] = tuple(to_, edges[i][1]);
			if (edges[i][1] == from) edges[i] = tuple(edges[i][0], to_);
			if (edges[i][0] == edges[i][1])
			{
				// remove cycle
				swap(edges[i], edges[valid-1]); //to avoid reallocations
				valid--;
			}
			else i++;
		}
	}

	return valid/2; //each edge is represented from both sides
}

auto countVertexes(Edge[] edges, size_t valid)
{
	return edges.map!(a => a[0]).take(valid-1).array.sort().uniq.walkLength;
}
