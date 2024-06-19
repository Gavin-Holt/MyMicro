# Universal Keyboard Shortcuts (UKS)
## Introduction

Instead of learning and re-learning keyboard shortcuts I am "_on an mission_" to force all my editors to respond to the same keystrokes.

This may sound a little limiting, and there are some actions I cannot achieve in some software. However, using some tricks most things are possible:

* Use Autohotkey to translate keyboard/mouse input for each target program.
* Use Reshacker to change PE executable keyboard accelerators.
* Use the scripting capabilities of each target program.
* Call external tools for some advanced actions (fzf, bat.exe, findstr, winGREP)

## Actions and Workflow

I don't hate the mouse, but lots of clicking makes my pisiform bone hurt!

In my trials of many editors, there are some editing actions I find so useful I have adopted them.

My brain can't grok vi(m) or other modal editors. But I do love fzf.exe and use it as an interface (see below)

### Moving - local to cursor

| Actions______________ | Keys_________________ |
| :-------------------- | :-------------------- |
| Move Word Left        | Ctrl_Left             |
| Move Word Right       | Ctrl_Right            |
| Jump Brackets         | Ctrl_J                |
| BOL                   | Ctrl_B, Home          |
| EOL                   | Ctrl_E, End           |
| Up Line               | Up                    |
| Down Line             | Down                  |
| Up Full Page          | PgUp                  |
| Down Full Page        | PgDn                  |
| BOF                   | Ctrl_Home             |
| EOF                   | Ctrl_End              |

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
| Select Inner          | Ctrl_Shift_I          | TODO micro
| Select Outer          | Ctrl_Shift_J          | TODO micro
| Swap Anchor<>Caret    | Ctrl_Shift_T          |

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
| Autocomplete*         | Ctrl_/                |
| Duplicate Line(s)     | Ctrl_D                |
| Indent Line(s)        | Ctrl_Shift_>          |
| Outdent Line(s)       | Ctrl_Shift_<          |
| Undo                  | Ctrl_Z                |
| Undoundo              | Ctrl_Shift_Z          |
| Toggle Comments       | Ctrl_Q                |
| Toggle Line Numbers   | Ctrl_Shift_N          |
| Toggle WordWrap       | Ctrl_Shift_W          |

### Clipboard Actions

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Cut                   | Ctrl_X                |
| CutAppend             | Ctrl_Shift_X          |
| Copy                  | Ctrl_C                |
| CopyAppend            | Ctrl_Shift_C          |
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
| Next File             | Ctrl_Tab              |
| Prev File             | Ctrl_Shift_Tab        |
| Open Selection        | Ctrl_Shift_O          |

### File commands

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| File New Tab          | Ctrl_N                |
| File New Window       | Ctrl_Alt_N            |
| File Save             | Ctrl_S                |
| File Revert           | Ctrl_R                |
| File Print            | Ctrl_P                |
| File Close            | Ctrl_W                |
| File Backup           | Ctrl_Alt_B            |
| File Makeit           | Ctrl_Alt_M            |
| File Run              | Ctrl_Alt_R            |
| File Spell Check      | Ctrl_F7               |

### Dialog boxes

There are some instances where a clickable dialog box can be very useful.

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
| Multicursor Skip      | Ctrl_Shift_P          |TODO
| Multicursor Edit All  | Ctrl_Shift_A          |TODO
| Multicursor Remove    | Ctrl_Shift_R          |
| Multicursor Remove All | Ctrl_Shift_Q         |
| Prefix                | Ctrl_[                |
| Postfix               | Ctrl_]                |

### Folding

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

This is for my mmicro editor

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Command Mode          | Ctrl_:                |
| Shell Mode            | Ctrl_#                |
| Textfilter Mode       | Ctrl_@                |
| Lua Mode              | Ctrl_=                |

### LSP Actions TODO:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| CompleteWord          | Ctrl_/                |
| Find TAGS             | Ctrl_T                |
| Make TAGS             | Ctrl_Shift_T          |

### FZF as an alternative interface

Fuzzy finder is a fantastic piece of software. There is enough power to replace almost all user interface widgets. As an exercise I have attempted to drive suitable editor(s) almost exclusively using unmodified fzf with helpers such as bat.exe, findstr.exe and grep.exe.

