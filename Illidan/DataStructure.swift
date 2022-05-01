//
//  DataStructure.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/2.
//

import Foundation

//MARK: 队列
public struct Queue<T> {
    fileprivate var array = Array<T>()
    public var isEmpty:Bool {
        return array.count == 0
    }
    public var size:Int {
        return array.count
    }
    public mutating func enQueue(_ element:T) {
        array.append(element)
    }
    public mutating func deQueue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    public func peek() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.first
        }
    }
}
// 方便调试
extension Queue:CustomStringConvertible {
    public var description: String {
        let topDivider = "---Queue---\n"
        let bottomDivider = "-----------\n"
        var content = ""
        for item in array {
            content += "\(item)\n"
        }
        return topDivider + content + bottomDivider
    }
}

//MARK: 栈
public struct Stack<T> {
    fileprivate var array = Array<T>()
    public var isEmpty:Bool {
        return array.count == 0
    }
    public var size:Int {
        return array.count
    }
    public mutating func push(_ element:T?) {
        if let element = element {
            array.append(element)
        }
    }
    public mutating func pop() -> T? {
        //popLast在数组为空时返回nil
        return array.popLast()
    }
    public func peek() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.last
        }
    }
}

extension Stack:CustomStringConvertible {
    public var description: String {
        let topDivider = "---Stack---\n"
        let bottomDivider = "-----------\n"
        var content = ""
        for item in array {
            content += "\(item)\n"
        }
        return topDivider + content + bottomDivider
    }
}

//MARK: 二叉树
public class TreeNode {
    public var val:Int = 0
    public var left:TreeNode?
    public var right:TreeNode?
    
    public init() {
        self.val = 0
    }
    
    public init(_ value:Int) {
        self.val = value
    }
    
    public init(_ val: Int=0, _ left: TreeNode?=nil, _ right: TreeNode?=nil) {
        self.val = val
        self.left = left
        self.right = right
    }
}

extension TreeNode {
    public convenience init?(_ array:[Int?]) {
        self.init()
        let node = TreeNode.arrayToTree(array)
        if node == nil {
            return nil
        }
        self.val = node!.val
        self.left = node?.left
        self.right = node?.right
    }
    // leetCode转化格式
    class func treeToArray(_ node:TreeNode?) -> [Int?] {
        guard let node = node else {
            return []
        }
        var queue = Queue<TreeNode>()
        var res = [Int?]()
        let maxLevel = node.level()
        var curLevel = 1
        queue.enQueue(node)
        queue.enQueue(TreeNode.init(Int.min))
        while queue.size > 1 {
            let new = queue.deQueue()
            if new!.val == Int.min {
                queue.enQueue(TreeNode.init(Int.min))
                curLevel += 1
                continue
            }
            if new!.val == Int.max {
                res.append(nil)
                continue
            }
            res.append(new?.val)
            if new?.left != nil {
                queue.enQueue(new!.left!)
            } else {
                if curLevel < maxLevel {
                    queue.enQueue(TreeNode.init(Int.max))
                }
            }
            if new?.right != nil {
                queue.enQueue(new!.right!)
            } else {
                if curLevel < maxLevel {
                    queue.enQueue(TreeNode.init(Int.max))
                }
            }
        }
        return res
    }
    
    // leetCode转化格式 假定给出的数据都是能构成一个二叉树的
    class func arrayToTree(_ array:[Int?]) -> TreeNode? {
        var res:TreeNode? = nil
        if array.isEmpty || array.first! == nil {
            return res
        }
        var queue = Queue<TreeNode>()
        res = TreeNode.init(array.first!!)
        queue.enQueue(res!)
        var index = 1
        while !queue.isEmpty {
            let node = queue.deQueue()
            if node?.left == nil && index < array.count && array[index] != nil {
                node?.left = TreeNode.init(array[index]!)
                queue.enQueue(node!.left!)
            }
            index += 1
            if index == array.count {
                return res
            }
            if node?.right == nil && index < array.count && array[index] != nil {
                node?.right = TreeNode.init(array[index]!)
                queue.enQueue(node!.right!)
            }
            index += 1
            if index == array.count {
                return res
            }
        }
        return res
    }
    
