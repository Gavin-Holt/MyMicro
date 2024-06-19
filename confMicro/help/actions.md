# Introduction

There was some confusion, in my mind, regarding the difference between ```actions``` , ```commands``` and ```functions`````.

- Actions can be bound directly to keys in ```bindings.json``` and will act at every multicursor.
- Commands are executed from the command bar and parsed _like bash_.

## Actions

* CursorUp
* CursorDown
* CursorPageUp
* CursorPageDown
* CursorLeft
* CursorRight
* CursorStart
* CursorEnd
* SelectToStart
* SelectToEnd
* SelectUp
* SelectDown
* SelectLeft
* SelectRight
* SelectToStartOfText
* SelectToStartOfTextToggle
* WordRight
* WordLeft
* SelectWordRight
* SelectWordLeft
* MoveLinesUp
* MoveLinesDown
* DeleteWordRight
* DeleteWordLeft
* SelectLine
* SelectToStartOfLine
* SelectToEndOfLine
* InsertNewline
* InsertSpace
* Backspace
* Delete
* Center
* InsertTab
* Save
* SaveAll
* SaveAs
* Find
* FindLiteral
* FindNext
* FindPrevious
* DiffPrevious
* DiffNext
* Undo
* Redo
* Copy
* CopyLine
* Cut
* CutLine
* DuplicateLine
* DeleteLine
* IndentSelection
* OutdentSelection
* OutdentLine
* IndentLine
* Paste
* SelectAll
* OpenFile
* Start
* End
* PageUp
* PageDown
* SelectPageUp
* SelectPageDown
* HalfPageUp
* HalfPageDown
* StartOfLine
* EndOfLine
* StartOfText
* StartOfTextToggle
* ParagraphPrevious
* ParagraphNext
* ToggleHelp
* ToggleDiffGutter
* ToggleRuler
* JumpLine
* ClearStatus
* ShellMode
* CommandMode
* Quit
* QuitAll
* AddTab
* PreviousTab
* NextTab
* NextSplit
* Unsplit
* VSplit
* HSplit
* PreviousSplit
* ToggleMacro
* PlayMacro
* Suspend (Unix only)
* ScrollUp
* ScrollDown
* SpawnMultiCursor
* SpawnMultiCursorUp
* SpawnMultiCursorDown
* SpawnMultiCursorSelect
* RemoveMultiCursor
* RemoveAllMultiCursors
* SkipMultiCursor
* None
* JumpToMatchingBrace
* Autocomplete


## Commands

Built-in commands can be bound to keys with the ```command:``` prefix:

* command:log
* command:pwd

If the command needs editing use the  ```command-edit:``` prefix:

* command-edit:help

## Functions 

Can be bound to keys with the ```lua:``` prefix:

 