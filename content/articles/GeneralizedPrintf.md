---
title: "Generalizing printf in C"
tags: ["Programming"]
date: 2025-08-20T10:25:12-05:00
---

In ANSI C89, there are 6 printf functions:

* `printf`
* `sprintf`
* `fprintf`
* `vprintf`
* `vsprintf`
* `vfprintf`

Other C versions add more:

* `dprintf`
* `snprintf`
* `asprintf`
* `vdprintf`
* `vsnprintf`
* `vasprintf`

The sole difference between these functions is the format of input and the source of output. It would make sense to generalize this class of functions in a implementation of printf. Ideally down into one function that constructs and outputs the formatted string which the 12 functions can wrap around or be based upon.

Some simple optimizations can be made already, all printf functions wrap around their varaidic forms, which cuts the list in half. `printf` and `dprintf` can both be thought of as wrappers, which reduces the now 6 functions needed into 4:

* `vsprintf`
* `vfprintf`
* `vsnprintf`
* `vasprintf`

`sprintf` was a bad idea for the same reason `gets` was (in fact, GCC will throw a warning if it detects the use of either of those in almost every case). `snprintf` is theoretically different because it needs an output limit, but the behaviour of `sprintf` can be replicated by setting that limit to `SIZE_MAX` or similar.[^1]

The 3 functions left are `vfprintf`, `vasprintf`, and `vsnprintf`. There is a straightforward way to reduce these down into one function, to `vasprintf` a dynamically allocated string, output it  with `memcpy` or `fputs`, then `free` it.

The problem with this approach is that it is inefficient. Even if using a vector that doubles in size when expanding to be O(log n), there are redundant allocations. If the formatted result is especially large, it will take up a large amount of memory. Trying to generalize printf functions that outputs the string as its constructed is a harder and more interesting problem.

## The art of transmutation and opaqueness

C89[^2] defines `qsort` as:

```c
void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *));
```

The first 3 arguments are the parameters for an array, with the last being a function to pass the elements to (often a wrapper around `strcmp`, the comparison operator, or similar).

What is notable about this function is the use of function pointers to modularize code, and the fact that it has no information about the array it is given besides its size and element size. Because of this:

* Transmutation is required to use it
* Which makes use of the function much more volatile since it is harder to check if the types being given or interpreted are valid

Consider the two arrays:

```
long long a[] = {0, 0, 0, 0, 0};
char *b[] = {"b", "a", "c", "d", "e"}; 
```

Both contain 5 8-byte elements[^3]. But they both cast to a void pointer when passed into `qsort`. And the information about the type is lost until it is recast presuming it's the desired type. The compiler won't throw a warning if you sort the first array with a wrapper around `strcmp`. Nor will it warn you if you give a wrong number of elements or element size.

In our printf implementation, we can pass in both a file **and** a buffer to write to, along with a output function and the needed format string and list of arguments:

```c
static int _vfsprintf(FILE *stream, char *buffer, size_t size, int (*submit)(char *, char *, FILE *), const char *format, va_list va);
```

Since the `FILE` stream, the `buffer`, and the `size` are only used inside the `submit` function, they can be set to null and ignored in the output handlers.

If you could write a static/dynamic buffer in multiple distributed steps using a function pointer and a pointer to the start of the buffer alone, this and a few wrapper functions would be the end of it. Unfortunately, doing this in C requires state.

## OOP in C

Writing a buffer in multiple steps with a function requires you to continue from where you left off. Keeping track of where you left off is trivial:

```c
struct bufinfo {
	int idx;
	size_t len;
	char *buffer;
};
```

This needs to be carried with you the entire time you're writing to the buffer. Which can be done by passing in a void pointer in containing the state that the output function needs:

```c
static int __submit_vfprintf(FILE *stream, char *str, int (*submit)(char *, FILE *, char *, void *), const char *format, va_list va, void *initstate)
``` 

The pointer `initstate` is passed to the output function, which uses it to write to the buffer then modifies the information inside it for the next time the function is called. This is a way of keeping state that is neither local nor global.

```c
static int vfp_strapp_submit(char *str, FILE *ignored, char *ignoredalso, void *bufferinfo) {
	struct bufinfo *bi = bufferinfo;
	size_t len = strlen(str);
	size_t left = bi->len - bi->idx;
	if (len > left) {
		return 0;
	}
	memcpy(bi->buffer+bi->idx, str, len);
	bi->idx += len;
	bi->buffer[bi->idx + 1] = '\0';
	return len;
}
```

Thus, an implementation of `vsnprintf` (and by extension `sprintf` and `snprintf`) can be made with a few lines of boilerplate code:

```c
int vsnprintf(char *s, size_t n, const char *format, va_list arg) {
	struct bufinfo bufinfo;
	bufinfo.buffer = s;
	bufinfo.len = n;
	bufinfo.idx = 0;
	return __submit_vfprintf(NULL, NULL, vfp_strapp_submit, format, arg, &bufinfo);
};
```

[^1]: An alternate solution for perfectionists would be to make both functions a wrapper around one core function that takes a boolean of whether or not to look at the output limit.

[^2]: Later versions of the C standard may make use of `typeof` or other modern features

[^3]: A more realistic example might be sorting an array of 64-bit numbers using the comparison function that sorts 32-bit integers