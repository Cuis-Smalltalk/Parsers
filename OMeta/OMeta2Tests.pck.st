'From Cuis 5.0 of 7 November 2016 [latest update: #3122] on 2017-7-10 at 6:49:21 am'!
'Description Tests for OMeta2'!
!provides: 'OMeta2Tests' 2 4!
!requires: 'OMeta2Examples' 2 0 nil!
!classDefinition: #OMeta2DebugTests category: #OMeta2Tests!
TestCase subclass: #OMeta2DebugTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Tests'!
!classDefinition: 'OMeta2DebugTests class' category: #OMeta2Tests!
OMeta2DebugTests class
	instanceVariableNames: ''!

!classDefinition: #OMeta2ExampleTests category: #OMeta2Tests!
TestCase subclass: #OMeta2ExampleTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Tests'!
!classDefinition: 'OMeta2ExampleTests class' category: #OMeta2Tests!
OMeta2ExampleTests class
	instanceVariableNames: ''!

!classDefinition: #OMeta2StepByStepTests category: #OMeta2Tests!
TestCase subclass: #OMeta2StepByStepTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Tests'!
!classDefinition: 'OMeta2StepByStepTests class' category: #OMeta2Tests!
OMeta2StepByStepTests class
	instanceVariableNames: ''!


!OMeta2StepByStepTests commentStamp: '<historical>' prior: 0!
This class is intended both to be a test of core OMeta functionality as well as a step by step tutorial of sorts demonstrating every aspect of OMeta that you can use in your grammars.  If you go through the tests in sequence, it should all make sense when you are done.

Everything used in these tests should be considered part of the supported language/API.!

