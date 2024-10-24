//
//  MockAPODService.swift
//  DemoAppTests
//
//  Created by Apple on 24/10/24.
//

import XCTest
@testable import DemoApp

final class MockAPODService: APODService {
    var apodsToReturn: [APODModel]?
       var errorToReturn: Error?
       
    override func fetchPictures(startDate: String, endDate: String, completion: @escaping ([APODModel]?) -> Void) {
           if let error = errorToReturn {
               completion(nil)
           } else {
               completion(apodsToReturn)
           }
       }

}
