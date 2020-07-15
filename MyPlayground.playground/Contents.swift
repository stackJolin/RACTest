/* 相关概念
 ####Swift指针概述
 -  不安全指针类型
 -  类型指针 VS 原始指针
 -  可变指针 VS 不可变指针
 
 ####相关问题
 -  什么是内存逃逸
 */


import UIKit

let count = 2

// 预估大小
let size = MemoryLayout<Int>.size
// 实际大小
let stride = MemoryLayout<Int>.stride
// 对齐字节大小
let alignment = MemoryLayout<Int>.alignment

let byteCount = stride * count

//**********************************************************
// MARK : - 原始指针
//**********************************************************
do {
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment:alignment)
    
    defer {
        pointer.deallocate()
    }
    
    // 将42出入指针指向的内存地址
    pointer.storeBytes(of: 42, as: Int.self)
    
    // 移动指针地址(移动42所占内存的实际大小，也就是一个步长)，将6存入指针(pointer+6)指向的地址
    pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
    
    // 读取第一个值
    pointer.load(as: Int.self)
    
    // 读取第二个值
    pointer.advanced(by: stride).load(as: Int.self)
    
    let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
    
    for (index, byte) in bufferPointer.enumerated() {
        print("byte:\(index):\(byte)")
    }
}

func test(_ a:inout Int) {
    
    var ptr = withUnsafePointer(to: a) { UnsafeRawPointer($0)}
    
    print("1:\(ptr)")
}

var a:Int = 10

test(&a)

var ptr = withUnsafePointer(to: a) { UnsafeRawPointer($0)}

print("1:\(ptr)")
print("1:\(Int.self)")
print("1:\(Int.Type.self)")

struct Zhu {
    var name:String = ""
    
    mutating func chifan() {
        name = "dddd"
        withUnsafeMutablePointer(to: &self) {
            $0.pointee.name = "fff"
        }
    }
    
    func DCBA() {
        
    }
    
    func ABCD() {
        DCBA()
    }
}

//**********************************************************
// MARK : - 类型指针
//**********************************************************
//do {
//    let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
//    UnsafePointer // A pointer for accessing  data of a specific type.
//    UnsafeRawPointer // A raw pointer for accessing untyped data.
//    UnsafeBufferPointer //
//    pointer.withMemoryRebound(to: <#T##T.Type#>, capacity: <#T##Int#>, <#T##body: (UnsafeMutablePointer<T>) throws -> Result##(UnsafeMutablePointer<T>) throws -> Result#>)
//
//    withExtendedLifetime(<#T##x: T##T#>, <#T##body: (T) throws -> Result##(T) throws -> Result#>)
//    withExtendedLifetime(<#T##x: T##T#>, <#T##body: () throws -> Result##() throws -> Result#>)
//
//    withUnsafeMutablePointer(to: &<#T##T#>, <#T##body: (UnsafeMutablePointer<T>) throws -> Result##(UnsafeMutablePointer<T>) throws -> Result#>)
//    withUnsafePointer(to: &<#T##T#>, <#T##body: (UnsafePointer<T>) throws -> Result##(UnsafePointer<T>) throws -> Result#>)
//    withUnsafePointer(to: <#T##T#>, <#T##body: (UnsafePointer<T>) throws -> Result##(UnsafePointer<T>) throws -> Result#>)
//    withUnsafeBytes(of: &<#T##T#>, <#T##body: (UnsafeRawBufferPointer) throws -> Result##(UnsafeRawBufferPointer) throws -> Result#>)
//    withUnsafeBytes(of: <#T##T#>, <#T##body: (UnsafeRawBufferPointer) throws -> Result##(UnsafeRawBufferPointer) throws -> Result#>)
//}


//var nums = Array(1...15)
//nums.self
//
//@dynamicMemberLookup
//struct zhuhoulin1<T> {
//    var name:String = ""
//
//    subscript<U>(dynamicMember member: KeyPath<T, U>) -> U {
//
//    }
//}
//
//let indicesOfEvens = nums.subranges(where: { $0.isMultiple(of: 2) })
