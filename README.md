# MyMicro  - Under construction
_This is my Micro. There are many like it, but this one is mine._ 

## Contents
- Introduction 
- Custom key bindings 
- External tools

## Introduction 
Micro is a terminal based code editor ... more of this on the [official web site](https://github.com/zyedidia/micro).

Features listed include:

- Easy to use and install. 
- No dependencies or external files are needed — just a single binary. 
- Multiple cursors. 
- Common key bindings 
- Syntax highlighting 
- Copy and paste with the system clipboard. 
- Regex search and replace 
- Small and simple. 
- Easily configurable.

Difficulties:

- **Your terminal, your problem**: key bindings are dependent upon your terminal sending the key codes to the console. Most terminals have limitations and will not recognise common key chords (e.g. Windows Console, via cmd.exe, won't distinguish between Ctrl+Alpha and Ctrl+Alt+Alpha).
- **Features not implemented**: Code Folding, Modal Editing, Spell checking, Replace newline characters
- **Lua chunks fail as a whole**: Each separate Lua file is parsed as a unit, failure will invalidate all the functions defined in that file.

I have chosen to customise Micro, far away from the defaults:

- Launch Micro using a batch file, to set title and use a local home directory (not ~/.config/micro ). 
- Custom key bindings that _click_ in my mind, but don't all work directly with the windows console. 
- Autohotkey to translate some key chords so they are recognised by both the windows console and Micro.  
- External tools, some of which are Windows only.

These customisations are only possible thanks to the giants who's shoulders I have stood upon! 
I have tried to acknowledge the sources of code in my script - please let me know if I have missed you out.

Before presenting my changes, a word about plugins - I feel there is a valid case against plugins:

- I don't like it when plugins overwrite my keyboard shortcuts. 
- I don't want to install/learn git. 
- I don't want to load any code I don't understand. 
- All my Lua is in one file - init.lua.

# Custom files
Each file in this repository is annotated and should explain what is happening.

The directory structure is important so my script can find files when necessary

````
editor
|   micro.bat
|   micro.exe
|   micro.ahk
|
+---confMicro
|   |   bindings.json
|   |   init.lua
|   |   lua.lua
|   |   settings.json
|   |
|   +---colorschemes - only additions or modifications
|   |       gmh.micro
|   |       gmh_blue.micro
|   |       gmh_light.micro
|   |
|   +---favorites
|   |       commands.txt
|   |       files.txt
|   |       lua.txt
|   |       recent.txt
|   |       recent.txt.tmp
|   |       shell.txt
|   |       textfilter.txt
|   |
|   +---help  - only additions or modifications
|   |       actions.md
|   |       bat.md
|   |       bookmark.md
|   |       defaults.md
|   |       fzf.md
|   |       keys.md
|   |       linter.md
|   |       loc.md
|   |       lsp.md
|   |       lua.md
|   |       regex.md
|   |       replace.md
|   |
|   +---history
|   |       cd.fzf
|   |       cmd.fzf
|   |       com.fzf
|   |       find.fzf
|   |       findinfiles.fzf
|   |       fzf.fzf
|   |       goto.fzf
|   |       help.fzf
|   |       ins.fzf
|   |       key.fzf
|   |       lines.fzf
|   |       lines.lua
|   |       lua.fzf
|   |       open.fzf
|   |       ref.fzf
|   |       shell.fzf
|   |       snip.fzf
|   |       tem.fzf
|   |       textfilter.fzf
|   |       zback.fzf
|   |
|   +---syntax - only additions or modifications
|   |       bat.yaml
|   |       html.yaml
|   |       Readme.txt
|   |       sqlite.yaml
|   |       text.yaml
|   |
|   \---zBackup
````

# Custom key bindings
For Windows many of these key bindings will not work without Autohotkey, which translates them into alternatives recognised by both the console and Micro. 

In my trials of many editors, there are some editing actions and shortcuts I find useful, so I have adopted them.

### Moving - local to cursor

| Actions______________ | Keys_________________ |
| :-------------------- | :-------------------- |
| Move Word Left        | Ctrl_Left             |
| Move Word Right       | Ctrl_Right            |
| BOL                   | Ctrl_B, Home          |
| EOL                   | Ctrl_E, End           |
| Up Line               | Up                    |
| Down Line             | Down                  |
| Up Full Page          | PgUp                  |
| Down Full Page        | PgDn                  |
| BOF                   | Ctrl_Home             |
| EOF                   | Ctrl_End              |
| Jump Brackets         | Ctrl_J                |
| Goto Line Number      | Ctrl_G                |
| GoForwards Regex-i    | Ctrl_]                |
| GoBackwards Regex-i   | Ctrl_[                |

### Selecting

| Actions______________ | Keys_________________ |
| :-------------------- | :-----------------    |
| Select All            | Ctrl_A                |
| Select Word           | Ctrl_Space            |
| Select Word Back      | Ctrl_Shift_Space      |
| Select BOL            | Ctrl_Shift_B, S_Home  |
| Select EOL            | Ctrl_Shift_E, S_End   |
| Select Line(s) Down   | Ctrl_L                |
| Select Line(s) Up     | Ctrl_Shift_L          |
| Select Inner          | Ctrl_Shift_I          | 
| Select Outer          | Ctrl_Shift_J          | 
| SelectForwards Regex-i | Ctrl_Shift_]         | 
| SelectBackwards Regex-i| Ctrl_Shift_[         | 
| Swap Anchor<>Caret    | Ctrl_-                |

### Basic editing actions

| Actions______________ | Keys_________________ |
| :-------------------- | :-----------------    |
| Delete Word Left      | Ctrl_Bksp             |
| Delete Word Right     | Ctrl_Del              |
| Delete to EOL         | Ctrl_K                |
| Delete to BOL         | Ctrl_Shift_K          |
| Delete Line(s)        | Ctrl_Y                |
| Insert Line Break     | Enter                 |
| Add Line Above        | Ctrl_Enter            |
| Add Line Below        | Shift_Enter           | 
| Move Line(s) Up       | Ctrl_Shift_Up         |
| Move Line(s) Down     | Ctrl_Shift_Down       |
| Duplicate Line(s)     | Ctrl_D                |
| Indent Line(s)        | Ctrl_Shift_>          |
| Outdent Line(s)       | Ctrl_Shift_<          |
| Undo                  | Ctrl_Z                |
| Undoundo              | Ctrl_Shift_Z          |
| Autocomplete Word     | Ctrl_/                |
| Toggle Comments       | Ctrl_Q                |
| Toggle WordWrap       | Ctrl_Shift_W          |

### Clipboard Actions

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Cut                   | Ctrl_X                |
| CutAppend             | Ctrl_Shift_X TODO     |
| Copy                  | Ctrl_C                |
| CopyAppend            | Ctrl_Shift_C TODO     |
| Paste                 | Ctrl_V                |
| PastePlain            | Ctrl_Shift_V          |

### Searching

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Find Forward          | Ctrl_F                |
| Find Word             | Ctrl_*                |
| Find Regex            | Ctrl_Shift_F          |
| Find in Files         | Ctrl_Alt_F            |
| Next Find             | Ctrl_Down             |
| Prev Find             | Ctrl_Up               |
| Replace               | Ctrl_H                |
| Replace All           | Ctrl_Shift_H          |
| Mark all              | Ctrl_M                |
| UnMark all            | Ctrl_U                |

### Navigating

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Goto Line             | Ctrl_G                |
| Toggle Bookmark       |  TODO                 |
| Next Bookmark         |  TODO                 |
| Prev Bookmark         |  TODO                 |
| Next File             | Ctrl_Tab              |
| Prev File             | Ctrl_Shift_Tab        |
| Open Selection        | Ctrl_Shift_O          |

### File commands

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| File New Tab          | Ctrl_N                |
| File New Window       | Ctrl_Alt_N            |
| File Save             | Ctrl_S                |
| File Revert           | Ctrl_R   Broken and dissabled             | 
| File Print            | Ctrl_P                |
| File Close            | Ctrl_W                |
| File Spell Check      | Ctrl_F7               |
| File Backup           | Ctrl_Alt_B            |
| File Run              | Ctrl_Alt_R            |
| Run  Makeit.bat       | Ctrl_Alt_M            |
| Open Todo.txt         | Ctrl_Alt_T            |

### Dialog boxes

There are some instances where a clickable dialog box can be very useful.
(Uses extrnal tools from https://www.robvanderwoude.com/dialogboxes.php)

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| File Open DLG         | Ctrl_O                |
| File Insert DLG       | Ctrl_I                |
| File Save As  DLG     | Ctrl_Shift_S          |

### Multicursors

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Multicursor Up        | Ctrl_Shift_U          |
| Multicursor Down      | Ctrl_Shift_D          |
| Multicursor Next      | Ctrl_Shift_N          |
| Multicursor Skip Next | Ctrl_Shift_P          |
| Multicursor Remove Last | Ctrl_Shift_R        |
| Multicursor Edit All  | Ctrl_Shift_A   TODO       |
| Multicursor Edit Found | Ctrl_Shift_G  TODO       |
| Multicursor Remove All | Ctrl_Shift_Q         |
| Prefix Lines          | Alt_[                 |
| Postfix Lines         | Alt_]                 |

### Folding

TODO Micro won't fold yet!

| Actions______________ | Keys_________________ | 
| :---                  | :---                  |
| Toggle Fold All       | Ctrl_Alt_Z            |
| Expand Fold Section   | Ctrl_Alt_Right        |
| Collapse Fold Section | Ctrl_Alt_Left         |
| Move Next Fold        | Ctrl_Alt_Down         |
| Move Prev Fold        | Ctrl_Alt_Up           |

### Splitting Screens

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Current Split Right   | F8                    |
| Current Split Below   | F7                    |
| Close Split Right     | Shift_F8              |
| Close Split Below     | Shift_F7              |
| New Window Right      | Alt_F8                |
| New Window Below      | Alt_F7                |
| Move to Frame Down    | Alt_Down              |
| Move to Frame Up      | Alt_Up                |
| Move to Frame Left    | Alt_Left              |
| Move to Frame Right   | Alt_Right             |

### Mode Selection

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Command Mode          | Ctrl_:                |
| Shell Mode            | Ctrl_#                |
| Textfilter Mode       | Ctrl_@                |
| Lua Mode              | Ctrl_=                |

### LSP Actions 

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| CompleteWord          | Ctrl_/                | 
| Format                |  TODO                 | TODO 
| Definition            |  TODO                 | TODO
| Find TAGS             |  TODO                 | TODO
| Make TAGS             |  TODO                 | TODO

### FZF as an alternative interface

Fuzzy finder is a fantastic piece of software. There is enough power to replace almost all user interface widgets. I have implemented many functions with unmodified fzf.exe, using helpers such as bat.exe, findstr.exe and grep.exe.

It is helpful to use a different colour scheme for the fzf screens to aid in context switching. When fzf is active it has it's own keybindings.

- TBC - default bindings

Fzf has its own syntax to control filtering:

-   ^ matches pattern at the beginning  (START)
-   $ matches pattern at the end        (END)
-   ' literal search pattern            (EXACT) 
-   ! exclude search pattern            (NOT)
-   | alternate search pattern          (OR)
-   Space for multiple patterns         (AND)

Terms are separated by spaces - not sure braces work.

#### Keybindings list

A searchable list of keybindings, this is great method to increase discoverability:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Keybindings FZF       | Alt_K                 |
| Edit default keybinds | Alt_Shift_K           |

#### Command list

Powerful editors have command lines, this list includes annotations about the commands, merged with the command history:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Default command bar   | Ctrl_:                |
| Commands FZF          | Alt_:                 |
| Edit Command lists    | Alt_Shift_:           |

#### Goto list

This allows plain text searching of the current file, and then navigates to the selected position (you can also search for a line number).

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Goto text FZF         | Alt_G                 |

#### Goto previous list

Keeping a log of editing locations during a session, allows easy backtracking.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Previous location FZF | Alt_P                 |

#### Goto found list

Entering a target string filters the current file, then additional plain text searching is done using FZF.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Find FZF              | Alt_F                 |
| Find Regex FZF        | Alt_Shift_F           |
| Find in files FZF     | Alt_Ctrl_F            |

#### Goto buffer list

Switching between open buffers needs to be as painless as possible. This list includes open windows, recent files and favourites:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Window list FZF       | Alt_W                 |
| Edit favourite list   | Alt_Shift_W           |

#### Open file list

This is one area where FZF shines. Using the current buffer path as proxy for the project domain, let the file finding begin:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| File list FZF         | Alt_O                 |
| Edit favourites list  | Alt_Shift_O           |

#### Open backup list

This works best for locally stored versions sharing similar filenames. e.g. 2023_09_23_67465_Filename.ext

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Backup list FZF       | Alt_B                 |
| Explore backups       | Alt_Shift_B           |

#### Open help list

I like to keep local copies of the runtime help files, add my own MarkDown files, and use [cheatsheets[(https://github.com/terokarvinen/micro-cheat):

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Help list FZF         | Alt_H                 |
| Edit help file FZF    | Alt_Shift_H           |

#### Diff against list

This works best for locally stored versions sharing similar filenames. e.g. 2023_09_23_67465_Filename.ext

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Diff target list FZF  | Alt_D                 |
| Edit target location  | Alt_Shift_D           |

#### Insert file list

Insert file/filename from project:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Insert file list FZF  | Alt_I                 |
| Insert filename  FZF  | Alt_Shift_I           | 

#### Insert unique word list

Select complete words from the current open buffer, can help avoid typos in variable names:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Word list FZF         | Alt_U                 | 

#### Insert line list

A list of useful annotated one liners, by file type: 

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Line list FZF         | Alt_L                 |
| Edit lines            | Alt_Shift_L           |

#### Insert template list

From a selection of template files.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Template list FZF     | Alt_T                 |
| Edit templates        | Alt_Shift_T           |

#### Insert snippet list

From a selection of snippets.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Snippet list FZF      | Alt_S                 |
| Edit Snippets         | Alt_Shift_S           |

#### Shell command list

This list includes saved shell commands:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Shell Cmd list FZF    | Alt_#                 |
| Edit favourite list   | Alt_Shift_#           |
| Shell COMSPEC         | Ctrl_Alt_#            |

#### Textfilter command list

This lists saved textfilter commands:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Textfilter list FZF   | Alt_@                 |
| Edit textfilter list  | Alt_Shift_@           |

#### Lua commands

Lua commands may be entered in a command line, or replaced in the text.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Lua Mode              | Ctrl_=                |
| Lua list FZF          | Alt_=                 |
| Edit Lua commands     | Alt_Shift_=           |
| Interpret selection   | Ctrl_Alt_=            |

# External Tools and Files

These are the external tools I use from Micro:

- awk.exe in your path (https://gnuwin32.sourceforge.net/packages/gawk.htm)
- bat.exe in your path (https://github.com/sharkdp/bat)
- cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)
- ctags.exe in your path (https://github.com/universal-ctags/ctags-win32/releases)
- fzf.exe in your path (https://github.com/junegunn/fzf/releases)
- GetPlainText.exe in your path (http://clipdiary.com/getplaintext)
- GrepWin.exe in your path, I'm using Version 1.6.1.519 (https://tools.stefankueng.com/grepWin_cmd.html)
- msgbox.exe in your path (http://claudiosoft.online.fr/msgbox.html)
- openfilebox.exe in your path (https://www.robvanderwoude.com/dialogboxes.php#OpenFileBox)
- SaveFileBox.exe in your path (https://www.robvanderwoude.com/dialogboxes.php#SaveFileBox)
- shelexec.exe in your path (http://www.naughter.com/shelexe.html)
- TextDiff.exe in your path (http://www.angusj.com/delphi/textdiff.html
- tr.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)
- Hunspell.exe in a set location, with dictionaries in a set location. (https://sourceforge.net/projects/ezwinports/files/hunspell-1.3.2-3-w32-bin.zip

I keep the spellchecker (with dictionaries) local to Micro, along with any text files for insertion (Templates,Snippets,Lines of code):

````
editor
|   micro.bat
|   micro.exe
|   micro.ahk
|           
+---confMicro - As above
|   |   ... 
|                  
+---hunspell
|       en_GB.aff
|       en_GB.dic
|       en_GB.usr
|       en_med_glut.dic
|       en_US.aff
|       en_US.dic
|       es_ES.aff
|       es_ES.dic
|       hunspell.bat
|       hunspell.exe
|       hunspell.txt
|       Hunspellx.txt
|       Hunspellx64.dll
|       Hunspellx86.dll
|       libhunspell-1.3-0.dll
|       libiconv-2.dll
|       libintl-8.dll
|       libncurses5.dll
|       libreadline6.dll
|       MadDict.en_GB
|       temp.txt
|       user.dic
|       USER_DICT.aff
|       USER_DICT.dic
|       
+---insertions
|       api
|       api.bat
|       api.html
|       api.lua
|       api.md
|       api.mmd
|       api.sqlite
|       api.txt
|       
+---snippets
|   |   
|   +---html
|   |       image.htm
|   |       table.htm
|   |       
|   +---md
|   |       toc.md
|   |       
|   \---mmd
|           table.mmd
|           toc.md
|           
\---templates
        default.awk
        default.bat
        default.cpp
        default.css
        default.gsl
        default.hta
        default.htm
        default.html
        default.ico
        default.java
        default.js
        default.jsp
        default.lsp
        default.md
        default.mmd
        default.php
        default.pl
        default.py
        default.rb
        default.sqlite
        default.tex
        default.vbs
        default.wsf
        default.xml
````

Additionally, above my ````editor```` folder I have a ````help```` folder full of files, including a download from [micro-cheat](https://github.com/terokarvinen/micro-cheat/tree/main/cheatsheets).

---

I am not a git user, so all the files have been dragged and dropped into the repository. Happy to discuss the contents, no idea how to accept pull requests!

Kind Regards Gavin Holt 

