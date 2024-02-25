//
//  ImageSearchAppTests.swift
//  ImageSearchAppTests
//
//  Created by Karan Jaiswal on 25/02/24.
//

import XCTest
@testable import ImageSearchApp

final class SearchScreenTest: XCTestCase {
    
    func testResetImage() throws {
        let resultCount = 0
        let mockViewModel: SearchViewModel = SearchViewModel()
        mockViewModel.imageUrl.append("data1")
        mockViewModel.resetImageData()
        XCTAssert(mockViewModel.imageUrl.count == resultCount)
    }
    
    
}
