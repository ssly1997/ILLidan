//
//  ViewController.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/1.
//

import UIKit

enum EventType {
    case clickWalkButton
    case clickRunButton
}

enum StateType {
    case walk
    case run
}

typealias StateMachineDefault = StateMachine<StateType, EventType>
typealias TransitionDefault = Transition<StateType, EventType>

class ViewController: UIViewController {

    let stateMachine = StateMachineDefault.init(initialState: .walk)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        initialStateMachine()
//
//        stateMachine.progress(event: .clickRunButton) {
//            print("哈哈")
//        }
//
//        stateMachine.progress(event: .clickRunButton) {
//            print("??")
//        }
//
//        stateMachine.progress(event: .clickWalkButton)
        
        
        let array = SafetyArray<Int?>()
        
        array.append(nil)
        
        print("🇨🇳",array[0])
        
    }
    
    func initialStateMachine() {

        let a = TransitionDefault.init(with: .clickWalkButton, from: .run, to: .walk) {
            NSLog("准备走")
        } postBlock: {
            NSLog("开始走了")
        }

        let b = TransitionDefault.init(with: .clickRunButton, from: .walk, to: .run) {
            NSLog("准备跑")
        } postBlock: {
            NSLog("开始跑了")
        }

        stateMachine.add(transition: a)
        stateMachine.add(transition: b)
    }


}



