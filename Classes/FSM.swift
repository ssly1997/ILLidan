//
//  FSM.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/1.
//

import Foundation

public enum TransitionState {
    case success
    case failure
}

public typealias ExecutionBlock = () -> Void
public typealias TransitionBlock = (_ result:TransitionState) -> Void

//包含转换规则的结构体
public struct Transition<State, Event> {
    public let event:Event
    public let source:State
    public let destination:State
    private let preAction:ExecutionBlock?
    private let postAction:ExecutionBlock?
    
    public init(with event:Event,
                from:State,
                to:State,
                preBlock:ExecutionBlock?,
                postBlock:ExecutionBlock?) {
        self.event = event
        self.source = from
        self.destination = to
        self.preAction = preBlock
        self.postAction = postBlock
    }
    
    func executePreAction() {
        preAction?()
    }
    
    func executePostAction() {
        postAction?()
    }
}

public class StateMachine<State:Equatable, Event:Hashable> {
    
    private let lockQueue: DispatchQueue
    private let workingQueue: DispatchQueue
    private let callbackQueue: DispatchQueue
    private var internalCurrentState: State
    
    private var transitionsByEvent: [Event : [Transition<State, Event>]] = [:]

    public var currentState: State {
        return {
            workingQueue.sync {
                return internalCurrentState
            }
        }()
    }
    
    //
    
    /// 状态机初始化方法
    /// - Parameters:
    ///   - initialState: 初始状态
    ///   - callbackQueue: 指定自定义回调队列时最好是串行队列，可以保证内部的回调按顺序执行，默认为主队列
    public init(initialState:State, callbackQueue:DispatchQueue? = nil) {
        self.internalCurrentState = initialState
        self.callbackQueue = callbackQueue ?? .main
        self.workingQueue = DispatchQueue.init(label: "com.illdan.workingQueue")
        self.lockQueue = DispatchQueue.init(label: "com.illdan.lockQueue", attributes: .concurrent)
    }
    
    // 向状态机内添加转换规则
    public func add(transition:Transition<State, Event>) {
        //使用串行队列保证线程安全 写-> 异步+栅栏
        lockQueue.async(group: nil, qos: .default, flags: .barrier) {
            if let transitions = self.transitionsByEvent[transition.event] {
                if transitions.filter({return $0.source == transition.source}).count > 0 {
                    assertionFailure("trasition witn event: \(transition.event) and source: \(transition.source) aleady existing")
                }
                self.transitionsByEvent[transition.event]?.append(transition)
            } else {
                self.transitionsByEvent[transition.event] = [transition]
            }
        }
    }
    
    
    /// 接受事件，处理回调
    /// - Parameters:
    ///   - event: 触发的事件
    ///   - execution: 发生状态转移过程中执行的操作
    ///   - callbackBlock: 状态转移的回调
    public func progress(event:Event, execution:ExecutionBlock? = nil, callback:TransitionBlock? = nil) {
        var transitions: [Transition<State, Event>]?
        // 读 -> 同步+并发队列
        lockQueue.sync {
            transitions = self.transitionsByEvent[event]
        }
        
        workingQueue.async {
            let performTransitions = transitions?.filter({ $0.source == self.internalCurrentState }) ?? []
            if performTransitions.isEmpty {
                self.callbackQueue.async { callback?(.failure) }
                return
            }
            // 愿状态和触发事件 确定的情况下只能有一个 transition
            assert(performTransitions.count == 1, "Found multiple transitions with event \(event) and source \(self.internalCurrentState)")
            
            let transition = performTransitions.first!
            
            //先执行该Transition中的preAction
            self.callbackQueue.async {
                transition.executePreAction()
            }
            // 然后执行Process方法中传入的执行操作Block
            self.callbackQueue.async {
                execution?()
            }
            // 接着改变状态机当前状态
            self.internalCurrentState = transition.destination
            // 然后是执行该Transition中的postAction
            self.callbackQueue.async {
                transition.executePostAction()
            }
            // 最后执行成功的回调
            self.callbackQueue.async {
                callback?(.success)
            }
        }
        
    }
}
