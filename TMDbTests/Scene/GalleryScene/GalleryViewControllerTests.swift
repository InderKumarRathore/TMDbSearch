//
//  SearchViewControllerTests.swift
//  TMDbTests
//
//  Created by Inder Kumar Rathore on 06/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import XCTest
@testable import TMDb

class SearchViewControllerTests: XCTestCase {
  
  // MARK:
  class SearchInteractorSpy: SearchBusinessLogic {
    var isFetchPageCalled = false
    
    func fetchPage(isNewSearch: Bool, text: String?) {
      isFetchPageCalled = true
    }
  }
  
  var sut: SearchViewController!
  var window: UIWindow!
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  /// View controller should call interector's fetch page
  func testSearchNewText() {
    let SearchInteractor = SearchInteractorSpy()
    sut.interactor = SearchInteractor
    
    let searchBar = UISearchBar(frame: .zero)
    searchBar.text = "kittens"
    sut.searchBarSearchButtonClicked(searchBar)
    
    XCTAssert(SearchInteractor.isFetchPageCalled, "Should ask interactor to serach")

  }
}
