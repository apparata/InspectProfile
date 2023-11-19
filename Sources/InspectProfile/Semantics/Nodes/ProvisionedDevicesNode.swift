import Foundation

public struct ProvisionedDevicesNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "Provisioned Devices"

    public var description: String {
        String(devices.count)
    }

    public var children: [Node]? = nil

    public let devices: [String]

    public init(devices: [String]) {
        self.devices = Array(Set(devices)).sorted()
    }
}
