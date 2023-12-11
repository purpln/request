/*
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif
 

public extension Body{
case buffer(Buffer)
case stream(BufferStream)
    
    static func bytes(_ array: [UInt8]) -> Self {
        .buffer(Buffer())
    }
}


public class BufferStream {
    
}

public struct BufferSlice {
    
}

public struct Buffer {
    @usableFromInline typealias Slice = BufferSlice
    @usableFromInline typealias Allocator = BufferAllocator
    
    public typealias Index = UInt32
    public typealias Capacity = UInt32
    
    @usableFromInline var storage: Storage
    @usableFromInline var readerIndex: Index
    @usableFromInline var writerIndex: Index
    @usableFromInline var slice: Slice
    
    @usableFromInline class Storage {
        @usableFromInline private(set) var bytes: UnsafeMutableRawPointer
        @usableFromInline private(set) var capacity: Capacity
        @usableFromInline let allocator: BufferAllocator
        
        init(bytesNoCopy: UnsafeMutableRawPointer, capacity: Capacity, allocator: BufferAllocator) {
            self.bytes = bytesNoCopy
            self.capacity = capacity
            self.allocator = allocator
        }
        
        deinit {
            self.deallocate()
        }
        
        @inlinable
        var fullSlice: BufferSlice {
            return BufferSlice(0..<self.capacity)
        }
        
        private func deallocate() {
            allocator.free(bytes)
        }
        
        @inlinable
        static func reallocated(minimumCapacity: Capacity, allocator: Allocator) -> Storage {
            
        }
    }
    
    @inlinable init(allocator: BufferAllocator, startingCapacity: Int) {
        let startingCapacity = _toCapacity(startingCapacity)
        self.readerIndex = 0
        self.writerIndex = 0
        self.storage = Storage.reallocated(minimumCapacity: startingCapacity, allocator: allocator)
        self.slice = self.storage.fullSlice
    }
}

@usableFromInline let sysMalloc: @convention(c) (size_t) -> UnsafeMutableRawPointer? = malloc
@usableFromInline let sysRealloc: @convention(c) (UnsafeMutableRawPointer?, size_t) -> UnsafeMutableRawPointer? = realloc
@usableFromInline let sysFree: @convention(c) (UnsafeMutableRawPointer) -> Void = { free($0) }

public struct BufferAllocator: Sendable {
    @inlinable public init() {
        self.init(hookedMalloc: { sysMalloc($0) },
                  hookedRealloc: { sysRealloc($0, $1) },
                  hookedFree: { sysFree($0) },
                  hookedMemcpy: { $0.copyMemory(from: $1, byteCount: $2) })
    }
    
    @inlinable
    internal init(hookedMalloc: @escaping @convention(c) (size_t) -> UnsafeMutableRawPointer?,
                  hookedRealloc: @escaping @convention(c) (UnsafeMutableRawPointer?, size_t) -> UnsafeMutableRawPointer?,
                  hookedFree: @escaping @convention(c) (UnsafeMutableRawPointer) -> Void,
                  hookedMemcpy: @escaping @convention(c) (UnsafeMutableRawPointer, UnsafeRawPointer, size_t) -> Void) {
        self.malloc = hookedMalloc
        self.realloc = hookedRealloc
        self.free = hookedFree
        self.memcpy = hookedMemcpy
    }
    
    @inlinable
    public func buffer(capacity: Int) -> Buffer {
        precondition(capacity >= 0, "ByteBuffer capacity must be positive.")
        guard capacity > 0 else {
            return BufferAllocator.zero
        }
        return Buffer(allocator: self, startingCapacity: capacity)
    }
    
    @usableFromInline
    internal static let zero = Buffer(allocator: BufferAllocator(), startingCapacity: 0)
    
    @usableFromInline internal let malloc: @convention(c) (size_t) -> UnsafeMutableRawPointer?
    @usableFromInline internal let realloc: @convention(c) (UnsafeMutableRawPointer?, size_t) -> UnsafeMutableRawPointer?
    @usableFromInline internal let free: @convention(c) (UnsafeMutableRawPointer) -> Void
    @usableFromInline internal let memcpy: @convention(c) (UnsafeMutableRawPointer, UnsafeRawPointer, size_t) -> Void
}

*/
