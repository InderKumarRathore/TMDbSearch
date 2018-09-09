//
//  SearchInteractor.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 06/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import Foundation


protocol SearchBusinessLogic {
  
  /// Gets the previous searched texts based on  searched text
  ///
  /// - Parameter text: text to be matched, if nil then returns all the text
  func fetchPreviousSearchList(text: String?)
  
  /// Searches the movie on tmdb
  ///
  /// - Parameter text: movie to be searched
  func searchMovies(text: String)
}


class SearchInteractor {
  // Presenter
  var presenter: SearchPresentationLogic?
  // Auto suggestion store
  private let autoSuggestionStore: AutoSuggestionStoreProtocol
  
  /// Default init
  init() {
    self.autoSuggestionStore = AutoSuggestionStore()
  }
  
  
  /// Parameterized initializer
  /// Keeping this for testing purpose, so that I can inject data store dependencies in ti
  ///
  /// - Parameter autoSuggestionStore: AutoSuggestionStoreProtocol object
  init(autoSuggestionStore: AutoSuggestionStoreProtocol) {
    self.autoSuggestionStore = autoSuggestionStore
  }
}

// MARK:- SearchBusinessLogic
extension SearchInteractor: SearchBusinessLogic {
  func fetchPreviousSearchList(text: String?) {
    // Get the auto suggested list and max limit is 10 objects
    var array = self.autoSuggestionStore.getSearchList(text: text)
    if text != nil && !(text!.isEmpty) {
      // Show the filtered list it in sorted order
      array.sort()
    }
    else {
      // Show the full list it in reverse order (i.e. latest search on the top)
      array.reverse()
    }
    self.presenter?.presentFetchedSearchItems(array: array)
  }
  
  func searchMovies(text: String) {
    // Tell the presenter to show the loader
    self.presenter?.presentLoader()
    // Create the search api
    let searchApi = MovieSearchApi()
    searchApi.fetchMovies(searchText: text, pageNumber: 1,
                          success: { (movies, currentPage, totalPages) in
                            // Api success
                            // Tell the presenter to hide the loader
                            self.presenter?.hideLoader()
                            // Save the search text
                            self.autoSuggestionStore.saveSearch(text: text)
                            // Tell the presenter to show the movie list vc
                            self.presenter?.presentMovies(movies: movies, currentPage: currentPage, totalPages: totalPages, searchText: text)
    }) { (statusCode, error) in
      // Tell the presenter to hide the loader
      self.presenter?.hideLoader()
      // Tell the presenter to show the error
      self.presenter?.presentError(statusCode: statusCode, error: error)
    }
  }
}



