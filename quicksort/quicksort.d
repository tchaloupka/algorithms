import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;
import std.functional;
import std.random;

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("File with data must be specified!");
		return;
	}

	// Load data
	int[] data = File(argv[1]).byLine().map!(a => a.strip.to!int).array;

	// Prepare data for 3 pivot selection variants
	auto dataFirst = data.dup;
	auto dataLast = data.dup;
	auto dataMed = data.dup;
	auto dataRnd = data.dup;
	
	// Call all variants
	auto cFirst = qsort!(a => 0)(dataFirst);
	auto cLast = qsort!(a => a.length-1)(dataLast);
	auto cMed = qsort!((a)
	{
		import std.typecons;

		auto mi = (a.length + 1)/2 - 1;
		Tuple!(size_t,int)[3] arr = [tuple(0LU, a[0]), tuple(a.length-1, a[a.length-1]), tuple(mi, a[mi])];
		arr[].sort!((a,b) => a[1] < b[1])();
		return arr[1][0];
	})(dataMed);
	auto cRnd = qsort!(a => uniform(0, a.length))(dataRnd);

	writeln("Total comparisons: ", cFirst, " ", cLast, " ", cMed, " ", cRnd);
}

auto qsort(alias pred)(int[] data)
{
	// stop reursion
	if (data.length < 2) return 0;

	//select pivot and swap with first element
	alias pivotSelector = unaryFun!pred;
	swap(data[0], data[pivotSelector(data)]);
	int pivot = data[0];

	//partition data around pivot
	int i = 1;
	foreach(j; 1..data.length)
	{
		if (data[j] < pivot)
			swap(data[i++], data[j]);
	}

	//place pivot on the right place
	swap(data[0], data[i-1]);

	//count needed comparisons
	auto count = data.length - 1;
	
	//divide problem around pivot
	if (i > 2) count += qsort!(pred)(data[0..i-1]);
	count += qsort!(pred)(data[i..$]);

	//return total count of needed comparisons
	return count;
}

