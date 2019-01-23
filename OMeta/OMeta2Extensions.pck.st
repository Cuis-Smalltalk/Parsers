'From Cuis 5.0 of 7 November 2016 [latest update: #3329] on a 2018-05-23 at 4:59:10 am'!
'Description Optional extensions to OMeta'!
!provides: 'OMeta2Extensions' 2 10!
!requires: 'OMeta2' 2 0 nil!
SystemOrganization addCategory: #OMeta2Extensions!


!classDefinition: #OMeta2DebugError category: #OMeta2Extensions!
Error subclass: #OMeta2DebugError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'OMeta2DebugError class' category: #OMeta2Extensions!
OMeta2DebugError class
	instanceVariableNames: ''!

!classDefinition: #SHTextStylerOMeta2 category: #OMeta2Extensions!
SHTextStyler subclass: #SHTextStylerOMeta2
	instanceVariableNames: 'smalltalkFallbackStyler useSmalltalkStyler'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'SHTextStylerOMeta2 class' category: #OMeta2Extensions!
SHTextStylerOMeta2 class
	instanceVariableNames: 'textAttributes'!

!classDefinition: #SHTextStylerOtherOMeta2 category: #OMeta2Extensions!
SHTextStylerOMeta2 subclass: #SHTextStylerOtherOMeta2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'SHTextStylerOtherOMeta2 class' category: #OMeta2Extensions!
SHTextStylerOtherOMeta2 class
	instanceVariableNames: ''!

!classDefinition: #OMeta2DebugRuleTranslator category: #OMeta2Extensions!
OMeta2RuleTranslator subclass: #OMeta2DebugRuleTranslator
	instanceVariableNames: 'transLogId transLog tempSequenceId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'OMeta2DebugRuleTranslator class' category: #OMeta2Extensions!
OMeta2DebugRuleTranslator class
	instanceVariableNames: ''!

!classDefinition: #OMeta2Debug category: #OMeta2Extensions!
OMeta2 subclass: #OMeta2Debug
	instanceVariableNames: 'om2ApplyPc om2ApplyWithArgsPc om2DebugRoot om2Eos om2TraceLog om2Trans om2TransId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'OMeta2Debug class' category: #OMeta2Extensions!
OMeta2Debug class
	instanceVariableNames: 'LastMatcher'!

!classDefinition: #OMeta2ExtendedParser category: #OMeta2Extensions!
OMeta2Debug subclass: #OMeta2ExtendedParser
	instanceVariableNames: 'ast curNode temps blockLevel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'OMeta2ExtendedParser class' category: #OMeta2Extensions!
OMeta2ExtendedParser class
	instanceVariableNames: ''!

!classDefinition: #SyntaxTreeNode category: #OMeta2Extensions!
Object subclass: #SyntaxTreeNode
	instanceVariableNames: 'node properties children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OMeta2Extensions'!
!classDefinition: 'SyntaxTreeNode class' category: #OMeta2Extensions!
SyntaxTreeNode class
	instanceVariableNames: ''!


!OMeta2DebugError commentStamp: '<historical>' prior: 0!
This is so we can determine debug vs. regular OMeta runtime errors!

!SHTextStylerOMeta2 commentStamp: '<historical>' prior: 0!
Styler for OMeta2-based code (which can include Smalltalk)!

