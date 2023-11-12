import Foundation
import ArgumentParser
import InspectProfile

struct InspectCommand: AsyncParsableCommand {
	
	static var configuration = CommandConfiguration(
		commandName: "inspect",
		abstract: "Inspect a .mobileprovision file.",
		discussion: "Attempt to decode the CMS wrapper and display info about the file.")
	
	@Argument(help: "Path to something.")
	var path: String

	mutating func run() async throws {
				
		do {
			_ = try InspectProfile.inspectProfile(at: path)
		} catch {
			print(error.localizedDescription)
			Self.exit(withError: error)
		}
	}
}
