//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

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
        return Profile(name: path.url.deletingPathExtension().lastPathComponent, nodes: nodes)
	}

    public static func inspectProfile(at url: URL) throws -> Profile {
        let data = try Data(contentsOf: url)
        let parser = DERParser(data: data)
        let nodes = try parser.parse()
        return Profile(name: url.deletingPathExtension().lastPathComponent, nodes: nodes)
    }
}
