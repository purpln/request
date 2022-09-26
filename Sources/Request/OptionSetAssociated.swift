public protocol OptionSetAssociated: OptionSet where RawValue: FixedWidthInteger {
    var store: [RawValue: Any] { get set }
}

extension OptionSetAssociated {
    public init<T>(_ member: Self, value: T) {
        self.init(rawValue: member.rawValue)
        self.store[member.rawValue] = value
    }
    
    public init<T>(rawValue: RawValue, value: T) {
        self.init(rawValue: rawValue)
        self.store[rawValue] = value
    }
    
    fileprivate init(rawValue: RawValue, store: [RawValue: Any]) {
        self.init(rawValue: rawValue)
        self.store = store
    }
    
    fileprivate static func combinedStore(_ old: [RawValue: Any], new: [RawValue: Any]) -> [RawValue: Any] {
        new.map {$0.key}.reduce(into: old) {
            $0[$1] = new[$1] ?? old[$1]
        }
    }
    
    fileprivate static func storeOverride(_ store: [RawValue: Any], member: Self?, value: Any?) -> [RawValue: Any] {
        guard let member: RawValue = member?.rawValue else { return store }
        var store: [RawValue: Any] = store
        store[member] = value
        return store
    }
    
    public func getValue<T>(for member: Self) -> T? {
        self.store[member.rawValue] as? T
    }

    mutating public func formUnion(_ other: __owned Self) {
        self = Self(rawValue: self.rawValue | other.rawValue, store: Self.combinedStore(self.store, new: other.store))
    }
}

extension OptionSet where Self: OptionSetAssociated, Self == Element {
    @discardableResult
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let oldMember = self.intersection(newMember)
        let shouldInsert = oldMember != newMember
        var result = (
            inserted: shouldInsert,
            memberAfterInsert: shouldInsert ? newMember : oldMember)
        if shouldInsert {
            self.formUnion(newMember)
        } else {
            self.store = Self.storeOverride(
                Self.combinedStore(self.store, new: newMember.store),
                member: newMember, value: newMember.store[newMember.rawValue])
            result.memberAfterInsert.store[newMember.rawValue] = newMember.store[newMember.rawValue]
        }
        return result
    }
    
    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        var intersectionElements = intersection(member)
        guard !intersectionElements.isEmpty else {
            return nil
        }
        let store: [RawValue: Any] = self.store
        self.subtract(member)
        self.store = store
        self.store[member.rawValue] = nil
        intersectionElements.store = Self.storeOverride([:], member: member, value: store[member.rawValue])
        return intersectionElements
    }
    
    @discardableResult
    public mutating func update(with newMember: Element) -> Element? {
        let previousValue: Any? = self.store[newMember.rawValue]
        var r = self.intersection(newMember)
        self.formUnion(newMember)
        self.store[newMember.rawValue] = newMember.store[newMember.rawValue]
        if r.isEmpty { return nil } else {
            r.store = Self.storeOverride([:], member: newMember, value: previousValue)
            r.store[newMember.rawValue] = previousValue
            return r
        }
    }
}

extension OptionSetAssociated where Self: Sequence {
    public typealias Iterator = OptionSetAssociatedIterator
    
    public func makeIterator() -> OptionSetAssociatedIterator<Self> {
        OptionSetAssociatedIterator(element: self)
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        rhs.reduce(into: lhs) { $0.remove($1) }
    }
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        rhs.reduce(into: lhs) { $0.insert($1) }
    }
    
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

extension OptionSetAssociated {
    public subscript<T>(for member: Self) -> T? {
        store[member.rawValue] as? T
    }
}

public struct OptionSetAssociatedIterator<Element: OptionSetAssociated>: IteratorProtocol {
    private let value: Element
    
    public init(element: Element) {
        self.value = element
    }
    
    private lazy var remainingBits: Element.RawValue = value.rawValue
    private var bitMask: Element.RawValue = 1
    
    public mutating func next() -> Element? {
        while remainingBits != 0 {
            defer { bitMask = bitMask &* 2 }
            if remainingBits & bitMask != 0 {
                remainingBits = remainingBits & ~bitMask
                return Element(rawValue: bitMask, value: self.value.store[bitMask])
            }
        }
        return nil
    }
}
