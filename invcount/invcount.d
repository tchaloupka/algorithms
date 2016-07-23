import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.algorithm;
import std.string;

int[] tmpData;

void main(string[] argv)
{
	if (argv.length == 1)
	{
		writeln("File with data must be specified!");
		return;
	}

	int[] data = File(argv[1]).byLine().map!(a => a.strip.to!int).array;

	tmpData = new int[data.length];

	writeln("# of inversions: ", invCount(data));
}

long invCount(int[] arr)
{
	if (arr.length < 2) return 0;

	auto m = (arr.length + 1) / 2;
	auto left = arr[0..m].dup;
	auto right = arr[m..$].dup;

	return invCount(left) + invCount(right) + merge(arr, left, right);
}

long merge(int[] arr, int[] left, int[] right)
{
	int i = 0, j = 0, c = 0;

	while (i < left.length || j < right.length)
	{
		if (i == left.length)
		{
			arr[i+j] = right[j];
			j++;
		}
		else if (j == right.length)
		{
			arr[i+j] = left[i];
			i++;
		}
		else if (left[i] <= right[j])
		{
			arr[i+j] = left[i];
			i++;                
		}
		else
		{
			arr[i+j] = right[j];
			c += left.length-i;
			j++;
		}
	}

	return c;
}
