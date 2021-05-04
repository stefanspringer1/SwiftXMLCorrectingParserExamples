# SwiftXMLCorrectingParserExamples

This is an xecutable Swift package with examples of using the XMLParser from Swift Foundation, but in a way that "corrects" the errors encountered in the repository [SwiftXMLParserExamples](https://github.com/stefanspringer1/SwiftXMLParserExamples) when using it. **Note: When you are using more simple types of XML documents, you may not need the "trick" presented herte.**

# Usage

The XML samples used are in the subdirectory `Samples`.

**Run with the current directoy set to the project directory,** e.g. set your custom working directory in Xcode via "Edit Scheme..." first or run the script `run.sh`.

# What It Does

See [SwiftXMLParserExamples](https://github.com/stefanspringer1/SwiftXMLParserExamples) what problems we encountered when parsing XML using XML Parser from SwiftFoundation. Hopefully, this will get resolved in the library _or we just did something wrong (please tell us if you know)._ But for the time being, here is some kind of a solution. We proceed as follows:

1. We read the XML document just until the start of the first element while reading all entity declarations.
2. We make a list of replacements to be applied for all of those entities in the document where they are used, e.g. in the sample we would like to replace `&ent1;` by `&temporaryEntityName1;`.
3. We write a temporary copy of the document with the added file name extension `.tmp.xml` (just besides the original file) where those replacements are applied, _but in a simple textual manner_ (see the list of shortcomings below).
4. We parse this new document and while parsing, replace the according entity name while "resolving" them.

# Shortcomings of This Method

Of course, there are some shortcomings using this methods, at least in the simple implementation as presented here:

- We suppose that the XML document is encoded in UTF-8 (it would be nice to get the encoding from the first parsing, but see [SR-14586](https://bugs.swift.org/browse/SR-14586)).
- We suppose that that there are no other entities named `temporaryEntityName...`.
- We suppose that the texts to be replaced (e.g. `&ent1;` in the sample) do not occur in places where they do not represent an entity (e.g. in CDATA sections).
- We suppose that it sensible to write the temporary document with the added file name extension besides the original document. It it also not deleted afterwards.
- The textual replacements are done step by step for each of the replacements, one at a time. There ought to be a more efficient algorithm.
- We do not know what would have to be changed here if an XML schema (e.g. DTD) is present and the Swift XMLParser validates against that scheme or even if our "trick" is then still necessary.

Of course, some of these points could easily be improved.