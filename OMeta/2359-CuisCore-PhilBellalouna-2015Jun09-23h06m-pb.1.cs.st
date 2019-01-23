'From Cuis 4.2 of 25 July 2013 [latest update: #2358] on 12 June 2015 at 6:42:00.02463 pm'!

!StrikeFont class methodsFor: 'removing' stamp: 'pb 6/12/2015 18:39'!
removeMostFonts
"
StrikeFont removeMostFonts
"
	| familyDict |
	Preferences disable: #italicsInShout.
	DefaultStyler initialize.
	familyDict := AvailableFonts at: 'DejaVu'.
	familyDict keys do: [ :k |
		(#(8 10 12) includes: k) 
			ifTrue: [
				(familyDict at: k) derivativeFont: nil at: 0 ]
			ifFalse: [
				familyDict removeKey: k ]].
	
	Preferences setDefaultFonts: #(
		(setSystemFontTo: 'DejaVu' 10)
		(setListFontTo: 'DejaVu' 10)
		(setMenuFontTo: 'DejaVu' 10)
		(setWindowTitleFontTo: 'DejaVu' 12)
		(setCodeFontTo: 'DejaVu' 10)
		(setButtonFontTo: 'DejaVu' 10))! !


!TextModelMorph class methodsFor: 'instance creation' stamp: 'pb 6/12/2015 18:39'!
textProvider: aTextProvider textGetter: textGetter textSetter: textSetter selectionGetter: selectionGetter allowStyler: aBoolean

	| newModel answer |
	answer := self new.
	(aBoolean and: [
		Preferences syntaxHighlightingAsYouType and: [ aTextProvider is: #ShoutEnabled ]])
			ifTrue: [ answer styler: DefaultStyler new ].

	newModel := PluggableTextModel on: aTextProvider.
	newModel textGetter: textGetter textSetter: textSetter selectionGetter: selectionGetter.
	aTextProvider addDependent: newModel.

	answer model: newModel.
	answer autoCompleter: newModel autoCompleter.
	^answer! !

!TextModelMorph class methodsFor: 'instance creation' stamp: 'pb 6/12/2015 18:39'!
withModel: aTextModel

	|  answer |
	answer := self new.
	(Preferences syntaxHighlightingAsYouType 
			and: [ aTextModel is: #ShoutEnabled ]) ifTrue: [
		answer styler: DefaultStyler new ].

	answer model: aTextModel.
	answer autoCompleter: aTextModel autoCompleter.
	^answer! !


!Theme class methodsFor: 'class initialization' stamp: 'pb 6/12/2015 18:39'!
currentTheme: aTheme

	CurrentTheme := aTheme new.
	DefaultStyler initialize.
	self runningWorld ifNotNil: [ :w |
		w backgroundImage ifNil: [
			w color: CurrentTheme background ]].
	SystemWindow initialize.
	BitBltCanvas releaseClassCachedState.
	self runningWorld ifNotNil: [ :w |
		w hideTaskbar; showTaskbar.
		w restoreMorphicDisplay ].
	
	^ CurrentTheme! !

