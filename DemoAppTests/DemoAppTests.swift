//
//  DemoAppTests.swift
//  DemoAppTests
//
//  Created by Apple on 24/10/24.
//

import XCTest
@testable import DemoApp

final class DemoAppTests: XCTestCase {

    var viewModel: APODViewModel!
       var mockService: MockAPODService!

       override func setUp() {
           super.setUp()
           mockService = MockAPODService()
           viewModel = APODViewModel(service: mockService)
       }

       override func tearDown() {
           viewModel = nil
           mockService = nil
           super.tearDown()
       }

       // MARK: - Test Cases

       // 1. Test successful data fetching
       func testFetchAPODsSuccess() {
           // Given
           let mockAPODs = [APODModel(date: nil, explanation: "test_url_1", url: "test_url_1", title: "Test APOD 1"), APODModel(date: nil, explanation: "test_url_2", url: "test_url_2", title: "Test APOD 2")]
           mockService.apodsToReturn = mockAPODs

           let expectation = self.expectation(description: "APODs fetched successfully")

           // When
           viewModel.onDataFetched = {
               expectation.fulfill()

               // Then
               XCTAssertEqual(self.viewModel.numberOfItems(), 2)
               XCTAssertEqual(self.viewModel.apod(at: 0).title, "Test APOD 2")
               XCTAssertEqual(self.viewModel.apod(at: 1).title, "Test APOD 1")
           }

           viewModel.fetchAPODs()

           // Wait for the async call to finish
           waitForExpectations(timeout: 2.0, handler: nil)
       }

       // 2. Test fetchAPODs failure scenario
       func testFetchAPODsFailure() {
           // Given
           mockService.errorToReturn = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network Error"])

           let expectation = self.expectation(description: "APODs fetch failed")
           expectation.isInverted = true  // Expect the failure, but don't expect a successful callback

           // When
           viewModel.onDataFetched = {
               expectation.fulfill()
           }

           viewModel.fetchAPODs()

           // Then
           waitForExpectations(timeout: 2.0) { error in
               XCTAssertEqual(self.viewModel.numberOfItems(), 0)
           }
       }

       // 3. Test pagination (currentPage increment)
       func testPagination() {
           // Given
           let mockAPODs = [APODModel(date: nil, explanation: "test_url_1", url: "test_url_1", title: "Test APOD 1")]
           mockService.apodsToReturn = mockAPODs

           // When
           viewModel.fetchAPODs()

           // Then
           XCTAssertEqual(viewModel.numberOfItems(), 1)
           XCTAssertEqual(viewModel.apod(at: 0).title, "Test APOD 1")
           XCTAssertEqual(viewModel.currentPage, 2)  // Make sure the page was incremented
       }
}
