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
  let posterLastPathComponent: String
  
  init(title: String, overview: String, releaseDate: String, posterPath: String) {
    self.title = title
    self.overview = overview
    self.releaseDate = releaseDate
    self.posterLastPathComponent = posterPath
  }

  
  /// Gets the url for the poster image
  ///
  /// - Parameter width: width for the image
  /// - Returns: URL for the poster
  func getPosterUrl(width: CGFloat) -> URL? {
    let size = getPosterSize(width: width)
    let urlStr = "http://image.tmdb.org/t/p/\(size)\(posterLastPathComponent)"
    return URL(string: urlStr)
  }
  
  
  ///
  ///
  /// - Parameter width:
  /// - Returns: disk url
  
  /// Gets the disk url based on the image width
  ///
  /// - Parameters:
  ///   - width: image width
  ///   - dirPath: directory path where the file needs to be saved or picked
  /// - Returns: disk url for the image
  func getDiskUrl(width: CGFloat, dirPath: String) -> URL? {
    let size = getPosterSize(width: width)
    let tmdbDir = "TMDB"
    let fullDirPath = "\(dirPath)\(tmdbDir)/\(size)"
    try? FileManager.default.createDirectory(atPath: fullDirPath, withIntermediateDirectories: true, attributes: nil)
    return URL(fileURLWithPath: "\(fullDirPath)\(self.posterLastPathComponent)")
  }
  
  
  /// Get the appropriate size for the image based on the the width
  ///
  /// - Parameter width: width required for the image
  /// - Returns: size
  private func getPosterSize(width: CGFloat) -> String {
    if width <= 92.0 {
      return "w92"
    }
    
    if width <= 185.0 {
      return "w185"
    }
    
    if width <= 500.0 {
      return "w500"
    }
    
    // Return high res image
    return "w780"
  }
}

struct MovieResult {
  let movies: [MovieViewModel]
  let currentPage: Int
  let totalPages: Int
}


