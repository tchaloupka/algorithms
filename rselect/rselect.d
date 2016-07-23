import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;
import std.random;

void main(string[] argv)
{
	if (argv.length < 3)
	{
		writeln("Expecting index of required number and name of data file - For example: rselect 3 data.txt");
		return;
	}

	// Load data
	int idx = argv[1].to!int;
	int[] data = File(argv[2]).byLine().map!(a => a.strip.to!int).array;

	assert(idx > 0 && data.length > idx - 1, "Invalid index");

	writeln("Value at position ", idx, " is ", rselect(data, idx-1));
}

auto rselect(int[] data, int idx)
{
	//select pivot and swap with first element
	swap(data[0], data[uniform(0, data.length)]);
	int pivot = data[0];

	//partition data around pivot
	int i = 1;
	foreach(j; 1..data.length)
	{
		if (data[j] < pivot)
			swap(data[i++], data[j]);
	}

	//place pivot on the right place
	swap(data[0], data[--i]);

	if (idx == i) return data[i];
	if (idx < i) return rselect(data[0..i], idx);
	return rselect(data[i..$], idx-i);
}