It is helpful to use a different colour scheme for the fzf screens to aid in context switching. When fzf is active it has it's own keybindings:

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

This allows plain text searching of the current file, and then navigates to the selected position.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Goto text FZF         | Alt_G                 |

#### Goto previous list

Keeping a log of editing locations during a session, allows easy backtracking.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Previous location FZF | Alt_P                 |

#### Goto found list

Entering a target filters the current file, then additional plain text searching is done using FZF.

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
| Edit project list     | Alt_Shift_O           |

#### Open backup list

This works best for locally stored versions sharing similar filenames. e.g. 2023_09_23_67465_Filename.ext

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Backup list FZF       | Alt_B                 |
| Explore backups       | Alt_Shift_B           |

#### Open help list

I like to keep local copies of the runtime help files, add my own MarkDown files, and use the helpsheets:

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

A list of unique words from the current open buffer, can help avoid typos in variable names:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Word list FZF         | Alt_U                 |

#### Insert line list

A list of useful annotated one liners, by file type:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Line list FZF         | Alt_L                 |
| Edit lines            | Alt_Shift_L           |

#### Insert reference list

I have a script to extract citations from files, and insert as MarkDown footnotes.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Reference list FZF    | Alt_R                 |
| Edit References       | Alt_Shift_R           |

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

This list includes recent shell commands and favourites:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Shell Cmd list FZF    | Alt_#                 |
| Edit favourite list   | Alt_Shift_#           |
| Shell COMSPEC         | Ctrl_Alt_#            |

#### Pipe command list

This list includes recent pipe (textfilter) commands:

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Textfilter list FZF   | Alt_@                 |
| Edit textfilter list  | Alt_Shift_@           |

#### Macro list

This list includes recent saved macros.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Macro list FZF        | Alt_M                 |
| Edit macros FZF       | Alt_Shift_M           |

#### Lua commands

Lua commands may be entered in a command line, or replaced in the text.

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Lua Mode              | Ctrl_=                |
| Lua list FZF          | Alt_=                 |
| Edit Lua commands     | Alt_Shift_=           |
| Interpret selection   | Ctrl_Alt_=            |

## Function List - Micro

