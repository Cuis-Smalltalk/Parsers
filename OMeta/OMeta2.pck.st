'From Cuis 5.0 of 7 November 2016 [latest update: #3329] on 2018-05-23 at 4:59:20 am'!
'Description OMeta2Preload.st needs to be filed in before loading this package

Based on the original work by Alessandro Warth http://www.tinlizzie.org/ometa/OMeta.sar with updates from OMeta2-Preload-hmm.14.mcz OMeta2-Postload-hmm.12.mcz and modified as needed to run in Cuis 4.2 2337 or later.'!
!provides: 'OMeta2' 2 7!
SystemOrganization addCategory: #OMeta2!


!classDefinition: #OMeta2 category: #OMeta2!
OMeta2Base subclass: #OMeta2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2 class' category: #OMeta2!
OMeta2 class
	instanceVariableNames: ''!

!classDefinition: #O2SqueakRecognizer category: #OMeta2!
OMeta2 subclass: #O2SqueakRecognizer
	instanceVariableNames: ''
	classVariableNames: 'TypeTable'
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'O2SqueakRecognizer class' category: #OMeta2!
O2SqueakRecognizer class
	instanceVariableNames: ''!

!classDefinition: #OMeta2Flattener category: #OMeta2!
OMeta2 subclass: #OMeta2Flattener
	instanceVariableNames: 'ws'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2Flattener class' category: #OMeta2!
OMeta2Flattener class
	instanceVariableNames: ''!

!classDefinition: #OMeta2NullOpt category: #OMeta2!
OMeta2 subclass: #OMeta2NullOpt
	instanceVariableNames: 'didSomething'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2NullOpt class' category: #OMeta2!
OMeta2NullOpt class
	instanceVariableNames: ''!

!classDefinition: #OMeta2AndOrOpt category: #OMeta2!
OMeta2NullOpt subclass: #OMeta2AndOrOpt
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2AndOrOpt class' category: #OMeta2!
OMeta2AndOrOpt class
	instanceVariableNames: ''!

!classDefinition: #OMeta2Optimizer category: #OMeta2!
OMeta2 subclass: #OMeta2Optimizer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2Optimizer class' category: #OMeta2!
OMeta2Optimizer class
	instanceVariableNames: ''!

!classDefinition: #OMeta2RuleParser category: #OMeta2!
OMeta2 subclass: #OMeta2RuleParser
	instanceVariableNames: 'temps'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2RuleParser class' category: #OMeta2!
OMeta2RuleParser class
	instanceVariableNames: ''!

!classDefinition: #OMeta2RuleTranslator category: #OMeta2!
OMeta2 subclass: #OMeta2RuleTranslator
	instanceVariableNames: 'grammarClass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2'!
!classDefinition: 'OMeta2RuleTranslator class' category: #OMeta2!
OMeta2RuleTranslator class
	instanceVariableNames: ''!


!OMeta2 commentStamp: '<historical>' prior: 0!
OMeta Implementation

Parser Notes:
========

