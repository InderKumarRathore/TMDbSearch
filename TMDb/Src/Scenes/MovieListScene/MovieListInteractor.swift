//
//  MovieListInteractor.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 08/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//


protocol MovieListViewBusinessLogic {
  /// Fetches the page from the imdb server
  ///
  /// - Parameters:
  ///   - isNewSearch: whether the search request is new or not
  ///   - text: search text
  func fetchPage(isNewSearch: Bool, text: String?)
}

class MovieListInteractor {
  // Presenter
  var presenter: MovieListPresentationLogic?
  /// Current page number for the flicker api, default = 1
  private var currentPage = 1
  
  /// Current search text
  private var searchText = ""
}
