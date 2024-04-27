---
Title: Lua Library Cheat Sheet
Date: 2024-04-20
---
<title>Lua Library Quick Reference</title>
# Lua library quick reference

As someone learning lua, a quick reference for what the standard library
contains would be nice, what's unfortunate is that most documentation I
can find will describe a module rather than whats inside it. I've yet
to find a site that provides a list of all the methods the lua libraries
provide.

So without further a-do, here is mine:

Note: This is _not_ complete, but documents most functions

## I/O Module

| Name    | Args         | Returns    | Purpose                            | C analog  |
|---------+--------------+------------+------------------------------------+-----------|
| close   | File         | Bool       | Close a file                       | fclose()  |
| flush   | File         | Bool       | Flush file buffer                  | fflush()  |
| input   | [File]       | File       | Set/Get default input              | N/A       |
| lines   | String       | Function   | Make Func that iterates over file  | N/A       |
| open    | String       | File       | Open a file                        | open()    |
| output  | [File]       | File       | Set/Get default output             | N/A       |
| popen   | String       | File       | Run command and use output as file | popen()   |
| read    | File, Type   | String     | Get bytes from file                | read()    |
| stderr  | N/A          | N/A        | File for standard error            | stderr    |
| stdin   | N/A          | N/A        | File for standard input            | stdin     |
| stdout  | N/A          | N/A        | File for standard output           | stdout    |
| tmpfile | N/A          | File       | Opens a auto-removed tmp file      | tmpfile() |
| type    | File         | String/Nil | Check if file is valid             | N/A       |
| write   | File, String | File       | Send bytes to file                 | write()   |

## Math Module

All trig functions work in radians

| Name       | Args                | Returns | Purpose            | Analog      |
|------------+---------------------+---------+--------------------+-------------|
| abs        | Number              | Number  | Absolute Value     | abs()       |
| acos       | Number              | Number  | Arcosine           | acos()      |
| asin       | Number              | Number  | Arcsine            | asin()      |
| atan       | Number [, Number]   | Number  | Arctangent         | atan\[2\]() |
| ceil       | Number              | Number  | Round Up to int    | ceil()      |
| cos        | Number              | Number  | Cosine             | cos()       |
| deg        | Number              | Number  | Radians -> Degrees | N/A         |
| exp        | Number              | Number  | Base E exponent    | exp()       |
| floor      | Number              | Number  | Round Down to int  | floor()     |
| max        | Number [,Number...] | Number  | Return Max Number  | MAX()       |
| min        | Number [,Number...] | Number  | Return Min Number  | MIN()       |
| log        | Number [,Number]    | Number  | Base Logarithm     | log()       |
| randomseed | Number              | Number  | Seed RNG           | srandom()   |
| sin        | Number              | Number  | Sine               | sin()       |
| sqrt       | Number              | Number  | Square Root        | sqrt()      |
| tan        | Number              | Number  | Tangent            | tan()       |
| tointeger  | Number              | Number  | Round to near int  | round()     |
| fmod       | Number, Number      | Number  | Decimal Remainder  | fmod()      |
| huge       | N/A                 | N/A     | Biggest Number     | N/A         |
| maxinteger | N/A                 | N/A     | Max Integer        | INT_MAX     |
| mininteger | N/A                 | N/A     | Min Integer        | INT_MIN     |
| modf       | Number, Number      | Number  | Floored Decimal %  | fmod()      |
| pi         | N/A                 | N/A     | Pi                 | M_PI        |
| rad        | Number              | Number  | Degrees -> Radians | N/A         |
| random     | Number [, Number]   | Number  | Psuedo RNG         | random()    |
| type       | Number              | String  | Return Number type | N/A         |
| ult        | Number, Number      | Number  | Unsigned <         | Typecast    |

## Table Module

| Name   | Args                               | Returns  | Purpose                              |
|--------+------------------------------------+----------+--------------------------------------|
| concat | Table [,String[,Number[,Number]]]  | String   | Concatenate Items of table           |
| sort   | Table [,Function]                  | N/A      | Sort a table, compare with function  |
| insert | Table, [Number,] Number            | N/A      | Push or insert value into table      |
| remove | Table [,Number]                    | N/A      | Pop or remove array value            |
| pack   | ...                                | Table    | Create A Table out of a element list |
| unpack | list [,Number[,Number]]            | Elements | Return Multiple Elements from table  |
| move   | Table,Number,Number,Number[,Table] | Table    | Move elements between tables         |

## OS Module

| Name      | Args                  | Returns | Purpose                       | C Analog    |
|-----------+-----------------------+---------+-------------------------------+-------------|
| clock     | N/A                   | Number  | Get CPU clock time for timing | clock()     |
| date      | String [, Time-Table] | String  | Format time                   | strftime()  |
| difftime  | Table Table           | Number  | Diff in seconds between times | difftime()  |
| execute   | String                | Number  | Execute Command               | execvp()    |
| exit      | [Number]              | N/A     | Exit                          | exit()      |
| getenv    | String                | String  | Get environment variable      | getenv()    |
| remove    | String                | Bool    | Remove a file or empty dir    | remove()    |
| setlocale | String [,String]      | String  | Set the locale                | setlocale() |
| time      | [Table]               | Number  | Return Time                   | [mk]time()  |
| tmpname   | N/A                   | String  | Get a temporary name          | tempnam()   |

## String Module

| Name     | Args                             | Returns        | Purpose                  | C Analog   |
|----------+----------------------------------+----------------+--------------------------+------------|
| byte     | Number [, Number [, Number]]     | Numbers        | Get Byte Number          | Indexing   |
| char     | Number...                        | String         | Concat Bytes into string | Assignment |
| dump     | Function                         | String         | Dump String              | N/A        |
| find     | String, String[,Number[,Bool]    | Number, Number | Index String             | strstr()   |
| format   | String, ...                      | String         | Format String            | sprintf()  |
| gmatch   | String, String [, Number]        | Function       | Iterate over str matches | N/A        |
| gsub     | String, String, String, [Number] | String         | Global Substitution      | N/A        |
| len      | String                           | Number         | String Length            | strlen()   |
| lower    | String                           | String         | Convert to lower         | tolower()  |
| match    | String, String [, Number]        | String         | Return String Match      | regexec()  |
| pack     | String, ...                      | String         | Format Binary String     | N/A        |
| packsize | String                           | Number         | Return Format Size       | N/A        |
| rep      | String, Number [, String]        | String         | Concat String Repeatedly | N/A        |
| reverse  | String                           | String         | Reverse String           | N/A        |
| sub      | String, Number [, Number]        | String         | Substring                | N/A        |
| unpack   | String, String [, Number]        | ...            | Unpack packed string     | N/A        |
| upper    | String                           | String         | Convert String to Upper  | toupper()  |
