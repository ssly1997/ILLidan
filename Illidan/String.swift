//
//  String.swift
//  Illidan
//
//  Created by 李方长 on 2022/5/2.
//

import Foundation

// 下标拓展 时间复杂度O(1)
extension String {
    // s[2]
    subscript (i: Int) -> Character {
        guard let cString = self.cString(using: .utf8) else {
            return Character("")
        }
        if self == "" {
            return Character("")
        }
        return Character(String(cString: cString[i...i]+[0]))
    }
    // s[0...2]
    subscript (r: Range<Int>) -> String {
        guard let cString = self.cString(using: .utf8) else {
            return ""
        }
        return String(cString: cString[r] + [0])
    }
    // s[0,1] 处理越界todo
    subscript (start start: Int,length length:Int) -> String {
        guard let cString = self.cString(using: .utf8) else {
            return ""
        }
        if start > length + start - 1 {
            return ""
        }
        return String(cString: cString[start...(length + start - 1)] + [0])
    }
    // 处理越界todo
    subscript (start start: Int,end end:Int) -> String {
        guard let cString = self.cString(using: .utf8) else {
            return ""
        }
        if start > end {
            return ""
        }
        return String(cString: cString[start...end] + [0])
    }
}
