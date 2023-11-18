import Foundation

extension Sequence {
        
    public func dictionary<Key: Hashable>(keyedBy keyPath: KeyPath<Element, Key>) -> [Key: Element] {
        reduce(into: [:]) { $0[$1[keyPath: keyPath]] = $1 }
    }
}