| Keys_________________ | Command(s)_______________________________________ |
| :-------------------- | :------------------------------------------------ |
| ^ A                   | SelectAll                                         |
| ^ B                   | StartOfLine                                       |
| ^ C                   | Copy                                              |
| ^ D                   | DuplicateLine,StartOfLine                         |
| ^ E                   | EndOfLine                                         |
| ^ F                   | FindLiteral                                       |
| ^ G                   | command-edit:goto                                 |
| ^ H                   | command-edit:replace                              |
| ^ I                   | lua:initlua.insertorfzf                           |
| ^ J                   | JumpToMatchingBrace                               |
| ^ K                   | SelectToEndOfLine,Delete                          |
| ^ L                   | lua:initlua.selectline                            |
| ^ M                   | lua:initlua.selectword,lua:initlua.findselected   |
| ^ N                   | AddTab                                            |
| ^ O                   | lua:initlua.openfiledlg                           |
| ^ P                   |                                                   |
| ^ Q                   | Comment                                           |
| ^ R                   | Revert                                            |
| ^ S                   | Save                                              |
| ^ T                   | FindTAGS                                          |
| ^ U                   | UnmarkAll                                         |
| ^ V                   | Paste                                             |
| ^ W                   | Close                                             |
| ^ X                   | Cut                                               |
| ^ Y                   | Yank                                              |
| ^ Z                   | Undo                                              |
| + A                   |                                                   |
| + B                   | FZFOpenBackup                                     |
| + C                   | FZFCommandList                                    |
| + D                   | FZFDiffTarget                                     |
| + E                   |                                                   |
| + F                   | FZFFind                                           |
| + G                   | FZFGoto                                           |
| + H                   | FZFHelp                                           |
| + I                   | FZFInsertFile                                     |
| + J                   |                                                   |
| + K                   | FZFKeybindings                                    |
| + L                   | FZFInsertLine                                     |
| + M                   | FZFRunMacro                                       |
| + N                   |                                                   |
| + O                   | FZFOpenFile                                       |
| + P                   | FZFPreviousLocation                               |
| + Q                   |                                                   |
| + R                   | FZFInsertReference                                |
| + S                   | FZFInsertSnippet                                  |
| + T                   | FZFInsertTemplate                                 |
| + U                   | FZFInsertUniqueWord                               |
| + V                   |                                                   |
| + W                   | FZFOpenWindow                                     |
| + X                   |                                                   |
| + Y                   |                                                   |
| + Z                   |                                                   |
| + #                   | FZFShellCommand                                   |
| + |                   | FZFPipeCommand                                    |
| + =                   | FZFLuaCommand                                     |
| ^ Space               | AHK: "F21": "lua:initlua.selectword"              |
| ^+A                   | MulticursorAll                                    |
| ^+B                   | SelectToBOL                                       |
| ^+C                   | CopyAppend                                        |
| ^+D                   | MulticursorDown                                   |
| ^+E                   | SelectToEOL                                       |
| ^+F                   | FindRegex                                         |
| ^+G                   | FilterGoto                                        |
| ^+H                   | command-edit:replaceall                           |
| ^+I                   | EditInsertions                                    |
| ^+J                   | lua:initlua.selectinner                           |
| ^+K                   | Kill to BOL                                       |
| ^+L                   |                                                   |
| ^+M                   |                                                   |
| ^+N                   | MulticursorNext                                   |
| ^+O                   | OpenSelection                                     |
| ^+P                   |                                                   |
| ^+Q                   | Uncomment                                         |
| ^+R                   |                                                   |
| ^+S                   | FileSaveAs                                        |
| ^+T                   | SwapAnchor                                        |
| ^+U                   | MulticursorUp                                     |
| ^+V                   | PastePlainText                                    |
| ^+W                   | ToggleWordWrap                                    |
| ^+X                   | CutAppend                                         |
| ^+Y                   |                                                   |
| ^+Z                   | UndoUndo                                          |
| ^!A                   |                                                   |
| ^!B                   | MakeBackup                                        |
| ^!C                   |                                                   |
| ^!D                   |                                                   |
| ^!E                   |                                                   |
| ^!F                   |                                                   |
| ^!G                   |                                                   |
| ^!H                   |                                                   |
| ^!I                   | InsertFileFzF                                     |
| ^!J                   |                                                   |
| ^!K                   |                                                   |
| ^!L                   |                                                   |
| ^!M                   |                                                   |
| ^!N                   |                                                   |
| ^!O                   | OpenFzF                                           |
| ^!P                   |                                                   |
| ^!Q                   |                                                   |
| ^!R                   | RunFile                                           |
| ^!S                   | InsertSnippetFzf                                  |
| ^!T                   | InsertTemplateFzf                                 |
| ^!U                   |                                                   |
| ^!V                   | OpenBackupFzf                                     |
| ^!W                   |                                                   |
| ^!X                   |                                                   |
| ^!Y                   |                                                   |
| ^!Z                   |                                                   |
| F7                    | SplitRight                                        |
| ^\                    |                                                   |
| ^-                    |                                                   |
| ^=                    | LuaEval                                           |
| ^[                    | MulticursorPrefix                                 |
| ^]                    | MulticursorPostfix                                |
| ^;                    |                                                   |
| ^'                    |                                                   |
| ^#                    |                                                   |
| ^,                    |                                                   |
| ^.                    |                                                   |
| ^/                    |                                                   |
| ^+Space               | AHK: "F22": "lua:initlua.selectwordback"          |
| ^+\                   |                                                   |
| ^+-                   |                                                   |
| ^+=                   | LuaREPL                                           |
| ^+[                   |                                                   |
| ^+]                   |                                                   |
| ^+;                   |                                                   |
| ^+'                   |                                                   |
| ^+#                   | TextFilter                                        |
| ^+,                   |                                                   |
| ^+.                   |                                                   |
| ^+/                   |                                                   |
| ^!-                   |                                                   |
| ^!=                   |                                                   |
| ^![                   |                                                   |
| ^!]                   |                                                   |
| ^!;                   |                                                   |
| ^!'                   |                                                   |
| ^!#                   |                                                   |
| ^!,                   |                                                   |
| ^!.                   |                                                   |
| ^!/                   |                                                   |
| {Esc}                 |                                                   |
| {Tab}                 | Indent                                            |
| {Space}               |                                                   |
| {Delete}              |                                                   |
| {BackSp}              |                                                   |
| {Enter}               |                                                   |
| ^{Tab}                | SwitchWindow                                      |
| ^{Space}              | SelectWord                                        |
| ^+{Space}             | SelectWordBack                                    |
| ^{Delete}             | DeleteWordRight                                   |
| ^{BackSp}             | DeleteWordLeft                                    |
| ^{Enter}              | AHK::Send {End}{Enter}                            |
| +{Enter}              | AHK::Send {Home}{Enter}{Up}                       |
| ^*                    | WordSearch                                        |
| !/                    |                                                   |
| !{Esc}                | SwitchApp                                         |
| !{Tab}                | SwitchApp                                         |
| !{Space}              | ControlMenu                                       |
| !{Delete}             |                                                   |
| !{BackSp}             |                                                   |
| !{Enter}              | FullScreen                                        |
| ^!{Esc}               |                                                   |
| ^!{Tab}               |                                                   |
| ^!{Space}             |                                                   |
| ^!{Delete}            |                                                   |
| ^!{BackSp}            |                                                   |
| ^!{Enter}             |                                                   |
| F1                    | Built-in Help                                     |
| + F1                  | Load keysheet                                     |
| ^ F1                  | Load helpsheet                                    |
| # F1                  | Run help app                                      |
| ^ F7                  | Spellcheck                                        |