    func level() -> Int {
        let calLevel = {(_ node:TreeNode?) -> Int in
            guard let node = node else {
                return 0
            }
            var level = 1
            var queue = Queue<TreeNode>()
            queue.enQueue(node)
            queue.enQueue(TreeNode.init(Int.min))
            while queue.size > 1 {
                let node = queue.deQueue()!
                if node.val == Int.min {
                    queue.enQueue(TreeNode.init(Int.min))
                    level += 1
                }
                if node.left != nil {
                    queue.enQueue(node.left!)
                }
                if node.right != nil {
                    queue.enQueue(node.right!)
                }
            }
            return level
        }
        return calLevel(self)
    }
}

//MARK: 堆
//大顶堆 大顶堆的构建过程就是从最后一个非叶子结点开始从下往上调整
struct MaxHeap<T:Comparable>:CustomStringConvertible {
    private var array = [T]()
    var size:Int {
        return array.count
    }
    
    init(_ array:[T]) {
        self.array = array
        //adjust
        adjust(size)
    }
    
    mutating func insert(_ element:T) {
        array.append(element)
        adjust(size)
    }
    
    mutating func delete() {
        array.removeFirst()
        adjust(size)
    }
    
    // 自下而上的调整 [3, 0, 1, 8, 2, 4, 5]
    mutating func adjust(_ len:Int) {
        if (len > size) {
            assert(false, "error")
        }
        for i in (0...len/2-1).reversed() {
            let left = i<<1+1
            let right = i<<1+2
            //根结点小于左子树
            if left < len && array[left] > array[i] {
                array.swapAt(i, left)
                //再判断左子树是否符合大顶堆性质
                if ((left<<1+1 < len && array[left<<1+1] > array[left]) || (left<<1+2 < len && array[left<<1+2] > array[left])) {
                    adjust(len)
                }
            }
            //根结点小于右子树
            if right < len && array[right] > array[i] {
                array.swapAt(i, right)
                //在判断右子树是否符合大顶堆性质
                if ((right<<1+1 < len && array[right<<1+1] > array[right]) || (right<<1+2 < len && array[right<<1+2] > array[right])) {
                    adjust(len)
                }
            }
        }
    }
    
    var description: String {
        return "\(array)"
    }
}

struct MinHeap<T:Comparable>:CustomStringConvertible {
    private var array = [T]()
    var size:Int {
        return array.count
    }
    var isEmpty:Bool {
        return array.isEmpty
    }
    
    init(_ array:[T]) {
        self.array = array
        //adjust
        adjust(size)
    }
    
    mutating func insert(_ element:T) {
        array.append(element)
        adjust(size)
    }
    
    mutating func delete() {
        array.removeFirst()
        adjust(size)
    }
    
    mutating func pop()->T? {
        if array.isEmpty {
            return nil
        } else {
            let pop = array.removeFirst()
            if size > 1{
                adjust(size)
            }
            return pop
        }
    }
    
    // 自下而上的调整 [3, 0, 1, 8, 2, 4, 5]
    mutating func adjust(_ len:Int) {
        if (len > size) {
            assert(false, "error")
        }
        if len <= 1 {
            return
        }
        for i in (0...len/2-1).reversed() {
            let left = i<<1+1
            let right = i<<1+2
            //根结点大于左子树
            if left < len && array[left] < array[i] {
                array.swapAt(i, left)
                //再判断左子树是否符合小顶堆性质
                if ((left<<1+1 < len && array[left<<1+1] < array[left]) || (left<<1+2 < len && array[left<<1+2] < array[left])) {
                    adjust(len)
                }
            }
            //根结点大于右子树
            if right < len && array[right] < array[i] {
                array.swapAt(i, right)
                //在判断右子树是否符合小顶堆性质
                if ((right<<1+1 < len && array[right<<1+1] < array[right]) || (right<<1+2 < len && array[right<<1+2] < array[right])) {
                    adjust(len)
                }
            }
        }
    }
    
    var description: String {
        return "\(array)"
    }
}
