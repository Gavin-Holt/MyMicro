# Replacing text in micro editor


```
> replace "search" "value" "flags"  
    OR
> replace 'search' 'value' 'flags'  
```

The flags are optional. Possible flags are:
-    '-a' Replace all occurrences at once
-    '-l' Do a literal search instead of a regex search

If you make a selection, search and replace will only happen in the selected region.

Instructions to the replace command may end up being be parsed twice - once by the shell argument parser, and then by the [regex parser](https://pkg.go.dev/regexp#Regexp.Expand). This causes problems with special characters.

-   You can prevent shell parsing by using single quotes.
-   You can prevent regex parsing with -l (literal) flag.

This gives eight combinations:
````
> replace 'abc' 'def'
> replace "abc" 'def'
> replace "abc" "def"
> replace 'abc' "def"
> replace 'abc' 'def' -l
> replace "abc" 'def' -l
> replace "abc" "def" -l
> replace 'abc' "def" -l
````
Replace will search for ````\t```` ASCII escape sequence:

e.g. Expand all tabs to four spaces (the [expand](https://linuxhandbook.com/convert-tabs-spaces/) utility might be better)
```
> replace "\t" "    "
```
or 
``` 
> replace '\t' '    '
```

I could not get replace to insert ````\t````.

It appears that replace works on single lines only, so you can't find or insert ````\n```` nor ````\r````.

## Simple replacements

Strings without spaces don't need to be quoted, but replace behaves as if there are double quotes (read below)

e.g.
```
> replace string1 string2
```

e.g.
```
> replaceall \\$ £
```

Strings with spaces need to be quoted, and the type of quotes changes behavior.

## Working without shell parsing (Single quotes)

The [Regex parser](https://pkg.go.dev/regexp#Regexp.Expand) will look for metacharacters:

-   backslash \
-   caret ^
-   dollar sign $
-   period or dot .
-   pipe symbol |
-   question mark ?
-   asterisk  *
-   plus +
-   parenthesis ()
-   opening square bracket [
-   opening curly brace {

Escape metacharacters with \\, except $ which is escaped with $$.
-   '$$foo' would give the string ```$foo```

e.g. Replace all \ with / 
```
> replaceall '\\' '/' 
```
e.g. Replace all " with ' needs double quotes for the replacement.
```
> replaceall '"' "'"
```
Capture groups are [recognised](https://golang.org/pkg/regexp/syntax):
-   '$foo' would give the capture group named ```foo```
e.g. 

```
replace "(foo)" "$1-bar"
replace "(foo)" "${1}-bar"
replace "(?P<group>foo)" "$group-bar"
replace "(?P<group>foo)" "$group-bar"
replace "(?P<key>\w+):\s+(?P<value>\w+)$" "$key=$value"
```

NB. Any command ending in a \ will kill micro in Windows.

## Working with shell parsing (Double quotes)

Some characters must be escaped twice to reach the underlying functions. Shell parsing does not seem to work in Windows (either with $ prefix or wrapped in %%)

The following characters are special to the shell parser:
-   \   Escapes the following character
-   $   Looks for an environment variable
-   \\\\$  Returns the $ character
-   Others???

e.g. Replace all $ with £
```
> replaceall "\\$" "£"
```

e.g. Replace all \ with /   -  requires extra \ to preserve the closing "
```
> replaceall "\\\\" "/"
```

***Further examples using/escaping shell parsing need to go here***


## Working with the '-l' flag

The '-l' flag turns off regex parsing to allow literal replacements. However, with double quotes there is still shell parsing so some escaping is required.

# Replacing control character

I use external tools instead:

```
-- Replace all newlines in selection
> textfilter sed.exe -z 's/\n//g'
```

```
-- Replace all tabs in selection
> textfilter sed.exe -z 's/\t/    /g'
```
