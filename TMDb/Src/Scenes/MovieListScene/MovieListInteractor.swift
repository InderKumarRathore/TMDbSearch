//
//  MovieListInteractor.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 08/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//


protocol MovieListBusinessLogic {
  /// Fetches the page from the imdb server
  func fetchNextPage()
  
  var currentPage: Int { get set }
  
  var searchText: String { get set }
}

class MovieListInteractor {
  // Presenter
  var presenter: MovieListPresentationLogic?
  /// Current page number for the tmdb api, default = 1
  var currentPage = 1
  
  /// Current search text
  var searchText = ""
}

// MARK:- MovieListBusinessLogic
extension MovieListInteractor: MovieListBusinessLogic {
  func fetchNextPage() {
    let searchApi = MovieSearchApi()
    // View wants to load new page
    self.currentPage += 1
    searchApi.fetchMovies(searchText: searchText, pageNumber: self.currentPage, success: { [weak self] (movieArray, currentPage, totalPages) in
      self?.currentPage = currentPage
      let canLoadNewPages = currentPage < totalPages
      
      // Tell the present to show new data
      self?.presenter?.presentFetchedObjects(movies: movieArray, canLoadNewPages: canLoadNewPages)
      
    }) {[weak self] (statusCode, error) in
      // Tell the persenter to show error
      self?.presenter?.showError(statusCode: statusCode, error: error)
    }
  }
}
