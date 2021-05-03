import Foundation

let fileManager = FileManager.default

fileManager.changeCurrentDirectoryPath(fileManager.currentDirectoryPath + "/Samples")
print("working directory: [\(fileManager.currentDirectoryPath)]")

var docPath = "test0.xml"
print("document: [\(docPath)]")

let entPath = "external1.ent"
if fileManager.fileExists(atPath: entPath) {
    print("[\(entPath)] exists")
}
else {
    print("missing \(entPath)")
}

print("""

----------------------------------------------------------------
    GETTING NAMES OF DECLARED ENTITIES, PREPARE REPLACEMENTS
----------------------------------------------------------------

""")

var temporaryEntityNamesReplacements = Dictionary<String,String>()
var entitiesRestore = Dictionary<String,String>()

var entCount = 0
if let entityNames = getDeclaredEntityNames(fileURLWithPath: docPath) {
    entityNames.forEach { entityName in
        entCount += 1
        let newName = "temporaryEntityName\(entCount)"
        temporaryEntityNamesReplacements["&\(entityName);"] = "&\(newName);"
        entitiesRestore[newName] = entityName
    }
}

temporaryEntityNamesReplacements.forEach { _in, _out in
    print("will replace \"\(_in)\" by \"\(_out)\"")
}

entitiesRestore.forEach { _in, _out in
    print("will replace back \"\(_in)\" by \"\(_out)\"")
}

let tmpFile = "\(docPath).tmp.xml"

print("""

----------------------------------------------------------------
    REPLACING ENTITIES, WRITING TO \(tmpFile)
----------------------------------------------------------------

""")

replaceMany(inFile: docPath, replacements: temporaryEntityNamesReplacements, toFile: tmpFile)

print("""

----------------------------------------------------------------
    PARSING \(tmpFile)
----------------------------------------------------------------

""")

parse(fileURLWithPath: tmpFile, entitiesRestore: entitiesRestore)
