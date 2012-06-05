##Automatic Parenthesis Insertion and Matching

When any kind of parenthesis style character is inserted (that is, `(`, `[`, and `{` (and optionally `<`)) should have their closing counterparts inserted automatically, with the cursor placed between them. This is to assist the user in typing, and as such some special considerations have to be followed.

1. Inserting an opening brace automatically inserts its counterpart. This happens if and only if the character after the opening brace is either whitespace or nonexistant (i.e., end of line or end of file). Examples

		This is a sentence (	# automatically inserts ) here because it is at the end of a line
	
		This is a (big sentence	# does not insert a matching ) because it comes directly before "big"
	
		This is a ( sentence	# automatically inserts ) because there is a space after it

2. If the pair is empty (like `()`) and the opening brace is deleted, the pair is deleted. If the pair is not empty, then only the opening brace is deleted.

3. If the closing brace is deleted, this behaves like it normally would without the assist (that is, the closing character is the only thing deleted).

4. Pasting does not invoke any of these behaviour.