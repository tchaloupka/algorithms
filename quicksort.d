import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;
import std.functional;

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("Je nutno zadat jméno souboru s daty");
		return;
	}

	int[] data = File(argv[1]).byLine().map!(a => a.strip.to!int).array;

	auto dataFirst = data.dup;
	auto dataLast = data.dup;
	auto dataMed = data.dup;
	
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
	//writeln(dataFirst);
	//writeln(dataLast);
	//writeln(dataMed);
	writeln("Pocet porovnani: ", cFirst, " ", cLast, " ", cMed);
}

auto qsort(alias pred)(int[] data)
{
	//writeln("Input: ", data);
	if (data.length < 2) return 0;

	alias pivotSelector = unaryFun!pred;

	swap(data[0], data[pivotSelector(data)]);

	int pivot = data[0];
	//write("Pivot: ", pivot, " - ");
	int i = 1;
	foreach(j; 1..data.length)
	{
		if (data[j] < pivot)
		{
			swap(data[i++], data[j]);
		}
	}

	swap(data[0], data[i-1]);

	//writeln("i: ", i, " - ", data);

	auto count = data.length - 1;
	
	if (i > 2) count += qsort!(pred)(data[0..i-1]);
	count += qsort!(pred)(data[i..$]);

	return count;
}

