//
//  MovieModel.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 08/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//
import Foundation
import UIKit

struct MovieServiceObject {
  let title: String
  let posterPath: String
  let overview: String
  let releaseDate: String
}

struct MovieViewModel {
  let title: String
  let overview: String
  let releaseDate: String
  private let posterPath: String
  
  init(title: String, overview: String, releaseDate: String, posterPath: String) {
    self.title = title
    self.overview = overview
    self.releaseDate = releaseDate
    self.posterPath = posterPath
  }

  func getPosterUrl(width: CGFloat) -> URL? {
    var size = ""
    
    if width <= 92.0 {
      size = "w92"
    }
    else if width <= 185.0 {
      size = "w185"
    }
    else if width <= 500.0 {
      size = "w500"
    }
    else {
      size = "w780"
    }
    let urlStr = "http://image.tmdb.org/t/p/\(size)\(posterPath)"
    return URL(string: urlStr)
  }
}

struct MovieResult {
  let movies: [MovieViewModel]
  let currentPage: Int
  let totalPages: Int
}


