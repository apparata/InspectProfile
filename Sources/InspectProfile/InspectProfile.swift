import Foundation
import SwiftUI
import AppKit
import SystemKit

public class InspectProfile {

	public static func inspectProfile(at inputPath: String) throws -> Profile {
        let path = SystemKit.Path(inputPath)
        let data = try Data(contentsOf: path.url)
        let parser = DERParser(data: data)
        let nodes = try parser.parse()
        let semanticNodes = try Semantics().processNodes(nodes)
        return Profile(
            name: path.url.deletingPathExtension().lastPathComponent,
            url: path.url,
            data: data,
            nodes: nodes,
            semanticNodes: semanticNodes
        )
	}

    public static func inspectProfile(at url: URL) throws -> Profile {
        let data = try Data(contentsOf: url)
        let parser = DERParser(data: data)
        let nodes = try parser.parse()
        let semanticNodes = try Semantics().processNodes(nodes)
        return Profile(
            name: url.deletingPathExtension().lastPathComponent,
            url: url,
            data: data,
            nodes: nodes,
            semanticNodes: semanticNodes
        )
    }
}
