import Foundation
import ArgumentParser

struct UICommand: AsyncParsableCommand {
	
	static var configuration = CommandConfiguration(
		commandName: "ui",
		abstract: "Run inspro with a UI.",
		discussion: "Run inspro with a UI for creating font Swift packages.")
	
	mutating func run() async throws {
		print("This is a dummy command. If you see this, something failed.")
	}
}
