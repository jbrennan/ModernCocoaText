##Automatic Parenthesis Insertion and Matching

When any kind of parenthesis style character is inserted (that is, `(`, `[`, and `{` (and optionally `<`)) should have their closing counterparts inserted automatically, with the cursor placed between them. This is to assist the user in typing, and as such some special considerations have to be followed.

1. Inserting an opening brace automatically inserts its counterpart. This happens if and only if the character after the opening brace is either whitespace or nonexistant (i.e., end of line or end of file). Examples

		This is a sentence (	# automatically inserts ) here because it is at the end of a line
	
		This is a (big sentence	# does not insert a matching ) because it comes directly before "big"
	
		This is a ( sentence	# automatically inserts ) because there is a space after it

2. If the pair is empty (like `()`) and the opening brace is deleted, the pair is deleted. If the pair is not empty, then only the opening brace is deleted.

3. If the closing brace is deleted, this behaves like it normally would without the assist (that is, the closing character is the only thing deleted).

4. Pasting does not invoke any of these behaviour.

5. If the cursor is placed in front of a closing brace and that closing brace is typed, the cursor should just move to the other side of the brace and have it remain in place. That is, don't insert another character, just move the cursor along. If the user really wanted to have two of the same characters, they'll just type it again.

##Block Editing

When a block of text is selected and the user types a character, the block of text is typically replaced by whatever has just been typed or pasted in. This is not always what the user has intended. Instead, in some circumstances the selected text should instead be surrounded by the characters and have the selection extended. Examples:

    text	# this is our selected text when the ( key is pressed.
    (text)	# this is the result