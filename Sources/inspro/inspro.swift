//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import Foundation

@main
struct Inspro {
	static func main() async throws {
		let arguments = ProcessInfo.processInfo.arguments
		if arguments.count > 1, arguments[1] == "ui" {
			InsproApp.main()
		} else {
			await InsproCommand.main()
		}
	}
}
