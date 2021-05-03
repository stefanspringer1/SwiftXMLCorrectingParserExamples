import Foundation

class EntityDeclarationsGetter: NSObject, XMLParserDelegate {
    
    var entityNames: [String] = []
    
    var firstElementEncountered: Bool = false
    
    // Sent by a parser object to its delegate when it encounters a start tag for a given element.
    func parser(_ parser: XMLParser, didStartElement name: String, namespaceURI uri:
    String?, qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:])
    {
        firstElementEncountered = true
        parser.abortParsing()
    }
    
    // Sent by a parser object to its delegate when it encounters a fatal error.
    func parser(_ parser: XMLParser, parseErrorOccurred error: Error) {
        if !firstElementEncountered {
            print("FATAL ERROR: \(error)")
        }
    }
    
    // Sent by a parser object to its delegate when it encounters a fatal validation error. NSXMLParser currently does not invoke this method and does not perform validation.
    func parser(_: XMLParser, validationErrorOccurred error: Error) {
        if !firstElementEncountered {
            print("VALIDATION ERROR: \(error)")
        }
    }
    
    // Sent by a parser object to its delegate when it encounters an external entity declaration.
    func parser(_: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
        print("parsed external entity declaration: name \"\(name)\", public id \"\(publicID ?? "")\", system ID \"\(systemID ?? "")\"")
        print("collecting \"\(name)\"")
        entityNames.append(name)
    }
    
    // Sent by a parser object to the delegate when it encounters an internal entity declaration.
    func parser(_: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
        print("internal entity declaration: name \"\(name)\", value \"\(value ?? "")\"")
        print("collecting \"\(name)\"")
        entityNames.append(name)
    }
    
    // Sent by a parser object to its delegate when it encounters an unparsed entity declaration.
    func parser(_: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
        print("unparsed external entity declaration: name \"\(name)\", public id \"\(publicID ?? "")\", system ID \"\(systemID ?? "")\", notation name \"\(notationName ?? "")\"")
        print("collecting \"\(name)\"")
        entityNames.append(name)
    }
    
}

func getDeclaredEntityNames(fileURLWithPath: String) -> Array<String>? {
    let url = URL(fileURLWithPath: fileURLWithPath)
    if let xmlParser = XMLParser(contentsOf: url) {

        xmlParser.shouldResolveExternalEntities = true
        xmlParser.externalEntityResolvingPolicy = XMLParser.ExternalEntityResolvingPolicy.never
        
        let entityDeclarationsGetter = EntityDeclarationsGetter()
        xmlParser.delegate = entityDeclarationsGetter
        xmlParser.parse()
        
        return entityDeclarationsGetter.entityNames
    }
    return nil
}
