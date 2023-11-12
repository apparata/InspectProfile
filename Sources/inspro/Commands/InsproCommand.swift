import Foundation
import ArgumentParser

struct InsproCommand: AsyncParsableCommand {

	static var configuration = CommandConfiguration(
		commandName: "inspro",
		abstract: "Description of what tool does goes here.",
		subcommands: [
			UICommand.self,
			InspectCommand.self
		])
		
	mutating func run() async throws {
		print(Self.helpMessage())
	}
}
