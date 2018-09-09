//
//  SearchPresenter.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 06/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import Foundation
import UIKit

protocol SearchPresentationLogic {
  
  /// Presents the search items to the view
  ///
  /// - Parameter array: array list of search items
  func presentFetchedSearchItems(array: [String])
  
  
  /// Presents the fetched movies
  ///
  /// - Parameters:
  ///   - movies: list of movies
  ///   - currentPage: current page
  ///   - totalPages: total pages
  ///   - searchText: searched text
  func presentMovies(movies: [MovieServiceObject], currentPage: Int, totalPages: Int, searchText: String)
  
  /// Shows the error
  ///
  /// - Parameters:
  ///   - statusCode: status code for the error
  ///   - error: error object
  func presentError(statusCode: Int, error: Error?)
  
  /// Presents the loader
  func presentLoader()
  
  /// Hides the loader
  func hideLoader()
}

class SearchPresenter {
  weak var viewController: SearchDisplayLogic?
}

// MARK:- SearchPresentationLogic
extension SearchPresenter: SearchPresentationLogic {
  func presentFetchedSearchItems(array: [String]) {
    // Comvert the list into view models, since no conversoin is required thus call vc's method
    // Call this on main thread
    DispatchQueue.main.async {
      self.viewController?.showSearchedItems(array: array)
    }
  }
  
  func presentMovies(movies: [MovieServiceObject], currentPage: Int, totalPages: Int, searchText: String) {
    // Convert the raw movie object into displaybale object
    var movieArray = [MovieViewModel]()
    
    // Create date formatter convert the service date into displayable date
    let fromFormatter = DateFormatter()
    fromFormatter.dateFormat = "yyyy-MM-dd"
    let toFormatter = DateFormatter()
    toFormatter.dateFormat = "MMM dd, yyyy"
    
    // Loop over the service objects
    for movieSO in movies {
      // Create the display date
      var dateStr = "NA"
      if let releaseDate = movieSO.releaseDate {
        if let date = fromFormatter.date(from: releaseDate) {
          dateStr = toFormatter.string(from: date)
        }
      }
      
      let movieViewModel = MovieViewModel(title: movieSO.title,
                                          overview: movieSO.overview ?? "",
                                          releaseDate: dateStr,
                                          posterLastPathComponent: movieSO.posterPath)
      movieArray.append(movieViewModel)
    }
    let movieResult = MovieResult(movies: movieArray, currentPage: currentPage, totalPages: totalPages, searchText: searchText)
    DispatchQueue.main.async {
      self.viewController?.showMovieList(movieResult: movieResult)
    }
  }
  
  func presentError(statusCode: Int, error: Error?) {
    DispatchQueue.main.async {
      print("Error occurs:\(statusCode)|\(String(describing: error))")
      // The message string can be customized based on status code
      self.viewController?.showError(msg: "Something went wrong please try again. This msg can be customized based on status code:\(statusCode)")
    }
  }
  
  func presentLoader() {
    DispatchQueue.main.async {
      self.viewController?.showLoader()
    }
  }
  
  func hideLoader() {
    DispatchQueue.main.async {
      self.viewController?.hideLoader()
    }
  }
}
