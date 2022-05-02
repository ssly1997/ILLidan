//
//  ViewController.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/1.
//

import UIKit
import SnapKit
import Illidan

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

class SDZCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let label = UILabel()
        label.text = "你好"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SDZCell") ?? SDZCell()
        cell.transform = CGAffineTransform.init(rotationAngle: -(.pi)*1.5)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    let stateMachine = StateMachineDefault.init(initialState: .walk)

    lazy var tableView:UITableView = {
        let view = UITableView()
        view.register(SDZCell.self, forCellReuseIdentifier: "SDZCell")
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.orange
        view.showsVerticalScrollIndicator = false
//        view.frame = CGRect.init(x: 100, y: 0, width: 100, height: self.view.bounds.height)
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.width.equalTo(100)
            make.left.equalTo(view.snp.left).offset(100)
        }
        view.transform = CGAffineTransform.init(rotationAngle: -(.pi)/2)

        
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
        
        stateMachine.progress(event: .clickRunButton) {
            print("哈哈")
        }

        stateMachine.progress(event: .clickRunButton) {
            print("??")
        }

        stateMachine.progress(event: .clickWalkButton)
    }


}