!OMeta2DebugTests methodsFor: 'test case' stamp: 'pb 6/20/2016 22:23'!
testForm
	"Verify that debug tracing logic doesn't interfere with form operation"
	self should: (OMeta2DebugExample debugMatch: #('testing') with: #debugForm) = #('testing')
! !

!OMeta2DebugTests methodsFor: 'test case' stamp: 'pb 6/12/2015 15:04'!
testInfiniteRecursion
	self flag: #fixme. "Also need to handle case where not eos but input not advancing"
	self should: [OMeta2DebugExample match: 'does not matter what goes here' with: #infiniteRecursion] raise: OMeta2DebugError "Infinite recursion detected".
! !

!OMeta2DebugTests methodsFor: 'test case' stamp: 'pb 6/12/2015 14:59'!
testNotASequence
	self should: [OMeta2DebugExample match: 'does not matter what goes here' with: #notASequence] raise: OMeta2DebugError "Not a sequence: a".
! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/26/2015 03:43'!
testFactorial
	self should: (OMeta2Examples match: 0 with: #fact) = 1.
	self should: (OMeta2Examples match: 5 with: #fact) = 120.
	self should: (OMeta2Examples match: 10 with: #fact) = 3628800.! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/22/2015 16:54'!
testGreeting
	self should: (OMeta2Examples matchAll: 'howdy' with: #greeting) = 'howdy'! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/22/2015 16:56'!
testIdentifierIndex
	self should: (OMeta2Examples matchAll: 'abc123sd' with: #identifierIdx) = (Association key: 1 value: 9)! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/23/2015 22:01'!
testLambdaCalculus
	self should: (OMeta2LambdaCalculusParserExample matchAll: '4' with: #digit) = 4.
	self should: (OMeta2LambdaCalculusParserExample matchAll: 'x and y' with: #root) =   #(#('and' #('name' #x) #('name' #y))).
	self should: (OMeta2LambdaCalculusParserExample matchAll: 'x and y;x*y' with: #root) =   #(#('and' #('name' #x) #('name' #y)) #('mul' #('name' #x) #('name' #y)))! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/29/2015 21:16'!
testLisp
	| lispClass |
	lispClass := OMeta2LispExample.

	"*** ev rule tests..."

	"string"
	self should: (lispClass eval: #t) = true.
	self should: (lispClass eval: #z) = nil.

	"lambda... under app rule tests"

	"quote"
	self should: (lispClass eval: #(quote 1)) = 1.
	self should: (lispClass eval: #(quote (1 2 3))) = #(1 2 3).

	"cond"
	self should: (lispClass eval: #(cond nil)) = nil.
	self should: (lispClass eval:
		#(cond
			((eq (quote a) (quote b)) (quote optiona))
			((eq (quote b) (quote b)) (quote optionb))
			(t (quote invalid)))) = #optionb.
	self should: (lispClass eval:
		#(cond
			((eq (quote a) (quote b)) (quote optiona))
			((eq (quote b) (quote 3)) (quote optionb))
			(t (quote invalid)))) = #invalid.

	"*** app rule tests..."

	"car"
	self should: (lispClass eval: #(car (quote (1 2 3)))) = 1.

	"cdr"
	self flag: #fixme.
	"Should this be an OC?"
	"self should: (lispClass eval: #(cdr (quote (1 2 3)))) = #(2 3)."
	self should: (lispClass eval: #(cdr (quote (1 2 3)))) = (OrderedCollection new add: 2; add: 3; yourself).

	"cons"
	self should: (lispClass eval: #(cons (quote a) (quote b))) = #(a b).

	"atom"
	self should: (lispClass eval: #(atom (quote a))) = true.
	self should: (lispClass eval: #(atom (cons (quote a) (quote b)))) = false.

	"eq"
	"a and b are both nil so eq should always return true (in a real Lisp environment, this would result in an error)"
	self should: (lispClass eval: #(eq a a)) = true.
	self should: (lispClass eval: #(eq a b)) = true.
	"when quoted, you get the results you were probably expecting"
	self should: (lispClass eval: #(eq (quote a) (quote a))) = true.
	self should: (lispClass eval: #(eq (quote a) (quote b))) = false.

	"lambda"
	self should: (lispClass eval: #((lambda (x) (cons x x)) (quote boo))) = #(boo boo).

	"*** more complex and multiple expressions"
	self should: (lispClass evalAll:
		#((eq (quote a) (quote b))
		(cons (quote x) (quote y)))) = #(x y).
	self should: (lispClass evalAll:
		#((cons
			(eq (quote a) (quote b))
			(cons (quote x) (quote y))
			))) = #(false (x y)).
	self should: (lispClass evalAll:
		#(((lambda (x)
			(cons x x)) (quote boo))
			(eq a b))) = true.
	self should: (lispClass evalAll:
		#((cons
			((lambda (x)
				(cons x x))
				(quote boo))
			(eq x (quote boo))))) = #((boo boo) false).
	self should: (lispClass eval:
		#((lambda (x)
			(cond
				((eq (quote a) x) (quote optiona))
				((eq (quote b) x) (quote optionb))
				(t (quote invalid))))
			(quote a))) = #optiona.
	self should: (lispClass eval:
		#((lambda (x)
			(cond
				((eq (quote a) x) (quote optiona))
				((eq (quote b) x) (quote optionb))
				(t (quote invalid))))
			(quote b))) = #optionb.
	self should: (lispClass eval:
		#((lambda (x)
			(cond
				((eq (quote a) x) (quote optiona))
				((eq (quote b) x) (quote optionb))
				(t (quote invalid))))
			(quote c))) = #invalid.! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/26/2015 03:34'!
testNumber
	self should: (OMeta2Examples matchAll: '1234' with: #number) = 1234.
	self should: [OMeta2Examples match: '1234' with: #number] raise: OM2Fail.
! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/22/2015 16:53'!
testObjectStructure
	self should: (OMeta2Examples matchAll: #($a $b $c 1 2 3 #(4 5)) with: #structure) = #(4 5)
! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/22/2015 16:52'!
testStringMatch
	self should: (OMeta2Examples matchAll: 'abc123' with: #identifier) = 'abc123'
! !

!OMeta2ExampleTests methodsFor: 'test case' stamp: 'pb 5/23/2015 16:22'!
testTree
	| tree |
	tree := OMeta2TreeExample demoTree.
	self should:  tree unapply = #(#Node #(#Node #(#Leaf 3) #(#Node #(#Leaf 1) #(#Node #(#Leaf 1) #(#Leaf 1)))) #(#Node #(#Leaf 5) #(#Empty))).
	self should: tree depth = 5.
	self should: tree sum = 11.! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 22:36'!
test00Anything
	"Understanding how OMeta views input is critical.  To OMeta, the input stream is just one or more objects."

	"Will literally match anything (i.e. an identity match)"
	self should: (OMeta2StepByStepExample match: nil with: #testAnything) = nil.
	self should: (OMeta2StepByStepExample match: $a with: #testAnything) = $a.
	self should: (OMeta2StepByStepExample match: '' with: #testAnything) = ''.
	self should: (OMeta2StepByStepExample match: 'aaa' with: #testAnything) = 'aaa'.
	self should: (OMeta2StepByStepExample match: 3 with: #testAnything) = 3.
	self should: (OMeta2StepByStepExample match: Dictionary with: #testAnything) = Dictionary. "you can pass in objects of any type, including classes"
	self should: (OMeta2StepByStepExample match: #($a 'b' (1 2 3) nil) with: #testAnything) = #($a 'b' (1 2 3) nil). "in this case, the array is treated as a single object to be matched"

	"If you have many anythings, we can match those too"
	self should: (OMeta2StepByStepExample matchAll: #($a 'b' (1 2 3) nil) with: #testManyAnything) = (OrderedCollection new add: $a; add: 'b'; add: #(1 2 3); add: nil; yourself). "in this case, the array is treated as a collection of objects to be matched"
	self should: (OMeta2StepByStepExample matchAll: 'aaa' with: #testManyAnything) = (OrderedCollection new add: $a; add: $a; add: $a; yourself) "a string is just a collection of characters.  this will be hit on a couple of more times... it's important!!"! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 23:04'!
test01Character
	| emptyOC aOC aaaaaOC |
	"fixme - need to cover letter, digit, etc."
	"covers the use of literals as well as * and + operators with character matches"
	emptyOC := OrderedCollection new.
	aOC := (OrderedCollection new add: $a; yourself).
	aaaaaOC := OrderedCollection new add: $a; add: $a; add: $a; add: $a; add: $a; yourself.

	"Note that #matchAll: expects strings for arity matches since 'string' is just a sequence of characters while #match: expects a single character"
	self should: (OMeta2StepByStepExample match: $a with: #testLiteralChar) = $a.
	self should: (OMeta2StepByStepExample matchAll: 'a' with: #testLiteralChar) = $a.
	self should: (OMeta2StepByStepExample matchAll: '' with: #testManyChar) = emptyOC. "Note that this works since * allows 0 matches"
	self should: (OMeta2StepByStepExample matchAll: 'aaaaa' with: #testManyChar) = aaaaaOC.
	self should: (OMeta2StepByStepExample matchAll: 'aaaaa' with: #testMany1Char) = aaaaaOC.
	self should: (OMeta2StepByStepExample matchAll: 'a' with: #testMany1Char) = aOC. "#test04ConsumedBy  shows you one way to get strings back"! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 22:37'!
test02String
	| abcOC abcabcOC |
	"covers the use of literals, *, +, ? and tokens with string matches"
	abcOC := (OrderedCollection new add: 'abc'; yourself).
	abcabcOC := OrderedCollection new add: 'abc'; add: 'abc'; yourself.

	"Note that #matchAll: expects collections of strings for arity matches since 'string' is a single string object while #match: expects a single string"
	self should: (OMeta2StepByStepExample match: 'abc' with: #testLiteralString) = 'abc'.
	self should: (OMeta2StepByStepExample matchAll: #('abc' ) with: #testLiteralString) = 'abc'.
	self should: (OMeta2StepByStepExample matchAll: #('abc' 'abc' ) with: #testManyString) = abcabcOC.
	self should: (OMeta2StepByStepExample matchAll: #('abc' 'abc' ) with: #testMany1String) = abcabcOC.
	self should: (OMeta2StepByStepExample matchAll: #('abc' ) with: #testMany1String) = abcOC.
	self should: (OMeta2StepByStepExample matchAll: 'abc' with: #testOpt) = 'abc'.
	self should: (OMeta2StepByStepExample matchAll: '' with: #testOpt) = nil.

	"Tokens are strings that ignore leading spaces.  You could override the definition of #spaces to include other types of whitespace if you want for your grammar."
	self should: (OMeta2StepByStepExample matchAll: '   item      item' with: #testToken) = 'item'.! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 22:37'!
test03Sequence
	"Sequences (i.e. ordered collections) of objects"
	self should: (OMeta2StepByStepExample matchAll: 'itemitem' with: #testSeqString) = 'item'.
	self should: (OMeta2StepByStepExample matchAll: #($i $t $e $m $i $t $e $m) with: #testSeqString) = 'item'. "sequences of characters are strings as far as seq is concerned"
	self should: (OMeta2StepByStepExample matchAll: #(1 2 3) with: #testSeqObject) = #(1 2 3). "not just for strings though"! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 22:58'!
test04ConsumedBy
	"consumedBy <> and consumedByIndex @<>"
	self should: (OMeta2StepByStepExample matchAll: 'feed me' with: #testConsumedBy) = 'feed me'. "Returns the input 'consumed' by the rule.  Now we don't have to deal with a collection of characters"
	self should: (OMeta2StepByStepExample matchAll: 'feed me' with: #testConsumedByIndex) =
(Association key: 1 value: 8) "this returns the positional index range of the beginning and end of the match"! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 22:59'!
test05PredicateAction
	self should: (OMeta2StepByStepExample matchAll: 'testing' with: #testSemanticPredicate) = true. "notice that the predicate, being the last expression in the rule, again overrides the default return value.  This rule also introduces the assignment operator."
	self should: (OMeta2StepByStepExample matchAll: 'testing' with: #testSemanticAction) = 'got it!!'. "we can use a semantic action to return the value we actually want.  But the match will fail if anything other than 'testing' is passed in..."! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/9/2015 22:58'!
test06PrioritizedChoice
	self should: (OMeta2StepByStepExample matchAll: 'testing' with: #testPrioritizedChoice) = 'got it!!'. "prioritized choice to the rescue!!"
	self should: (OMeta2StepByStepExample matchAll: 'not' with: #testPrioritizedChoice) = 'not'.
! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/10/2015 00:45'!
test07Lookahead
	"fixme - todo & operator"
	self should: (OMeta2StepByStepExample matchAll: '''not a double quote''' with: #testLookaheadNot) = #($' $n $o $t $  $a $  $d $o $u $b $l $e $  $q $u $o $t $e $') asOrderedCollection. "we get a sequence of characters back because this rule matches character by character."! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/10/2015 14:36'!
test08RuleParameters
	self should: (OMeta2StepByStepExample matchAll: 'looking for test text' with: #testRuleParameters) = 'looking for test text'! !

!OMeta2StepByStepTests methodsFor: 'test case' stamp: 'pb 6/10/2015 15:00'!
test10FromTo
	self should: (OMeta2StepByStepExample matchAll: '/* finding */ the test text...' with: #testFromTo) = #($f $i $n $d $i $n $g $  $t $e $x $t $. $. $.) asOrderedCollection! !
