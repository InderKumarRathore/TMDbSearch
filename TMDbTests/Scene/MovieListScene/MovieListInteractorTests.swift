//
//  MovieListInteractorTests.swift
//  TMDbTests
//
//  Created by Inder Kumar Rathore on 09/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import XCTest
@testable import TMDb

class MovieListInteractorTests: XCTestCase {
  
  class MovieListPresenterSpy: MovieListPresentationLogic {
    var presentFetchedObjectsCalled = false
    var showErrorCalled = false
    func presentFetchedObjects(movies: [MovieServiceObject], canLoadNewPages: Bool) {
      presentFetchedObjectsCalled = true
    }
    func showError(statusCode: Int, error: Error?) {
      showErrorCalled = true
    }
  }
  
  class SearchSucessStoreSpy: SearchStorProtocol {
    func fetchMovies(searchText: String, pageNumber: Int, success: @escaping SearchStorProtocol.SuccessClosure, failed: @escaping SearchStorProtocol.FailureClosure) {
      success([MovieServiceObject](), 1, 5)
    }
  }
  
  class SearchFailureStoreSpy: SearchStorProtocol {
    func fetchMovies(searchText: String, pageNumber: Int, success: @escaping SearchStorProtocol.SuccessClosure, failed: @escaping SearchStorProtocol.FailureClosure) {
      failed(404, nil)
    }
  }
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  /// View controller should call interector's fetch page
  func testSuccessFetchMovies() {
    let sut = MovieListInteractor(searchStore: SearchSucessStoreSpy())
    let presenter = MovieListPresenterSpy()
    sut.presenter = presenter
    sut.fetchNextPage()
    XCTAssert(presenter.presentFetchedObjectsCalled, "Should tell presenter to present fetched objets.")
  }
  
  func testFailureFetchMovies() {
    let sut = MovieListInteractor(searchStore: SearchFailureStoreSpy())
    let presenter = MovieListPresenterSpy()
    sut.presenter = presenter
    sut.fetchNextPage()
    XCTAssert(presenter.showErrorCalled, "Should tell presenter to present error.")
  }
}

