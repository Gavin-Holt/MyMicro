# Location userdata

## LOC userdata

LOC-pointers are returned from Cursor properties:

-  

LOC-pointers can be __dereferenced__ to become LOC-Structures, using the unary minus operator.

LOC-structures comprise zero based offsets labeled X and Y

````lua
    local column        = Current.Cursor.Loc.X+1
    local row           = Current.Cursor.Loc.Y+1
````

Selections comprise a table of two LOC-structures

````lua
if Current.Cursor:HasSelection() then
    local SelStartLOC   = Current.Cursor.CurSelection[1]
    local SelEndLOC     = Current.Cursor.CurSelection[2]
end
````

Coordinates (Column/row) can be extracted from LOC-Structures, using the X and Y properties e.g.




Also a LOC structure can be created from Lua

````lua
buffer.Loc(x,y)
````

and then passed to cursor functions or properties.


## Changing location and selection after FindNext

This example uses both LOC-structures (match[1] & match[2]) and, unary minus operator to de-reference LOC-pointers (Current.Cursor.CurSelection[1] and Current.Cursor.CurSelection[2]):

````lua
    if found then
        Current.Cursor:SetSelectionStart(match[1])
        Current.Cursor:SetSelectionEnd(match[2])
        Current.Cursor.OrigSelection[1] = -Current.Cursor.CurSelection[1]
        Current.Cursor.OrigSelection[2] = -Current.Cursor.CurSelection[2]
        Current.Cursor:GotoLoc(match[2])
        Current:Relocate()
    end
````