If your input consists of strings you want to parse (source code, text files, etc.), you most likely want to call the class-side 'MatchAll' methods (i.e. #matchAll:with:).  If your input consists of structured data (nested arrays etc) to parse, you probably want to call the class-side 'Match' methods (i.e. #match:with:).

For more unconventional parsing needs, you will likely need to override some OMeta2Base methods in your parser subclass.  It is highly suggested that you do not change OMeta2Base directly as any bugs or changes in behavior will likely break OMeta2 itself.  Therefore, overriding in your subclass is the recommended approach.

Todos:
====

* implement OMeta -> Squeak translator
* implement Squeak parser
* implement OMeta/Squeak "compiler", make it OMeta2's compilerClass

* rewrite #empty and #firstAndRest in OMeta syntax
* consider implementing position-related functionality (see http://www.tinlizzie.org/ometa-js/ometa-base.js)
* consider the optimization suggestions in the comments of OMeta2Lib's methods!

!O2SqueakRecognizer commentStamp: '<historical>' prior: 0!
OMeta implementation!

!OMeta2Flattener commentStamp: '<historical>' prior: 0!
OMeta2Flattener is phase 4 of OMeta code compilation.  I take the rendered code tree produced by phase 3 and flatten it into a single string of source code that will be passed to the Smalltalk compiler or parser.

OMeta implementation!

!OMeta2NullOpt commentStamp: '<historical>' prior: 0!
Base syntax tree grammar to perform code transformations. Currrently not used directly as its subclass, OMeta2AndOrOpt, is called during phase 2.

OMeta implementation!

!OMeta2AndOrOpt commentStamp: '<historical>' prior: 0!
Syntax tree grammar used by OMeta2Optimizer in stage 2 of compilation.

OMeta implementation!

!OMeta2Optimizer commentStamp: '<historical>' prior: 0!
OMeta2Optimizer is phase 2 of OMeta code compilation.  I take the parse tree from phase 1 and apply an syntax tree grammar (OMeta2AndOrOpt) which looks for any obvious and/or transformations to produce a simplified syntax tree.

fixme - clean up comment.

OMeta implementation!

!OMeta2RuleParser commentStamp: '<historical>' prior: 0!
OMeta2RuleParser is phase 1 of OMeta code compilation.  I take arbitrary source code and produce an syntax tree of raw operations in a Lispy nested list containing elements in the form #(arg1. arg2...) where:

arg1 is the OMeta primitive to perform (#Act, #And, #App, #ConsBy, #Form, #IdxConsBy, #Opt, #Or, #Lookahead, #Many, #Many1, #Not, #Pred, #Rule, #Set, #SuperApp) each corresponding to an OMeta primitive operation:
- #And and #Or correspond to Smalltalk #and: and #or:
- #Act and #Rule indicate a method call defined in arg2
- #Set indicates a collection (implemented as an array)
- #App, #ConsBy, #Form, #IdxConsBy, #Opt, #Lookahead, #Many, #Many1, #Not, #Pred and #SuperApp have corresponding methods in OMeta2Base

arg2 is either an operand for the atomic operation (an OMeta or application rule name or semantic predicate/action code snippet) or a list of child operations in the case of #And and #Or operations.

arg3, if it exists, is either an operand for the atomic operation (often an operand for the rule supplied in arg2 such as a string literal) or a list of child operations.

And so on... arg4 and greater occur in more complex #And and #Or lists or for rules/method calls requiring additional parameters passed.

The syntax tree produced represents the worst case application logic as no optmization is performed yet.  Stages 2 and 3 require this simple form to perform their transformations. (i.e. any changes/extensions here will have significant implications downstream)

OMeta implementation!

!OMeta2RuleTranslator commentStamp: '<historical>' prior: 0!
OMeta2RuleTranslator is phase 3 of OMeta code compilation.  I take the parse tree from phase 1 or 2 and translate it to a list-based tree containing rendered Smalltalk code snippets.

OMeta implementation!

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:23'!
char =

	anything:x ?[x isKindOf: Character] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:24'!
digit =

	char:x ?[x isDigit] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 6/11/2015 02:12'!
fromToEnd :from =
	// fixme - broken
	/* Match the sequence :from to either the end of line or the input stream.  Example to match a comment: fromToEnd("//"):commentText
	fixme - if 2nd param could be made optional and default to lf, this rule would be usable by any type of object */
	//[Character newLineCharacter asString]:eol seq(from) (~seq(eol) anything)*:t (seq(eol) | end) -> [t]
	[Character newLineCharacter asString]:to fromToOrEnd(from. to)! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:28'!
letter =

	char:x ?[x isLetter] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:28'!
letterOrDigit =

	char:x ?[x isAlphaNumeric] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:30'!
lower =

	char:x ?[x isLowercase] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:32'!
space =

	char:x ?[x asciiValue <= 32] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:33'!
spaces =

	space*! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:34'!
string =

	anything:x ?[x isString] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:34'!
token :t =

	spaces seq(t)! !

!OMeta2 methodsFor: 'ometa grammar - text' stamp: 'pb 5/22/2015 18:35'!
upper =

	char:x ?[x isUppercase] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 6/10/2015 15:53'!
empty
	"fixme - inline?"
	^ true.! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 6/4/2015 17:23'!
end =
	// Are we at the end of the input stream?
	~anything! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 5/22/2015 18:25'!
exactly :wanted =

	anything:got ?[wanted = got] -> [wanted]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 6/10/2015 15:53'!
firstAndRest
	"A meta rule for 'first rest+' where the rule names are substituted with the values of first and rest.  See listOf for another example of a meta rule.  fixme - rewrite in OMeta"
	| first rest |
	first := self apply: #anything.
	rest := self apply: #anything.
	^ self genericMany: [self apply: rest] into: (OrderedCollection with: (self apply: first))! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 6/10/2015 15:55'!
fromTo :x :y =
	// Match the sequence from x to y.  Example to match a comment: fromTo("/*", "*/"):commentText
	seq(x) (~seq(y) anything)*:t seq(y) -> [t]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 6/11/2015 01:48'!
fromToOrEnd :x :y =
	// fixme - not working
	// Match the sequence from x to y.  Example to match a comment: fromTo("/*", "*/"):commentText
	seq(x) (~seq(y) anything)*:t (seq(y) | end) -> [t]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 5/22/2015 18:29'!
listOf :rule :delim =

		apply(rule):x (token(delim) apply(rule))*:xs -> [xs addFirst: x; yourself]
	|	empty -> [#()]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 5/22/2015 18:31'!
notLast :rule =

	apply(rule):ans &apply(rule) -> [ans]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 5/22/2015 18:31'!
number =

	anything:x ?[x isNumber] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 6/4/2015 17:24'!
range :a :b =
	// Is the next object within the range of a .. b?  Example usage: checking if an input character falls within the given range.
	anything:x ?[a <= x & (x <= b)] -> [x]! !

!OMeta2 methodsFor: 'ometa grammar' stamp: 'pb 5/22/2015 18:34'!
symbol =

	anything:x ?[x isSymbol] -> [x]! !

!OMeta2 methodsFor: 'private' stamp: 'pb 5/12/2016 21:52'!
parseLog: aString
	Transcript
		show: aString;
		finishEntry.! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:43'!
arrayConstr =

	"{" expr ("." expr)* ("." | empty) "}"
|	"{" "}"! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:57'!
arrayLit =

	"#" "(" (literal | arrayLit | spaces tsArraySymbol)* ")"! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:57'!
binary =

	spaces tsBinary! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:58'!
binaryExpr =

	binaryExpr binaryMsg
|	unaryExpr! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:58'!
binaryMsg =

	binary unaryExpr! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:08'!
block =

	"["
		(	(":" identifier)+ "|"
		|	empty
		)

		(	"|" identifier* "|"
		|	empty
		)

		(	expr ("." expr)* ("." "^" expr | empty)
		|	"^" expr
		|	empty
		)

		(	"."
		|	empty
		)

	"]"! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:58'!
cascade =

	identifier
|	binaryMsg
|	keywordMsg! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 00:59'!
expr =

	identifier (":=" | "_") expr
|	msgExpr! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:18'!
identifier =

	spaces tsIdentifier ~$:! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:19'!
keyword =

	spaces tsKeyword! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:19'!
keywordExpr =

	binaryExpr keywordMsg! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:19'!
keywordMsg =

	keywordMsg keywordMsgPart
|	keywordMsgPart! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:20'!
keywordMsgPart =

	keyword binaryExpr! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:20'!
literal =

	spaces	(	tsNumber
			|	tsCharacter
			|	tsString
			|	tsSymbol
			)
! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:21'!
msgExpr =

	(keywordExpr | binaryExpr) (";" cascade)*! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:23'!
symbol =

	"#" spaces
		(	tsString
		|	tsKeyword (tsIdentifier | empty)
		)! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:23'!
tcBinaryChar =

	char:x ?[(TypeTable at: x asciiValue) == #xBinary]! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:25'!
tsArraySymbol =

	tsKeyword+ (tsIdentifier | empty)
|	tsIdentifier! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:25'!
tsBinary =

	($| | tcBinaryChar) tcBinaryChar*! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:25'!
tsCharacter =

	$$ char! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:26'!
tsIdentifier =

	letter (letter | digit)*! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:31'!
tsKeyword =

	tsIdentifier $:! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:26'!
tsNatural =

	digit+! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:27'!
tsNumber =

	($+ | $- | empty) tsNatural! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:28'!
tsString =

	$' ($' $' | ~$' char)* $'! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:28'!
tsSymbol =

	$# spaces (tsString | tsArraySymbol)! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:28'!
unaryExpr =

	unit identifier*! !

!O2SqueakRecognizer methodsFor: 'private' stamp: 'aw 2/20/2009 01:29'!
unit =

	literal
|	identifier
|	arrayLit
|	arrayConstr
|	block
|	"(" expr ")"
! !

!O2SqueakRecognizer methodsFor: 'grammar root' stamp: 'aw 2/20/2009 01:30'!
squeakExpr =

	<expr>! !

!O2SqueakRecognizer class methodsFor: 'class initialization' stamp: 'aw 2/20/2009 02:04'!
initialize

	TypeTable := #(#xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xDelimiter #xDelimiter #xBinary #xDelimiter #xDelimiter #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #doIt #xBinary #xDelimiter #xBinary #xDoubleQuote #xLitQuote #xDollar #xBinary #xBinary #xSingleQuote #leftParenthesis #rightParenthesis #xBinary #xBinary #xBinary #xBinary #period #xBinary #xDigit #xDigit #xDigit #xDigit #xDigit #xDigit #xDigit #xDigit #xDigit #xDigit #xColon #semicolon #xBinary #xBinary #xBinary #xBinary #xBinary #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #leftBracket #xBinary #rightBracket #upArrow #leftArrow #xBinary #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #leftBrace #verticalBar #rightBrace #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xLetter #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xBinary #xLetter #xBinary #xBinary #xBinary #xBinary #xLetter #xBinary #xBinary #xBinary #xBinary #xBinary #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xBinary #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xBinary #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xLetter #xBinary)! !

!OMeta2Flattener methodsFor: 'grammar root' stamp: 'pb 5/22/2015 18:40'!
flatten :tree =

	iFlatten(tree) -> [ws contents]! !

!OMeta2Flattener methodsFor: 'private' stamp: 'pb 5/22/2015 18:41'!
iFlatten =

	string:s 	[ws nextPutAll: s]
|	{iFlatten*}! !

!OMeta2Flattener methodsFor: 'initialization' stamp: 'aw 2/18/2009 15:05'!
initialize

	super initialize.
	ws := (String new: 64) writeStream! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
and = trans*:xs -> [xs addFirst: #And; yourself]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
consby = trans:x -> [{#ConsBy. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
form = trans:x -> [{#Form. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:01'!
helped = ?[didSomething]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
idxconsby = trans:x -> [{#IdxConsBy. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
lookahead = trans:x -> [{#Lookahead. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
many = trans:x -> [{#Many. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:44'!
many1 = trans:x -> [{#Many1. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:45'!
not = trans:x -> [{#Not. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:45'!
opt = trans:x -> [{#Opt. x}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:45'!
or = trans*:xs -> [xs addFirst: #Or; yourself]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:45'!
rule = _:name _:temps trans:body -> [{#Rule. name. temps. body}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:45'!
set = _:name trans:val -> [{#Set. name. val}]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:00'!
setHelped = [didSomething := true]! !

!OMeta2NullOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:42'!
trans =

	{:t [t asLowercase asSymbol]:t ?[self class canUnderstand: t] apply(t):ans} -> [ans]
|	_! !

!OMeta2NullOpt methodsFor: 'initialization' stamp: 'aw 5/20/2009 12:30'!
initialize

	super initialize.
	didSomething := false! !

!OMeta2NullOpt methodsFor: 'grammar root' stamp: 'aw 5/20/2009 12:02'!
optimize = trans:x helped -> [x]! !

!OMeta2AndOrOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:46'!
and =

	trans:x end setHelped -> [x]
|	transInside(#And):xs -> [xs addFirst: #And; yourself]! !

!OMeta2AndOrOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:46'!
or =

	trans:x end setHelped -> [x]
|	transInside(#Or):xs -> [xs addFirst: #Or; yourself]! !

!OMeta2AndOrOpt methodsFor: 'private' stamp: 'aw 5/20/2009 12:36'!
transInside :t =

	{exactly(t) transInside(t):xs} transInside(t):ys setHelped -> [xs, ys]
|	trans:x transInside(t):xs -> [xs addFirst: x; yourself]
|	empty -> [OrderedCollection new]! !

!OMeta2Optimizer methodsFor: 'grammar root' stamp: 'pb 6/7/2015 17:47'!
optimizeRule = _:ans (OMeta2AndOrOpt.optimize(ans):ans)* -> [ans]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 18:59'!
application =

	"^" name:rule args:as				-> [{#SuperApp. rule}, as]
|	name:grm $. nsName:rule args:as	-> [{#App. #foreign. grm. ('#', rule) asSymbol}, as]
|	name:rule args:as						-> [{#App. rule}, as]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:00'!
args =

	$( listOf(#squeakExpression. '.'):ans ")" -> [ans]
|	~$( -> [#()]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:00'!
characterLiteral =

	spaces $$ char:c -> [{#App. #exactly. c storeString}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:01'!
characters =

	"``" (~($' $') char)*:xs $' $' -> [{#App. #seq. (String withAll: xs) storeString}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/11/2015 19:05'!
expr =
	// Wrap the sub-expressions with an 'or'.  If it's not needed, we'll optimize it away later.
	listOf(#expr4. '|'):xs -> [(OrderedCollection with: #Or) addAll: xs; yourself]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/11/2015 18:56'!
expr1 =
	// Handle any syntactic sugar and parse the final expression
	(keyword('true') | keyword('false') | keyword('nil')):lit -> [{#App. #exactly. lit}]
|	application
|	semanticAction
|	semanticPredicate
|	characters
|	tokenSugar
|	stringLiteral
|	symbolLiteral
|	numberLiteral
|	characterLiteral
|	"{"  expr:e "}" -> [{#Form. e}]
|	"<"  expr:e ">" -> [{#ConsBy. e}]
|	"@<" expr:e ">" -> [{#IdxConsBy. e}]
|	"("  expr:e ")" -> [e]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/11/2015 18:49'!
expr2 =
	// Handle lookahead
	"~" expr2:x -> [{#Not. x}]
|	"&" expr2:x -> [{#Lookahead. x}]
|	expr1! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/11/2015 18:49'!
expr3 =
	// Handle arity and variable assignment
	expr2:x optIter(x):x
		(	$: nsName:n [temps add: n]	-> [{#Set. n. x}]
		|	empty								-> [x]
		)
|	":" nsName:n [temps add: n]			-> [{#Set. n. {#App. #anything}}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/11/2015 18:57'!
expr4 =
	// Wrap related rule sub-expressions with an 'and'.  If it's not needed, we'll optimize it away later
	expr3*:xs -> [(OrderedCollection with: #And) addAll: xs; yourself]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:02'!
keyword :xs =

	token(xs) ~letterOrDigit -> [xs]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:02'!
name =

	spaces nsName! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:03'!
nameFirst =

	letter! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:03'!
nameRest =

	nameFirst | digit! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:03'!
nsName =

	firstAndRest(#nameFirst. #nameRest):xs -> [(String withAll: xs) asSymbol]
|	$_ -> [#anything]
! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:04'!
numberLiteral =

	spaces ($- spaces -> [-1] | empty -> [1]):sign digit+:ds
		-> [{#App. #exactly. (sign * (String withAll: ds) asNumber) storeString}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:04'!
optIter :x =

	"*"		-> [{#Many.  x}]
|	"+"		-> [{#Many1. x}]
|	"?" ~$[	-> [{#Opt. x}]
|	empty		-> [x]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:05'!
rulePart :ruleName =

	name:n ?[n = ruleName] expr4:b1
		(	"=" expr:b2	-> [{#And. b1. b2}]
		|	empty			-> [b1]
		)! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:05'!
semanticAction =

	"->"? "[" squeakExpression:e $] -> [{#Act. e}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:05'!
semanticPredicate =

	"?[" squeakExpression:e $] -> [{#Pred. e}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/5/2015 22:15'!
space =

	^space | fromTo('/*'. '*/') | fromToEnd('//')! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 6/7/2015 17:48'!
squeakExpression = O2SqueakRecognizer.squeakExpr:ans spaces -> [ans]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:06'!
stringLiteral =

	"'" ($' $' -> [$'] | ~$' char)*:xs $' -> [{#App. #exactly. (String withAll: xs) storeString}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:06'!
symbolLiteral =

	// TODO: make this accept, e.g., #foo:bar:
	"#" nsName:s -> [{#App. #exactly. s storeString}]! !

!OMeta2RuleParser methodsFor: 'private' stamp: 'pb 5/22/2015 19:07'!
tokenSugar =

	token('"') (~$" char)*:xs $" -> [{#App. #token. (String withAll: xs) storeString}]! !

!OMeta2RuleParser methodsFor: 'initialization' stamp: 'aw 2/18/2009 15:04'!
initialize

	super initialize.
	temps := IdentitySet new! !

!OMeta2RuleParser methodsFor: 'grammar root' stamp: 'pb 6/11/2015 19:04'!
rule =
	~(^space* nsName expr4 "=") <char*>:squeakCode -> [{#Squeak. squeakCode}] // This isn't OMeta code so we'll handoff to Squeak when the time comes
|	&(^space* nsName):n rulePart(n):x ("," rulePart(n))*:xs spaces end
		-> [{#Rule. n. temps asSortedCollection. (OrderedCollection with: #Or with: x) addAll: xs; yourself}]! !

!OMeta2RuleParser class methodsFor: 'testing' stamp: 'aw 2/23/2009 10:07'!
isOMeta2Rule: aString

	^ [(self matchAll: aString with: #rule) first ~= #Squeak] on: OM2Fail do: [false]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:07'!
act = string:x -> [{'('. x. ')'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:08'!
and = trans*:xs -> [{'(true ifTrue: ['. self delim: xs with: '. '. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 6/9/2015 04:28'!
app =
	symbol:rule
	(	anything+:args [self delim: args with: '. ']:args -> [{'(self apply: '. rule storeString. ' withArgs: {'. args. '})'}]
	|	[{'(self apply: '. rule storeString. ')'}]
	)
! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:08'!
consby =

	trans:x -> [{'(self consumedBy: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'aw 2/18/2009 14:43'!
delim: aSequenceableCollection  with: anObject

	| first ans |
	
	first := true.
	ans := OrderedCollection new.
	aSequenceableCollection do: [:x |
		first ifTrue: [first := false] ifFalse: [ans add: anObject].
		ans add: x
	].
	^ ans! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:09'!
form =

	trans:x -> [{'(self form: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:09'!
idxconsby =

	trans:x -> [{'(self indexConsumedBy: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:09'!
lookahead =

	trans:x -> [{'(self lookahead: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:10'!
many =

	trans:x -> [{'(self many: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:10'!
many1 =

	trans:x -> [{'(self many1: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:10'!
not =

	trans:x -> [{'(self not: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:10'!
opt =

	trans:x -> [{'(self opt: ['. x. '])'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:11'!
or =

	(trans:x -> [{'['. x. ']'}])*:xs -> [{'(self ometaOr: {'. self delim: xs with: '. '. '})'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:11'!
pred =

	string:x -> [{'(self pred: ('. x. '))'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/23/2018 03:00:30'!
rule =

	symbol:name
	anything:temps [temps select: [:t | (grammarClass instVarNames includes: t) not]]:temps
	trans:body
	-> [{name. self class constOMetaGeneratorString. ' |'. self delim: temps asSortedCollection with: ' '. ' | ^ '. body}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:12'!
set =

	symbol:n trans:v -> [{'('. n asString. ' := '. v. ')'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:12'!
squeak = string! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:12'!
superapp =

	symbol:rule anything*:args
	[self delim: args with: '. ']:args
	-> [{'(self super: '. grammarClass superclass name. ' apply: '. rule storeString. ' withArgs: {'. args. '})'}]! !

!OMeta2RuleTranslator methodsFor: 'private' stamp: 'pb 5/22/2015 19:13'!
trans = {symbol:type apply(type asLowercase asSymbol):ans} -> [ans]! !

!OMeta2RuleTranslator methodsFor: 'grammar root' stamp: 'pb 5/22/2015 19:13'!
translate :grammarClass = trans! !

!OMeta2RuleTranslator class methodsFor: 'constants' stamp: 'pb 5/23/2018 03:01:33'!
constOMetaGeneratorString
	^ '"Generated by OMeta... edit the rule (i.e. show...->source), not this Smalltalk code"'.! !
O2SqueakRecognizer initialize!
