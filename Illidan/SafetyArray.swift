//
//  SafetyArray.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/2.
//

import Foundation

// 线程安全的字典建议使用NSCache
// 只能定义为class 不能定义为struct 因为struct是值类型，在闭包将其内部的值捕获后会做copy，赋值无效
public class SafetyArray<T> {
    private var lockQueue:DispatchQueue
    private var array = [T]()
    init() {
        self.lockQueue = DispatchQueue.global()
        self.lockQueue = DispatchQueue.init(label: "com.illidan.safeQueue_\(self)", attributes: .concurrent)
    }
}

//MARK: 读操作
public extension SafetyArray {
    func first() -> T? {
        return {
            lockQueue.sync {
                return array.first
            }
        }()
    }
    
    func last() -> T? {
        return {
            lockQueue.sync {
                return array.last
            }
        }()
    }
    
    subscript(index:Int) -> T {
        get {
            return {
                lockQueue.sync {
                    assert(index < array.count, "illidan safety array: array out of bounds")
                    return array[index]
                }
            }()
        }
        set {
            lockQueue.async(group: nil, qos: .default, flags: .barrier) {
                assert(index < self.array.count, "illidan safety array: array out of bounds")
                self.array[index] = newValue
            }
        }
    }
}

//MARK: 写操作
public extension SafetyArray {
   
    func append(_ newElement:T) {
        lockQueue.async(group: nil, qos: .default, flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
}
