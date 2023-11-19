import SwiftUI

protocol Inspectable {
    var systemIcon: String { get }
    var iconColor: Color { get }
    var type: String { get }
    var description: String { get }
}