## Function List - Focus

| Keys_________________  | Command(s)_______________________________________________________________________ |
| :--------------------  | :---------------------------------------------------------------------------------|
| Ctrl-A                 |     select_all|
| Ctrl-B                 |     jump_to_line_start|
| Ctrl-C                 |     copy|
| Ctrl-D                 |     duplicate_lines|
| Ctrl-E                 |     jump_to_line_end|
| Ctrl-F                 |     search_in_buffer_dropdown_mode|
| Ctrl-G                 |     go_to_line|
| # Ctrl-H               |     # Replace|
| # Ctrl-I               |     # Insert file|
| # Ctrl-J               |     # Jump brace|
| Ctrl-K                 |     delete_to_end_of_line # I don't want copy|
| Ctrl-L                 |     select_line|
| # Ctrl-M               |     # Mark all - redundant in Focus|
| Ctrl-N                 |     create_new_file|
| Ctrl-O                 |     show_open_file_dialog_in_navigate_mode|
| # Ctrl-P               |     # Print|
| Ctrl-Q                 |     toggle_comment|
| # Ctrl-R               |     # Revert to disk copy|
| Ctrl-S                 |     save|
| # Ctrl-T               |     # Find TAGS|
| # Ctrl-U               |     # Unmark all - redundant in Focus|
| Ctrl-V                 |     paste|
| Ctrl-W                 |     close_current_editor            # Does not prompt to save until quit|
| Ctrl-X                 |     cut|
| Ctrl-Y                 |     delete_line                     # Or line(s)|
| Ctrl-Z                 |     undo|
| # Ctrl-Shift-A         |     # Multi_Cursor_edit_all|
| # Ctrl-Shift-B         |     # Select to BOL|
| # Ctrl-Shift-C         |     # Copy Append|
| Ctrl-Shift-D           |     create_cursor_below|
| # Ctrl-Shift-E         |     # Select to EOL|
| # Ctrl-Shift-F         |     # Regex find|
| Ctrl-Shift-G           |     search_in_buffer_dropdown_mode|
| # Ctrl-Shift-H         |     # replace all|
| # Ctrl-Shift-I         |     # empty|
| # Ctrl-Shift-J         |     select brace contents|
| Ctrl-Shift-K           |     delete_to_start_of_line         # I don't want copy|
| # Ctrl-Shift-L         |     # Select line above|
| # Ctrl-Shift-M         |     # Select inner|
| Ctrl-Shift-N           |     select_word_or_create_another_cursor|
| # Ctrl-Shift-O         |     # Open selected filename|
| # Ctrl-Shift-P         |     # empty|
| # Ctrl-Shift-Q         |     # empty|
| # Ctrl-Shift-R         |     # Remove last cursor|
| Ctrl-Shift-S           |     save_as|
| # Ctrl-Shift-T         |     # Make TAGS|
| Ctrl-Shift-U           |     create_cursor_above|
| # Ctrl-Shift-V         |     # Paste Plain Text|
| Ctrl-Shift-W           |     toggle_line_wrap|
| # Ctrl-Shift-X         |     # Cut Append|
| # Ctrl-Shift-Y         |     # empty|
| Ctrl-Shift-Z           |     redo|
| # Ctrl-ArrowUp         |     # Repeat search Up|
| # Ctrl-ArrowDown       |     # Repeat search Down|
| # Ctrl-[               |     add_cursors_to_line_starts|
| # Ctrl-]               |     add_cursors_to_line_ends|
| # Ctrl-#               |     # run shell command and display in output|
| # Ctrl-Shift-#         |     # pipe selected text to shell command and over paste with results e.g. sed awk sort|
| Ctrl-Shift-ArrowUp     |     move_selected_lines_up|
| Ctrl-Shift-ArrowDown   |     move_selected_lines_down|
| # Ctrl-Alt-B           |     # Make backup|
| # Ctrl-Alt-D           |     # Diff file - after selecting comparitor|
| Ctrl-Alt-F             |     search_in_project|
| # Ctrl-Alt-G           |     # A fzf list of recent editing locations would be better|
| # Ctrl-Alt-H           |     # Replace in files|
| # Ctrl-Alt-I           |     # fzf insert file from project|
| # Ctrl-Alt-O           |     # fzf open file from project|
| # Ctrl-Alt-R           |     # Shellexec current file - save first|
| # Ctrl-Alt-S           |     # fzf insert file from snippets|
| # Ctrl-Alt-T           |     # fzf insert file from templates|
| # Ctrl-Alt-V           |     # Open backup (version)|
| # Ctrl-Alt-#           |     # Open COMSPEC|
| # Escape               |     quit                            # Unfortunately dismissing command list will quit!|
| Alt-F4                 |     quit|
| Enter                  |     break_line|
| Ctrl-Enter             |     new_line_below_without_breaking|
| Ctrl-Shift-Enter       |     new_line_above_without_breaking|
| Tab                    |     indent_or_go_to_next_tabstop|
| Shift-Tab              |     unindent|
| Ctrl-Tab               |     move_to_previous_buffer|
| Ctrl-Shift-Tab         |     move_to_next_buffer|
| Ctrl-.                 |     indent                          # Ctrl->|
| Ctrl-,                 |     unindent                        # Ctrl-<|
| Escape                 |     remove_additional_cursors|
| Alt-C                  |     remove_additional_cursors|
| # Alt-I                |     fzf select and insert a line from library (by file type)|
| Alt-L                  |     toggle_line_numbers|
| Alt-W                  |     show_open_file_dialog_in_search_mode|
| # Alt-Shift-I          |     # Edit library (by file type)|
| Alt-ArrowLeft          |     switch_to_left_editor|
| Alt-ArrowRight         |     switch_to_right_editor|
| F8                     |     duplicate_editor|
| Alt-F8                 |     create_new_file_on_the_side|
| F9                     |     show_commands|
| F10                    |     quit|


