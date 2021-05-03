import Foundation

class ParserDelegate: NSObject, XMLParserDelegate {
    
    let entitiesRestore: [String:String]?
    
    init(entitiesRestore: [String:String]?) {
        self.entitiesRestore = entitiesRestore
    }
    
    // Sent by the parser object to the delegate when it begins parsing a document.
    func parserDidStartDocument(_: XMLParser) {
        print("did start document")
    }
    
    // Sent by the parser object to the delegate when it has successfully completed parsing.
    func parserDidEndDocument(_: XMLParser) {
        print("did end document")
    }
    
    // Sent by a parser object to its delegate when it encounters a start tag for a given element.
    func parser(_ parser: XMLParser, didStartElement name: String, namespaceURI uri:
    String?, qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:])
    {
        print("start of element: name \"\(name)\", namespace URI \"\(uri ?? "")\", qualified name \"\(qName ?? "")\"")
        for (name, value) in attributeDict {
            print("attribute: name \"\(name)\", value \"\(value)\"")
        }
    }
    
    // Sent by a parser object to its delegate when it encounters an end tag for a specific element.
    func parser(_ parser: XMLParser, didEndElement name: String, namespaceURI:
    String?, qualifiedName qName: String?) {
        print("end of element: name \"\(name)\", namespace URI \"\(namespaceURI ?? "")\", qualified name \"\(qName ?? "")\"")
    }
    
    // Sent by a parser object to its delegate the first time it encounters a given namespace prefix, which is mapped to a URI.
    func parser(_: XMLParser, didStartMappingPrefix prefix: String, toURI uri: String) {
        print("first occurrence of namespace prefix: prefix \(prefix), uri \"\(uri)\"")
    }

    // Sent by a parser object to its delegate when a given namespace prefix goes out of scope.
    func parser(_: XMLParser, didEndMappingPrefix prefix: String) {
        print("namespace prefix goes out of scope: prefix \(prefix)")
    }
    
    // Sent by a parser object to its delegate when it encounters a given external entity with a specific system ID.
    func parser(_ parser: XMLParser, resolveExternalEntityName temporaryName: String, systemID: String?) -> Data? {
        let name = entitiesRestore?[temporaryName] ?? temporaryName
        print("resolving external entity: name \"\(name)\", system ID \"\(systemID ?? "")\"")
        return nil
    }
    
    // Sent by a parser object to its delegate when it encounters a fatal error.
    func parser(_ parser: XMLParser, parseErrorOccurred error: Error) {
        print("ERROR: \(error)")
    }
    
    // Sent by a parser object to its delegate when it encounters a fatal validation error. NSXMLParser currently does not invoke this method and does not perform validation.
    func parser(_: XMLParser, validationErrorOccurred error: Error) {
        print("ERROR: \(error)")
    }
    
    // Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
    func parser(_ parser: XMLParser, foundCharacters text: String) {
        print("text \"\(text)\"")
    }
    
    // Reported by a parser object to provide its delegate with a string representing all or part of the ignorable whitespace characters of the current element.
    func parser(_: XMLParser, foundIgnorableWhitespace space: String) {
        print("ignorable whitespace \"\(space)\"")
    }
    
    // Sent by a parser object to its delegate when it encounters a processing instruction.
    func parser(_: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {
        print("processing instruction: target \"\(target)\", data \"\(data ?? "")\"")
    }
    
    // Sent by a parser object to its delegate when it encounters a comment in the XML.
    func parser(_: XMLParser, foundComment comment: String) {
        print("processing instruction: \"\(comment)\"")
    }
    
    // Sent by a parser object to its delegate when it encounters a CDATA block.
    func parser(_: XMLParser, foundCDATA data: Data) {
        print("CDATA: \"\(data)\"")
    }
    
    // Sent by a parser object to its delegate when it encounters a declaration of an attribute that is associated with a specific element.
    func parser(_: XMLParser, foundAttributeDeclarationWithName name: String, forElement element: String, type: String?, defaultValue: String?) {
        print("attribute declaration: target \"\(name)\", element \"\(element)\", type \"\(type ?? "")\", defaultValue \"\(defaultValue ?? "")\"")
    }
    
    // Sent by a parser object to its delegate when it encounters a declaration of an element with a given model.
    func parser(_: XMLParser, foundElementDeclarationWithName name: String, model: String) {
        print("element declaration: target \"\(name)\", model \"\(model)\"")
    }
    
    // Sent by a parser object to its delegate when it encounters an external entity declaration.
    func parser(_: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
        print("parsed external entity declaration: name \"\(name)\", public id \"\(publicID ?? "")\", system ID \"\(systemID ?? "")\"")
    }
    
    // Sent by a parser object to the delegate when it encounters an internal entity declaration.
    func parser(_: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
        print("internal entity declaration: name \"\(name)\", value \"\(value ?? "")\"")
    }
    
    // Sent by a parser object to its delegate when it encounters an unparsed entity declaration.
    func parser(_: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
        print("unparsed external entity declaration: name \"\(name)\", public id \"\(publicID ?? "")\", system ID \"\(systemID ?? "")\", notation name \"\(notationName ?? "")\"")
    }
    
    // Sent by a parser object to its delegate when it encounters a notation declaration.
    func parser(_: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
        print("notation declaration: name \"\(name)\", public id \"\(publicID ?? "")\", system ID \"\(systemID ?? "")\"")
    }
    
}

func externalEntityResolvingPolicyDescription(_ externalEntityResolvingPolicy: XMLParser.ExternalEntityResolvingPolicy) -> String {
    switch externalEntityResolvingPolicy {
    case XMLParser.ExternalEntityResolvingPolicy.never: return "never"
    case XMLParser.ExternalEntityResolvingPolicy.noNetwork: return "noNetwork"
    case XMLParser.ExternalEntityResolvingPolicy.sameOriginOnly: return "sameOriginOnly"
    case XMLParser.ExternalEntityResolvingPolicy.always: return "always"
    default: return "?"
    }
}

func parse(
    fileURLWithPath: String,
    shouldResolveExternalEntities: Bool = true,
    externalEntityResolvingPolicy: XMLParser.ExternalEntityResolvingPolicy = XMLParser.ExternalEntityResolvingPolicy.never,
    entitiesRestore: [String:String]? = nil
) {
    let url = URL(fileURLWithPath: fileURLWithPath)
    if let xmlParser = XMLParser(contentsOf: url) {

        xmlParser.shouldResolveExternalEntities = shouldResolveExternalEntities
        xmlParser.externalEntityResolvingPolicy = externalEntityResolvingPolicy
        
        let myParserDelegate: XMLParserDelegate = ParserDelegate(entitiesRestore: entitiesRestore) // just prints
        xmlParser.delegate = myParserDelegate
        
        xmlParser.parse()
    }
}
