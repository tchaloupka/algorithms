import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;
import std.random;
import std.range;

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("File with data must be specified!");
		return;
	}

	// Load data
	auto edges = File(argv[1]).byLine().map!(a => a.strip.splitter(' ').map!(a => a.to!int - 1).array).array;

	writeln("G(V,E): ", edges[$-1][0] + 1, ", ", edges.length);
}