!SHTextStylerOtherOMeta2 commentStamp: '<historical>' prior: 0!
Styler for 'other' OMeta2-based code (which doesn't necessarily use OMeta or Smalltalk syntax).  Since this can be arbitrary code, it doesn't attempt to parse it: it bolds the first line and displays the rest as normal text.

FIXME - when in prettyPrint mode should use a fallback Smalltalk styler (so actually we want to use the fallback parser as the primary (can't it doesn't error... so we use the OMeta parser which also handles Smalltalk... FIXME: hack) and if it fails, do it another way)!

!OMeta2Debug commentStamp: '<historical>' prior: 0!
This is a debugging and profiling version of OMeta2.  It trades quite a bit of performance to try to detect and report known runtime errors and collect detailed statistics.  This is often worthwhile when initially designing and debugging a parser.

To use, simply set this class as your parser's parent class.  Once you're happy with how the parser is operating, feel free to change your parser's parent class back to OMeta2 to eliminate the runtime overhead.

todo: infinite recursion detection!

!OMeta2ExtendedParser commentStamp: '<historical>' prior: 0!
This is a more full-featured OMeta parser that renders to a labelled syntax tree.  While significantly larger than the default parser, it will allow for much more flexibility.

Open issues:
- should I even be trying to re-use Smalltalk themes?  There is no clean mapping so even if we do it, using other themes may look unacceptably bad.
- need to finalize approach: extend existing ast or go with a more annotated version?!

!SyntaxTreeNode commentStamp: '<historical>' prior: 0!
A simple, generic syntax tree node which can be used for both concrete and abstract trees.!

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 9/3/2017 19:21:52'!
attributesFor: aSymbol
	^ useSmalltalkStyler
		ifTrue: [ smalltalkFallbackStyler class attributesFor: aSymbol ]
		ifFalse: [ self class attributesFor: aSymbol ].! !

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 9/3/2017 19:34:53'!
classOrMetaClass: anObject
	^ useSmalltalkStyler
		ifTrue: [ smalltalkFallbackStyler classOrMetaClass: anObject ]
		ifFalse: [ self ].! !

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 6/17/2015 00:33'!
disableFormatAndConvert! !

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 6/17/2015 00:31'!
privateFormatAndConvert! !

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 9/29/2017 00:04:55'!
privateStyle
	| ranges |
	ranges := [
	useSmalltalkStyler := false.
	self class rangeParser rangesFor: formattedText ]
		on: OM2Fail
		do: [ ].
	ranges ifNil: [
		ranges := smalltalkFallbackStyler
			textModel: textModel;
			
				formatAndStyle: textModel actualContents
				allowBackgroundStyleProcess: false;
			parseSetWorkspace: true.
		useSmalltalkStyler := true ].
	ranges ifNotNil: [
		self
			setAttributesIn: formattedText
			fromRanges: ranges
			in: nil ].! !

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 6/16/2015 23:13'!
setAttributesIn: aText fromRanges: ranges in: anInterval
	"modified by jmv to keep existing attributes if they answer true to #isParagraphAttribute"
	| attributes defaultAttributes paragraphAttributes attr newRuns newValues lastAttr lastCount beginning chunkRuns end |
	anInterval
		ifNil: [
			beginning := 1.
			end := aText size ]
		ifNotNil: [
			beginning := anInterval first.
			end := anInterval last ].
	defaultAttributes := self attributesFor: #default.
	paragraphAttributes := Array new: end - beginning + 1.
	1
		to: paragraphAttributes size
		do: [ :i |
			paragraphAttributes
				at: i
				put:
					((aText attributesAt: i + beginning - 1) select: [ :each |
						each isParagraphAttribute ]) ].
	attributes := Array new: end - beginning + 1.
	1
		to: attributes size
		do: [ :i |
			attributes
				at: i
				put: (paragraphAttributes at: i) , defaultAttributes ].
	ranges do: [ :range |
		(attr := self attributesFor: range rangeType) ifNotNil: [
			range start
				to: range end
				do: [ :i |
					attributes
						at: i
						put: (paragraphAttributes at: i) , attr ]]].
	newRuns := OrderedCollection new: attributes size // 10.
	newValues := OrderedCollection new: attributes size // 10.
	1
		to: attributes size
		do: [ :i |
			attr := attributes at: i.
			i = 1
				ifTrue: [
					newRuns add: 1.
					lastCount := 1.
					lastAttr := newValues add: attr ]
				ifFalse: [
					attr == lastAttr
						ifTrue: [
							lastCount := lastCount + 1.
							newRuns
								at: newRuns size
								put: lastCount ]
						ifFalse: [
							newRuns add: 1.
							lastCount := 1.
							lastAttr := newValues add: attr ]]].
	chunkRuns := (RunArray
		runs: newRuns
		values: newValues) coalesce.
	aText
		basicReplaceAttributesFrom: beginning
		to: end
		with: chunkRuns.! !

!SHTextStylerOMeta2 methodsFor: 'private' stamp: 'pb 1/5/2016 01:18'!
workspace: inst
	"Needed for Debugger>>shoutAboutToStyle:"
	self flag: #fixme.
	^ nil.! !

!SHTextStylerOMeta2 methodsFor: 'initialization' stamp: 'pb 9/3/2017 19:21:19'!
initialize
	super initialize.
	useSmalltalkStyler := false.
	smalltalkFallbackStyler := SHTextStylerST80 new.! !

!SHTextStylerOMeta2 class methodsFor: 'private' stamp: 'pb 6/17/2015 00:15'!
attributeArrayForColor: aColorOrNil emphasis: anEmphasisSymbolOrArrayorNil
	"Answer a new Array containing any non nil TextAttributes specified"
	| answer emphArray |
	answer := #().
	aColorOrNil ifNotNil: [ answer := answer , {TextColor color: aColorOrNil} ].
	anEmphasisSymbolOrArrayorNil ifNotNil: [
		emphArray := anEmphasisSymbolOrArrayorNil isSymbol
			ifTrue: [ {anEmphasisSymbolOrArrayorNil} ]
			ifFalse: [ anEmphasisSymbolOrArrayorNil ].
		emphArray do: [ :each |
			each ~= #normal ifTrue: [ answer := answer , {TextEmphasis perform: each} ]]].
	^ answer.! !

!SHTextStylerOMeta2 class methodsFor: 'private' stamp: 'pb 6/17/2015 01:19'!
attributesFor: aSymbol
	textAttributes ifNil: [ textAttributes := self initialTextAttributes ].
	^ textAttributes
		at: aSymbol
		ifAbsent: (self attributeArrayForColor: Color black emphasis: nil).! !

!SHTextStylerOMeta2 class methodsFor: 'private' stamp: 'pb 5/23/2018 01:53:53'!
initialTextAttributes
	"emphasis can be bold, italic, underlined... what about outline & strikethrough?"
	false
		ifTrue: [ | attrArray color dict element emphasis styleTable |
			"FIXME - at some point want to finish integrating with themes rather than the hard-coded approach currently being used..."
			styleTable := Theme current generateShoutConfig.
			dict := Dictionary new.
			styleTable do: [ :each |
				element := each first.
				color := each
					at: 2
					ifAbsent: nil.
				color := color ifNotNil: [ Color colorFrom: color ].
				emphasis := each
					at: 3
					ifAbsent: nil.
				attrArray := self
					attributeArrayForColor: color
					emphasis: emphasis.
				attrArray notEmpty ifTrue: [
					dict
						at: element
						put: attrArray ]].
			^ dict ]
		ifFalse: [ "keys: #nil->keywords (true/false/nil)
			#tempVar->inst vars
			#comment->/* */ and // comments
			#blockStartN->block nesting level
			#keyword->rules & parms
			#blockArg->arity (*+?)/lookahead (&~)
			#blockTempVar->apply/rule name
			#text->'string'
			#stringSymbol->token
			#character->$c and ``abc''
			#patternArg->semantic action/predicate
			#number->123
			#externalFunctionCallingConvention->squeak code"
			^ Dictionary new
				addAll:
					{
						#nil ->
							(self
								attributeArrayForColor: Color red muchDarker
								emphasis: nil). 
						#tempVar ->
							(self
								attributeArrayForColor: Color gray muchDarker
								emphasis: #italic). 
						#blockStart1 ->
							(self
								attributeArrayForColor:
									(Color
										r: 0.6
										g: 0.6
										b: 0.6)
								emphasis: nil). 
						#blockStart2 ->
							(self
								attributeArrayForColor:
									(Color
										r: 0.45
										g: 0.45
										b: 0.45)
								emphasis: nil). 
						#blockStart3 ->
							(self
								attributeArrayForColor:
									(Color
										r: 0.3
										g: 0.3
										b: 0.3)
								emphasis: nil). 
						#blockStart4 ->
							(self
								attributeArrayForColor:
									(Color
										r: 0.15
										g: 0.15
										b: 0.15)
								emphasis: nil). 
						#blockStart5 ->
							(self
								attributeArrayForColor:
									(Color
										r: 0.0
										g: 0.0
										b: 0.0)
								emphasis: nil). 
						#default ->
							(self
								attributeArrayForColor: Color black
								emphasis: nil). 
						#comment ->
							(self
								attributeArrayForColor: Color green
								emphasis: #italic). 
						#keyword ->
							(self
								attributeArrayForColor: Color blue lighter
								emphasis: #bold). 
						#blockArg ->
							(self
								attributeArrayForColor: Color orange lighter
								emphasis: #bold). 
						#blockTempVar ->
							(self
								attributeArrayForColor: Color blue
								emphasis: nil). 
						#text ->
							(self
								attributeArrayForColor: Color blue
								emphasis: #bold). 
						#stringSymbol ->
							(self
								attributeArrayForColor: Color blue muchDarker
								emphasis: #bold). 
						#symbol ->
							(self
								attributeArrayForColor: Color blue darker
								emphasis: #bold). 
						#character ->
							(self
								attributeArrayForColor: Color red muchDarker
								emphasis: nil). 
						#patternArg ->
							(self
								attributeArrayForColor: Color cyan muchDarker
								emphasis: nil). 
						#number ->
							(self
								attributeArrayForColor: Color purple
								emphasis: nil). 
						#externalFunctionCallingConvention ->
							(self
								attributeArrayForColor: Color cyan veryMuchDarker
								emphasis: nil)
					};
				yourself ].! !

!SHTextStylerOMeta2 class methodsFor: 'as yet unclassified' stamp: 'pb 6/9/2017 18:16:15'!
rangeParser
	^ OMeta2ExtendedParser! !

!SHTextStylerOMeta2 class methodsFor: 'private-development' stamp: 'pb 6/17/2015 01:09'!
resetAttributes
	textAttributes := nil! !

!SHTextStylerOtherOMeta2 methodsFor: 'private' stamp: 'pb 10/1/2017 15:22:36'!
privateStyle

	| ranges |
	ranges := [
	useSmalltalkStyler := true.
	self class rangeParser rangesFor: formattedText ]
		on: OM2Fail
		do: [ ].
	ranges ifNil: [ | idx |
		useSmalltalkStyler := false.
		idx := formattedText indexOf: Character lf.
		idx > 0
			ifTrue: [
				ranges := {
					SHRange
						start: 1
						end: idx - 1
						type: #bold. 
					SHRange
						start: idx
						end: formattedText size
						type: #normal
				} ]
			ifFalse: [
				ranges := {
					SHRange
						start: 1
						end: formattedText size
						type: #error
				} ]].
	ranges ifNotNil: [
		self
			setAttributesIn: formattedText
			fromRanges: ranges
			in: nil ].! !

!SHTextStylerOtherOMeta2 class methodsFor: 'private' stamp: 'pb 9/3/2017 18:32:05'!
initialTextAttributes
	"emphasis can be bold, italic, underlined... what about outline & strikethrough?"
	^ Dictionary new
		
			at: #bold
			put:
				(self
					attributeArrayForColor: Color black
					emphasis: #bold);
		
			at: #default
			put:
				(self
					attributeArrayForColor: Color black
					emphasis: nil);
		
			at: #error
			put:
				(self
					attributeArrayForColor: Color red
					emphasis: nil);
		yourself.! !

!SHTextStylerOtherOMeta2 class methodsFor: 'as yet unclassified' stamp: 'pb 9/3/2017 18:02:16'!
rangeParser
	^ OMeta2ExtendedParser! !

!OMeta2DebugRuleTranslator methodsFor: 'private' stamp: 'pb 6/20/2016 21:54'!
debugNextSequenceId
	"Some generated debugging code requires unique generated names in the event of nesting... a sequence provides uniqueness."
	^ tempSequenceId  := tempSequenceId + 1! !

!OMeta2DebugRuleTranslator methodsFor: 'private' stamp: 'pb 6/9/2016 18:38'!
debugWrapRule: rule body: body
	^ {'debugTmpTransId:=self debugStartTrans: #'. rule . '.
debugTmpResult :='. body. '.
self debugFinishTrans: #'. rule. ' id: debugTmpTransId.
^ debugTmpResult'}.! !

!OMeta2DebugRuleTranslator methodsFor: 'private' stamp: 'pb 6/20/2016 23:26'!
form =
// FIXME - doing it here so that #form: doesn't need to know about debug transactions...
// Form is a sort of built-in sub-rule that can be useful to trace when troubleshooting with structured data
//	trans:x -> [{'(self form: ['. x. '])'}]
	[self debugNextSequenceId asString]:ftId
	trans:x -> [{'[|fresult',ftId,' ftr',ftId,'|
			ftr',ftId,' := self debugStartTrans: #subRuleForm.
			fresult',ftId,':=(self form: ['. x. ']).
			self debugFinishTrans: #subRuleForm id: ftr',ftId,'.
			fresult',ftId,'] value'}]! !

!OMeta2DebugRuleTranslator methodsFor: 'private' stamp: 'pb 5/23/2018 03:00:51'!
rule =

	symbol:name
	anything:temps [temps select: [:t | (grammarClass instVarNames includes: t) not]]:temps
	trans:body
	-> [{name. ' | debugTmpResult debugTmpTransId '. self delim: temps asSortedCollection with: ' '. ' | '. self class constOMetaGeneratorString. self debugWrapRule: name body: body}]! !

!OMeta2DebugRuleTranslator methodsFor: 'initialization' stamp: 'pb 6/20/2016 21:52'!
initialize
	super initialize.
	tempSequenceId := 0.
	transLog := OrderedCollection new.
	transLogId := 1.! !

!OMeta2Debug methodsFor: 'ometa grammar' stamp: 'pb 10/1/2017 15:25:03'!
apply: aRule
	input class = OM2EndOfStream ifTrue: [
		om2Eos > 100000
			ifTrue: [ OMeta2DebugError new signal: 'Infinite recursion detected'
				"There's a good possibility that there is a rule with optional arity (i.e. using * and/or ?) that is being matched even though we are at the end of the input stream." ]
			ifFalse: [ om2Eos := om2Eos + 1 ]].
	om2ApplyPc
		at: aRule
		put:
			(om2ApplyPc
				at: aRule
				ifAbsentPut: [ 0 ]) + 1.
	^ super apply: aRule.! !

!OMeta2Debug methodsFor: 'ometa grammar' stamp: 'pb 10/1/2017 15:25:24'!
apply: aRule withArgs: args
	om2ApplyWithArgsPc
		at: aRule
		put:
			(om2ApplyWithArgsPc
				at: aRule
				ifAbsentPut: [ 0 ]) + 1.
	^ super
		apply: aRule
		withArgs: args.! !

!OMeta2Debug methodsFor: 'ometa grammar' stamp: 'pb 6/12/2015 14:58'!
seq
	| xs |
	xs := self apply: #anything.
	[
	xs do: [ :x |
		" may want to inline #apply:withArgs: below as an
		  optimization, since this rule gets used a lot "
		self
			apply: #exactly
			withArgs: {x} ].
	^ xs ] on: Exception
		do: [ :e |
			(xs isKindOf: Collection)
				ifTrue: [ e signal
					"no idea what the problem is" ]
				ifFalse: [ OMeta2DebugError new signal: 'Not a sequence: ' , xs asString
					"we were probably passed in a character, number, etc..." ]].! !

!OMeta2Debug methodsFor: 'private' stamp: 'pb 10/1/2017 15:25:43'!
debugFinishTrans: name id: transId
	self debugShouldTrace ifTrue: [
		(om2Trans at: transId)
			
				at: 'matched'
				put: true;
			
				at: 'pos'
				put: self pos ].! !

!OMeta2Debug methodsFor: 'private' stamp: 'pb 6/15/2015 05:53'!
debugLogTrace
	om2TraceLog add: om2Trans.
	om2Trans := Dictionary new.! !

!OMeta2Debug methodsFor: 'private' stamp: 'pb 6/15/2015 05:03'!
debugShouldTrace
	^ false! !

!OMeta2Debug methodsFor: 'private' stamp: 'pb 1/8/2018 14:48:56'!
debugStartTrans: name
	self debugShouldTrace ifTrue: [
		om2TransId := om2TransId + 1.
		om2Trans
			at: om2TransId
			put:
				(Dictionary new
					
						at: 'rule'
						put: name;
					
						at: 'matched'
						put: false;
					
						at: 'pos'
						put: self pos;
					yourself).
		^ om2TransId ].! !

!OMeta2Debug methodsFor: 'private' stamp: 'pb 10/1/2017 15:26:50'!
om2DebugPc
	^ Dictionary new
		
			at: 'applyPc'
			put: om2ApplyPc;
		
			at: 'applyWithArgsPc'
			put: om2ApplyWithArgsPc;
		yourself.! !

!OMeta2Debug methodsFor: 'private' stamp: 'pb 6/12/2015 07:17'!
om2DebugRoot: aRule
	om2DebugRoot := aRule! !

!OMeta2Debug methodsFor: 'initialization' stamp: 'pb 10/1/2017 15:26:31'!
initialize
	super initialize.
	om2Eos := 0.
	om2ApplyPc := Dictionary new.
	om2ApplyWithArgsPc := Dictionary new.
	om2Trans := Dictionary new.
	om2TransId := 0.
	om2TraceLog := OrderedCollection new.! !

!OMeta2Debug class methodsFor: 'accessing' stamp: 'pb 6/12/2015 06:20'!
lastMatcher
	^ LastMatcher! !

!OMeta2Debug class methodsFor: 'private' stamp: 'pb 6/12/2015 07:18'!
matchStream: aReadStream with: aRule withArgs: args withPlaybackDebugging: debugging
	| input matcher ans |
	input := OM2LazyStream
		for: aReadStream
		withPos: 1.
	matcher := self new initInput: input.
	matcher om2DebugRoot: aRule.
	LastMatcher := matcher.
	[
	matcher
		apply: #empty
		withArgs: args.
	ans := matcher apply: aRule.
	matcher apply: #end.
	^ ans ]
		on: OM2Fail
		do: [ :e | | curr prev prevPrev |
			debugging ifFalse: [ e signal ].
			curr := input.
			prev := nil.
			prevPrev := nil.
			[ curr notNil ] whileTrue: [
				prevPrev := prev.
				prev := curr.
				curr := curr basicTail ].
			curr := prevPrev
				ifNil: [ prev ]
				ifNotNil: [ prevPrev ].
			"fixme - does this add any value?
		self inform: 'will halt each time matcher reaches ', curr printString.
		"
			matcher
				initInput: input;
				forgetEverything.
			curr ifNil: [ self error: 'you''ve found a bug -- please tell Alex' ].
			curr become: (OM2StreamDebugger for: curr copy).
			matcher haltingPoint: curr.
			matcher
				apply: #empty
				withArgs: args.
			ans := matcher apply: aRule.
			matcher apply: #end.
			Transcript
				show: matcher om2DebugPc asString;
				finishEntry.
			^ ans ].! !

!OMeta2Debug class methodsFor: 'private' stamp: 'pb 2/3/2016 21:33'!
ometa2RuleTranslatorClass
	^ OMeta2DebugRuleTranslator.! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:16:13'!
application =
	@<"^" name:rule>:superIdx args:as	-> [(self newNode: #SuperApp)
				properties: {#op -> rule.
							#args -> as.
							self newRange: superIdx type: #blockTempVar};
				yourself]
|	@<name:grm $. nsName:rule>:app1Idx	 @<args:as>:app2Idx -> [(self newNode: #App)
				properties: {#op -> #foreign.
					#parm -> grm.
					#huh1 -> ('#', rule) asSymbol.
					#huh2 -> as.
					self newRange: app1Idx type: #blockTempVar with: app2Idx type: #externalFunctionCallingConvention}]
|	@<name:rule>:app1Idx @<args:as>:app2Idx					-> [(self newNode: #App)
				properties: { #op -> rule.
					#parm -> as.
					self newRange: app1Idx type: #blockTempVar with: app2Idx type: #externalFunctionCallingConvention}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 6/17/2015 19:43'!
args =
	// fixme - best way to style?
	$( listOf(#squeakExpression. '.'):ans ")" -> [ans]
|	~$( -> [#()]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 6/26/2015 01:45'!
blockEnter
	blockLevel := blockLevel+1.
	"Transcript show: 'bl: ', blockLevel asString; finishEntry"! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:11:01'!
blockLevelAndLeave
	| retVal |
	"
	retVal := #blockStart1.
	blockLevel > 1 ifTrue: [
		blockLevel > 2
			ifTrue: [
				blockLevel > 3
					ifTrue: [ retVal := #blockStart4 ]
					ifFalse: [ retVal := #blockStart3 ]]
			ifFalse: [ retVal := #blockStart2 ]].
		"
	retVal := blockLevel caseOf: {
		[ 1 ] -> [ #blockStart1 ].
		[ 2 ] -> [ #blockStart2 ].
		[ 3 ] -> [ #blockStart3 ]}
		 otherwise: [ "Only go up to 4"
		#blockStart4 ].
	blockLevel := blockLevel - 1.
	^ retVal.! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:16:45'!
characterLiteral =
	@<spaces $$ char:c>:cIdx -> [(self newNode: #App) properties: { #op -> #exactly.
																#parm -> c storeString.
																self newRange: cIdx type: #character}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:16:54'!
characters =
	@<"``" (~($' $') char)*:xs $' $'>:charIdx -> [(self newNode: #App) properties:
							{ #op -> #seq.
							#parm -> (String withAll: xs) storeString.
							self newRange:  charIdx type: #character}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:17:11'!
expr =
	// Wrap the sub-expressions with an 'or'.  If it's not needed, we'll optimize it away later.
	// fixme - how to best highlight OR...
	listOf(#expr4. '|'):xs -> [(self newNode: #Or) addChildren: xs]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:22:22'!
expr1 =
	// Handle any syntactic sugar and parse the final expression
	@<(keyword('true') | keyword('false') | keyword('nil')):lit>:litIdx
						-> [(self newNode: #App) properties: {#op -> #exactly. #parm -> lit. self newRange: litIdx type: #nil}]
|	application
|	semanticAction
|	semanticPredicate
|	characters
|	tokenSugar
|	stringLiteral
|	symbolLiteral
|	numberLiteral
|	characterLiteral
|	@<"{">:blkStart [self blockEnter]  expr:e @<"}">:blkEnd
					-> [(self newNode: #Form) properties: {#op -> e.
											self newRange: blkStart and: blkEnd type: self blockLevelAndLeave}]
|	@<"<">:blkStart [self blockEnter]  expr:e @<">">:blkEnd
				 	-> [(self newNode: #ConsBy) properties: {#op -> e.
											self newRange: blkStart and: blkEnd type: self blockLevelAndLeave}]
|	@<"@<">:blkStart [self blockEnter] expr:e @<">">:blkEnd
				 	-> [(self newNode: #IdxConsBy) properties: {#op -> e.
											self newRange: blkStart and: blkEnd type: self blockLevelAndLeave}]
|	@<"(">:blkStart expr:e @<")">:blkEnd -> [e] // fixme - syntax highlighting! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:17:54'!
expr2 =
	// Handle lookahead
	@<"~">:xIdx expr2:x -> [(self newNode: #Not) properties: {#op -> x. self newRange: xIdx type: #blockArg}] 
|	@<"&">:xIdx expr2:x -> [(self newNode: #Lookahead) properties: {#op -> x. self newRange: xIdx type: #blockArg}] 
|	expr1! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:10'!
expr3 =
	// Handle arity and variable assignment
	expr2:x optIter(x):x
		(	$: @<nsName:n>:tmpIdx [temps add: n] -> [(self newNode: #Set) properties: {#op -> n. #parm -> x. self newRange: tmpIdx type: #tempVar}]
		|	empty						-> [x]
		)
|	":" nsName:n [temps add: n] -> [(self newNode: #Set) properties: {#op -> n};
										addChild: ((self newNode: #App) properties: {#op -> #anything})]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:17'!
expr4 =
	// Wrap related rule sub-expressions with an 'and'.  If it's not needed, we'll optimize it away later
	expr3*:xs -> [(self newNode: #And) addChildren: xs]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 6/25/2015 00:43'!
initialize
	super initialize.
	ast := self newNode: #rule.
	blockLevel := 0.
	curNode := ast.
	curNode properties at: #comments put: OrderedCollection new.
	temps := IdentitySet new.! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:25'!
keyword :xs =
	token(xs) ~letterOrDigit -> [xs]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:29'!
name =
	spaces nsName! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:33'!
nameFirst =
	letter! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:39'!
nameRest =
	nameFirst | digit! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 6/14/2015 17:29'!
newNode: nodeType
	^ SyntaxTreeNode node: nodeType.! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 6/17/2015 19:58'!
newRange: assoc and: otherAssoc type: type
	"create assoc to be use as a range property.  this currently covers every use case except comments in the space rule.  fixme... not currently used"
	| passoc |
	passoc := (self newRange: assoc type: type).
	passoc value add: (SHRange start: otherAssoc key end: otherAssoc value -1 type: type); yourself.
	^ passoc
! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:22:51'!
newRange: assoc type: type
	"create assoc to be use as a range property.  this currently covers every use case except comments in the space rule"
	^ #rangeIdxList ->
		(OrderedCollection new
			add:
				(SHRange
					start: assoc key
					end: assoc value - 1
					type: type);
			yourself).! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:22:58'!
newRange: assoc type: type with: assoc2 type: type2
	"create assoc to be use as a range property.  this currently covers every use case except comments in the space rule"
	^ #rangeIdxList ->
		(OrderedCollection new
			add:
				(SHRange
					start: assoc key
					end: assoc value - 1
					type: type);
			add:
				(SHRange
					start: assoc2 key
					end: assoc2 value - 1
					type: type2);
			yourself).! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:18:59'!
nsName =
	firstAndRest(#nameFirst. #nameRest):xs -> [(String withAll: xs) asSymbol]
|	$_ -> [#anything]
! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:19:06'!
numberLiteral =
	@<spaces ($- spaces -> [-1] | empty -> [1]):sign digit+:ds>:numIdx
		-> [(self newNode: #App) properties: {#op -> #exactly.
				#parm -> (sign * (String withAll: ds) asNumber) storeString.
				self newRange: numIdx type: #number}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:19:19'!
optIter :x =
	@<"*">:arManyIdx		-> [(self newNode: #Many) properties: {#parm -> x.
																	self newRange: arManyIdx type: #blockArg}]
|	@<"+">:arMany1Idx		-> [(self newNode: #Many1) properties: {#parm -> x.
																	self newRange: arMany1Idx type: #blockArg}]
|	@<"?">:arOptIdx ~$[	-> [(self newNode: #Opt) properties: {#parm -> x.
																	self newRange: arOptIdx type: #blockArg}]
|	empty	-> [x]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:19:30'!
rulePart :ruleName =
	// testing
	[nil]:retVal
	@<name:n ?[n = ruleName] expr4:b1>:nIdx -> [[curNode properties: {self newRange: nIdx type: #keyword}. retVal] value]
		(	@<"=">:nIdx2 expr:b2	-> [[((curNode properties at: #rangeIdxList) at: 1) end: nIdx2 value. retVal := (self newNode: #And) addChild: b1; addChild: b2] value] // nIdx2 is a hack to get to the '='.  Highly non-optimal as we really want params highlighted in a different style anyway
		|	empty			-> [retVal := curNode addChild: b1]
		)! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:19:38'!
semanticAction =
	@<"->"? "[">:saIdx1 squeakExpression:e @<$]>:saIdx2 -> [(self newNode: #Act) properties: {#op -> e. self newRange: saIdx1 and: saIdx2 type: #patternArg}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:19:59'!
semanticPredicate =
	@<"?[">:spIdx1 squeakExpression:e @<$]>:spIdx2 -> [(self newNode: #Pred) properties: {#op -> e. self newRange: spIdx1 and: spIdx2 type: #patternArg}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:20:05'!
space =
	^space
	| @<fromTo('/*'. '*/')>:longCommentIdx -> [(curNode properties at: #comments) add: (SHRange start: longCommentIdx key end: longCommentIdx value - 1 type: #comment)]
	| @<fromToEnd('//')>:commentIdx -> [(curNode properties at: #comments) add: (SHRange start: commentIdx key end: commentIdx value - 1 type: #comment)]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:20:15'!
squeakExpression = @<O2SqueakRecognizer.squeakExpr:ans>:sqIdx spaces
							-> [(self newNode: #Smalltalk) properties: {#parm -> ans.
									self newRange: sqIdx type: #externalFunctionCallingConvention}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:20:23'!
stringLiteral =
	@<"'" ($' $' -> [$'] | ~$' char)*:xs $'>:strIdx -> [(self newNode: #App) properties: 											{#op -> #exactly.
											 #parm ->  (String withAll: xs) storeString.
											self newRange: strIdx type: #text}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:14:20'!
symbolLiteral =
	// TODO: make this accept, e.g., #foo:bar:
	@<"#" nsName:s>:symIdx -> [(self newNode: #App) properties: {
											#op -> #exactly.
											#parm -> s storeString.
											self newRange: symIdx type: #symbol
											}]! !

!OMeta2ExtendedParser methodsFor: 'private' stamp: 'pb 5/23/2018 03:20:31'!
tokenSugar =
	@<token('"') (~$" char)*:xs $">:tokIdx -> [(self newNode: #App) properties: {
															#op -> #token.
															#parm -> (String withAll: xs) storeString.
															self newRange: tokIdx type: #stringSymbol
															}]! !

!OMeta2ExtendedParser methodsFor: 'grammar' stamp: 'pb 6/16/2015 23:10'!
isSmalltalkCode = ~(^space* nsName expr4 "=") <char*>:squeakCode -> [true]
		|	anything* -> [false]
		// fixme - inefficient way to test! !

!OMeta2ExtendedParser methodsFor: 'grammar' stamp: 'pb 5/23/2018 03:15:45'!
rule = ~(^space* nsName expr4 "=") <char*>:squeakCode -> [self newNode: #Squeak]
											//-> [{#Squeak. squeakCode}]
											// This isn't OMeta code so we'll handoff to Squeak when the time comes
|	&(^space* nsName):n rulePart(n):x ("," rulePart(n))*:xs spaces end
		-> [ curNode := (curNode node: #Rule) properties: {#temps -> temps asSortedCollection.
					#n -> n};
					addChild: ((self newNode: #Or) addChild: x; addChildren: xs)]! !

!OMeta2ExtendedParser class methodsFor: 'private' stamp: 'pb 5/4/2016 15:10'!
rangesFor: source
	| result |
	(self
		matchAll: source
		with: #isSmalltalkCode)
		ifTrue: [ ^ nil ]
		ifFalse: [
			result := OrderedCollection new.
			(self
				matchAll: source
				with: #rule) do: [ :ea |
				self
					recurseForRanges: ea
					into: result ].
			^ result sort: [ :a :b |
				a start < b start ]].! !

!OMeta2ExtendedParser class methodsFor: 'private' stamp: 'pb 6/25/2015 05:10'!
recurseForRanges: ea into: result
	| p |
	p := ea properties.
	p
		at: #rangeIdxList
		ifPresent: [ :ranges |
			result addAll: ranges ].
	p
		at: #comments
		ifPresent: [ :ranges |
			result addAll: ranges ].
	p
		at: #op
		ifPresent: [ :op |
			(op isKindOf: SyntaxTreeNode) ifTrue: [
				op do: [ :opNode |
					self
						recurseForRanges: opNode
						into: result ]]].
	p
		at: #parm
		ifPresent: [ :parm |
			(parm isKindOf: SyntaxTreeNode) ifTrue: [
				parm do: [ :parmNode |
					self
						recurseForRanges: parmNode
						into: result ]]].
	result.! !

!OMeta2ExtendedParser class methodsFor: 'private-wip' stamp: 'pb 5/4/2016 15:10'!
scratchParserNew
	^ self matchAll: ((self methodDict at: #rulePart) getSource) with: #rule! !

!OMeta2ExtendedParser class methodsFor: 'private-wip' stamp: 'pb 5/4/2016 15:10'!
scratchParserStock
	"Stock OMeta rule parser"
	^ self
		matchAll: (self methodDict at: #rulePart) getSource
		with: #rule.! !

!OMeta2ExtendedParser class methodsFor: 'private-wip' stamp: 'pb 5/4/2016 15:11'!
scratchRecurseSHRange
	| recurseForRanges result |
	result := OrderedCollection new.
	recurseForRanges := [ :ea :useResult | | p |
	p := ea properties.
	p
		at: #rangeIdxList
		ifPresent: [ :ranges |
			useResult addAll: ranges ].
	useResult ].
	self demo do: [ :ea | | p |
		p := ea properties.
		p
			at: #rangeIdxList
			ifPresent: [ :ranges |
				result addAll: ranges ].
		p at: #comments ifPresent: [:ranges|
			result addAll: ranges].
		p
			at: #op
			ifPresent: [ :op |
				(op isKindOf: SyntaxTreeNode) ifTrue: [
					recurseForRanges
						value: op
						value: result ]].
		p
			at: #parm
			ifPresent: [ :parm |
				(parm isKindOf: SyntaxTreeNode) ifTrue: [
					recurseForRanges
						value: parm
						value: result ]].
		result ].
	^ result sort: [:a :b| a start<b start].! !

!SyntaxTreeNode methodsFor: 'adding' stamp: 'pb 6/12/2015 21:15'!
addChild: aNode
	children add: aNode! !

!SyntaxTreeNode methodsFor: 'adding' stamp: 'pb 6/13/2015 02:21'!
addChildren: nodes
	nodes do: [ :curNode |
		children add: curNode ].! !

!SyntaxTreeNode methodsFor: 'converting' stamp: 'pb 6/14/2015 02:42'!
asArray
	^ self collect: [:ea| ea]! !

!SyntaxTreeNode methodsFor: 'accessing' stamp: 'pb 6/13/2015 19:10'!
at: key
	^ properties at: key.! !

!SyntaxTreeNode methodsFor: 'accessing' stamp: 'pb 6/13/2015 19:09'!
at: key put: value
	^ properties
		at: key
		put: value.! !

!SyntaxTreeNode methodsFor: 'accessing' stamp: 'pb 6/13/2015 18:32'!
node
	^ node! !

!SyntaxTreeNode methodsFor: 'accessing' stamp: 'pb 6/12/2015 21:18'!
node: aNode
	node := aNode! !

!SyntaxTreeNode methodsFor: 'accessing' stamp: 'pb 6/13/2015 19:09'!
properties: propColl
	propColl do: [ :prop |
		self
			at: prop key
			put: prop value ].! !

!SyntaxTreeNode methodsFor: 'private' stamp: 'pb 6/14/2015 01:51'!
children
	^ children! !

!SyntaxTreeNode methodsFor: 'private' stamp: 'pb 6/14/2015 02:46'!
collectDepthFirst: aBlock with: node
	"Recurse the tree depth-first collecting the result of calling aBlock for each element"
	| results |
	results := OrderedCollection new.
	results add: (aBlock value: node).
	node childrenDo: [ :cnode |
		results addAll:
			(self
				collectDepthFirst: aBlock
				with: cnode) ].
	^ results.! !

!SyntaxTreeNode methodsFor: 'private' stamp: 'pb 6/14/2015 02:46'!
doDepthFirst: aBlock with: node
	"Recurse the tree depth-first calling aBlock for each element"
	aBlock value: node.
	node childrenDo: [ :cnode |
		self
			doDepthFirst: aBlock
			with: cnode ].! !

!SyntaxTreeNode methodsFor: 'private' stamp: 'pb 6/16/2015 17:23'!
properties
	^ properties! !

!SyntaxTreeNode methodsFor: 'enumerating' stamp: 'pb 6/14/2015 02:54'!
childrenDo: aBlock
	"Call aBlock for each direct child"
	children do: aBlock.! !

!SyntaxTreeNode methodsFor: 'enumerating' stamp: 'pb 6/14/2015 02:46'!
collect: aBlock
	"Recurse the tree depth-first collecting the result of calling aBlock for each element"
	^ self
		collectDepthFirst: aBlock
		with: self.! !

!SyntaxTreeNode methodsFor: 'enumerating' stamp: 'pb 6/14/2015 02:46'!
do: aBlock
	"Recurse the tree depth-first calling aBlock for each element"
	^ self
		doDepthFirst: aBlock
		with: self.! !

!SyntaxTreeNode methodsFor: 'initialization' stamp: 'pb 6/13/2015 01:52'!
initialize
	super initialize.
	properties := Dictionary new.
	children := OrderedCollection new.! !

!SyntaxTreeNode methodsFor: 'printing' stamp: 'pb 10/15/2017 19:36:10'!
printOn: aStream
	| title |
	title := self class name.
	aStream
		nextPutAll:
			(title first isVowel
				ifTrue: [ 'an ' ]
				ifFalse: [ 'a ' ]);
		nextPutAll: title;
		nextPut: $(;
		print: node;
		nextPut: $).! !

!SyntaxTreeNode class methodsFor: 'instance creation' stamp: 'pb 6/13/2015 02:14'!
node: aNode
	^ (self
		new)
		node: aNode;
		yourself.! !

!SyntaxTreeNode class methodsFor: 'private' stamp: 'pb 6/14/2015 02:01'!
testTree
	| child node |
	node := self node: 1.
	child := self node: 2.
	5
		to: 7
		do: [ :idx | | gChild |
			gChild := self node: idx.
			gChild addChild: (self node: idx * 10).
			child addChild: gChild ].
	node addChild: child.
	child := self node: 3.
	8
		to: 10
		do: [ :idx |
			child addChild: (self node: idx) ].
	node addChild: child.
	child := self node: 4.
	11
		to: 13
		do: [ :idx |
			child addChild: (self node: idx) ].
	node addChild: child.
	^ node.! !

!OMeta2Compiler class methodsFor: '*OMeta2Extensions' stamp: 'pb 6/22/2015 20:01'!
textStylerClass
	^ SHTextStylerOMeta2! !

!SHRange methodsFor: '*OMeta2Extensions' stamp: 'pb 5/23/2018 02:23:38'!
printOn: aStream
	aStream
		nextPutAll: 'a ';
		nextPutAll: self class name;
		nextPut: $(;
		print: start;
		nextPutAll: '..';
		print: end;
		nextPut: $:;
		print: type;
		nextPut: $).! !
