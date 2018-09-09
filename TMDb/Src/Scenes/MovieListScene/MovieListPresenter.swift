//
//  MovieListPresenter.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 08/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import Foundation

protocol MovieListPresentationLogic {
  
  /// Presents the list of movies
  ///
  /// - Parameters:
  ///   - movies: lsit of movies
  ///   - canLoadNewPages: tells whether there are more movies that can be loaded
  func presentFetchedObjects(movies: [MovieServiceObject], canLoadNewPages: Bool)
  
  /// Presents the error to the UI
  ///
  /// - Parameters:
  ///   - statusCode: status code
  ///   - error: error
  func showError(statusCode: Int, error: Error?)
}


class MovieListPresenter {
  weak var viewController: MovieListDisplayLogic?
}

// MARK:- MovieListPresentationLogic
extension MovieListPresenter: MovieListPresentationLogic {
  func presentFetchedObjects(movies: [MovieServiceObject], canLoadNewPages: Bool) {
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
    DispatchQueue.main.async {
      self.viewController?.showMovieList(movies: movieArray, canLoadMore: canLoadNewPages)
    }
  }
  
  func showError(statusCode: Int, error: Error?) {
    DispatchQueue.main.async {
      print("Error occurs:\(statusCode)|\(String(describing: error))")
      // The message string can be customized based on status code
      self.viewController?.showError(msg: "Something went wrong please try again. This msg can be customized based on status code:\(statusCode)")
    }
  }
}
