OMeta/Cuis
==========

# Overview

OMeta/Cuis started as a port of OMeta/Squeak to Cuis but is quickly turning into a bit more so naming it OMeta/Cuis and moving it to its own repository reflects that.  It is intended to be compatible with OMeta/Squeak where possible so most existing grammars should work without changes.  One additional benefit to having its own repository is that it is now possible to include add-on parsers without cluttering up my Cuis-Ports repository.

# Installation

A. Download Cuis5.0-3192 or later

B. Pull down the OMeta*.st files from https://github.com/pbella/OMeta-Cuis

C. File in in the following sequence

	1. OMeta2Preload.st
	2. OMeta2.pck.st
	3. OMeta2Extensions.pck.st (optional)
	4. OMeta2Examples.pck.st (optional)
	5. OMeta2Tests.pck.st (optional)

	(Items 2-5 can be loaded automatically via dependencies by loading OMeta2Tests)

D. Check examples in the OMeta2Examples class (for more examples, see class comments in OMeta2Examples category, for a more detailed look at OMeta syntax see OMeta2StepByStepTests)

	- OMeta2Examples match: 5 with: #fact.
	- OMeta2Examples matchAll: '1234' with: #number.
	- OMeta2Examples matchAll: 'abc123' with: #identifier.
	- OMeta2Examples matchAll: #($a $b $c 1 2 3 #(4 5)) with: #structure.
	- OMeta2Examples matchAll: 'howdy' with: #greeting.

The general idea is that the examples progress in complexity: OMeta2Examples (trivial) -> OMeta2StepByStepTests (test cases more thoroughly describing OMeta syntax) -> OMeta2TreeExample (simple but actually does something useful) -> OMeta2LamdaCalculusParserExample (parses a simple language but doesn't do anything with it) -> OMeta2LispExample (parses a minimal subset of a real language and executes it.)  Also, for more usage examples, see the tests which are currently all using the example parsers.

# Notes
- OMeta2Preload.st was previously named OMeta2-stage1.st in the Cuis-Ports repository
- OMeta2.pck.st overrides some of the methods in OMeta2Preload.st that are needed to load the package.  This is why *Preload has not been moved into a package (i.e. to not give the illusion that its contents can be changed and saved out once the full OMeta2 package has been loaded)
- Debugging support is weak (a known issue with OMeta in general... let's work to improve it)
- More test cases and examples are need.
- The OMeta styler works reasonably well but is still a work in progress.  One notable bug is that the first time you browse a Smalltalk method in an otherwise OMeta class, the formatting will be incorrect.  Select a different method and then select the Smalltalk method again to work around this issue for the time being.
- Possible performance optimization: create an ivar for OM2Fail in OMeta2Base rather than creating an instance per exception. (This was previously accomplished via a global OMeta2Fail which resulted in a memory leak)
