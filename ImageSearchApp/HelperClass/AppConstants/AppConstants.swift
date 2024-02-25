//
//  StringConstants.swift
//  MVVM_Prototype
//
//  Created by Karan Jaiswal on 25/02/24.
//

import Foundation

enum AppConstants {
    
    enum AppStrings: String {
        case empty = ""
        case seacrhBarPlaceholder = "Search anything here..."
        case gridWithTwoColoumns = "Grid - 2"
        case gridWithThreeColoumns = "Grid - 3"
        case gridWithFourColoumns = "Grid - 4"
        case cancel = "Cancel"
        
        func baseString() -> String {
            return self.rawValue
        }
    }
    
    enum CellIdentifiers: String {
        case photoCollectionCell = "PhotoCollectionCell"
        case footerLoaderView = "FooterLoaderView"
        case detailViewController = "DetailViewController"
        
        func baseString() -> String {
            return self.rawValue
        }
    }
    
    enum StoryboardName: String {
        case main = "Main"
        
        func baseString() -> String {
            return self.rawValue
        }
        
    }
}


