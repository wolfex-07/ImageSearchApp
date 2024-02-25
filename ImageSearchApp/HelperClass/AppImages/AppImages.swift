//
//  AppImages.swift
//  MVVM_Prototype
//
//  Created by Ai on 25/02/24.
//

import Foundation

enum AppImages: String {
    case photosPlaceholder = "placeholderImg"
    case rightItemImage = "ellipsis.circle"
    
    func baseString() -> String {
        return self.rawValue
    }
}
