//
//  UIFont.swift
//  PutItOn
//
//  Created by 박현준 on 2023/04/06.
//

import UIKit

enum PretendardFont: CaseIterable {
    case pretendardBlack
    case pretendardBold
    case pretendardLight
    case pretendardMedium
    case pretendardRegular
    case pretendardThin
    
    
    var fontName: String {
        switch self {
        case .pretendardBlack: return "Pretendard-Black"
        case .pretendardBold: return "Pretendard-Bold"
        case .pretendardLight: return "Pretendard-Light"
        case .pretendardMedium: return "Pretendard-Medium"
        case .pretendardRegular: return "Pretendard-Medium"
        case .pretendardThin: return "Pretendard-Thin"
        }
    }
}

enum Cafe24SsurroundFont: CaseIterable {
    case cafe24Ssurround
    
    var fontName: String {
        switch self {
        case .cafe24Ssurround: return "Cafe24Ssurround"
        }
    }
}

extension UIFont {
    static func cafe24Ssurround(size: CGFloat) -> UIFont {
        return UIFont(name: Cafe24SsurroundFont.cafe24Ssurround.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendard(font: PretendardFont, size: CGFloat) -> UIFont {
        return UIFont(name: font.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: PretendardFont.pretendardRegular.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardBold(size: CGFloat) -> UIFont {
        return UIFont(name: PretendardFont.pretendardBold.fontName, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}