| # Functions not used|
| |
| |
| # Ctrl-Tab                    autoindent_region|
| # Ctrl-J                      join_lines|
| # Ctrl-Shift-J                join_lines_no_spaces_in_between|
| |
| # Alt-H                       scroll_viewport_left|
| # Alt-J                       scroll_viewport_down|
| # Alt-K                       scroll_viewport_up|
| # Alt-L                       scroll_viewport_right|
| |
| # Alt-E                       scroll_viewport_up_fast           # for some reason Alt-U didn't reach the window at all, so using Alt-E instead|
| # Alt-D                       scroll_viewport_down_fast|
| |
| # Alt-PageUp                  scroll_viewport_up_fast|
| # Alt-PageDown                scroll_viewport_down_fast|
| |
| # Alt-V                       move_cursor_to_viewport_center|
| |
| # Ctrl-Alt-ArrowUp            scroll_viewport_up|
| # Ctrl-Alt-ArrowDown          scroll_viewport_down|
| # Ctrl-Alt-ArrowLeft          scroll_viewport_left|
| # Ctrl-Alt-ArrowRight         scroll_viewport_right|
| |
| # {Shift}-Ctrl-ArrowUp        move_up_to_empty_line|
| # {Shift}-Ctrl-ArrowDown      move_down_to_empty_line|
| |
| # Ctrl-,                      switch_to_other_editor|
| # Ctrl-Alt-Shift-ArrowRight   move_editor_to_the_right|
| |
