import std.stdio;

version(unittest)
{
void main()
{
	writeln("All tests passed ok");
}
}

struct Heap(T, alias pred = "a < b")
{
	import std.array : Appender, appender;
	import std.functional : binaryFun;

	void put(T value)
	{
		void bubleUp(size_t idx)
		{
			import std.algorithm : swap;
			
			if (idx == 0) return;
			
			auto par = (idx - 1)/2;
			if (binaryFun!(pred)(_payload.data[par], _payload.data[idx])) return;
			swap(_payload.data[par], _payload.data[idx]);
			bubleUp(par);
		}

		if (_payload.data.length > _len) _payload.data[_len] = value;
		else _payload ~= value;
		bubleUp(_len++);
	}

	T get()
	{
		import std.algorithm : swap;

		void bubleDown(size_t idx)
		{
			auto l = 2 * idx + 1;
			auto r = 2 * idx + 2;
			size_t next;

			if (l < _len && binaryFun!(pred)(_payload.data[l], _payload.data[idx]))
				next = l;
			else
				next = idx;
			if (r < _len && binaryFun!(pred)(_payload.data[r], _payload.data[next]))
				next = r;

			if (next != idx)
			{
				swap(_payload.data[idx],_payload.data[next]);
				bubleDown(next);
			}
		}

		auto res = _payload.data[0];
		swap(_payload.data[0], _payload.data[--_len]);

		bubleDown(0);

		return res;
	}

	@property auto data()
	{
		return _payload.data[0.._len];
	}

private:
	Appender!(T[]) _payload;
	size_t _len;
}

unittest
{
	auto h = Heap!int();
	h.put(1);

	assert(h.data == [1]);

	h.put(30);
	assert(h.data == [1,30]);

	h.put(20);
	assert(h.data == [1,30,20]);

	h.put(5);
	assert(h.data == [1,5,20,30]);

	assert(h.get() == 1);
	assert(h.get() == 5);
	h.put(25);
	assert(h.data == [20,30,25]);
	assert(h.get() == 20);
	assert(h.get() == 25);
	assert(h.get() == 30);
}
