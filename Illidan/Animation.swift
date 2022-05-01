//
//  Animation.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/2.
//

import Foundation
import UIKit

extension CAAnimation:CAAnimationDelegate {
    private struct AssociatedKeys {
        static var finishBlock: Void?
    }
    var finishBlock:((_ anim:CAAnimation,_ animationFinished:Bool) -> Void)?{
        set {
            delegate = self
            objc_setAssociatedObject(self, &AssociatedKeys.finishBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.finishBlock) as? (CAAnimation, Bool) -> Void
        }
    }
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(finishBlock != nil) {
            finishBlock!(anim, flag)
        }
        delegate = nil
    }
}
