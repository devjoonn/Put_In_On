//
//  UIColor.swift
//  PutItOn
//
//  Created by 박현준 on 2023/03/31.
//

import UIKit

extension UIColor {

    static let mainColor = UIColor.rgb(red: 38, green: 107, blue: 241)
    static let textfieldBackgroundColor = UIColor.rgb(red: 222, green: 222, blue: 222)
    static let unselectedTabbarColor = UIColor.rgb(red: 168, green: 168, blue: 168)
}

// RGB값을 받아서 UIColor를 리턴하는 함수
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
