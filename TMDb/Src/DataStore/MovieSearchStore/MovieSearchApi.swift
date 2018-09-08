//
//  MovieSearchApi.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 08/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import Foundation

class MovieSearchApi {
  typealias SuccessClosure = ([MovieServiceObject], _ currentPage:Int, _ totalPages: Int) -> Void
  typealias FailureClosure = (_ statusCode: Int, _ error: Error?) -> Void
  
  /// Fetches the data from the tmdb API.
  /// Fixme: Hardcoing the key here.
  /// We can put the key at some other places, but lets finish the taks first
  ///
  /// - Parameters:
  ///   - pageNumber: page number starts from 1
  ///   - searchText: text that has been queried for
  ///   - success: success call  back
  ///   - failed: failiure call back
  func fetchMovies(searchText: String, pageNumber: Int,
                      success:@escaping SuccessClosure,
                      failed:@escaping FailureClosure) {
    // Encode the search text parameter
    if let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      // Create the url string
      let urlStr = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(encodedText)&page=\(pageNumber)"
      // Create the url object
      if let url = URL(string: urlStr) {
        // Create session
        let session = URLSession(configuration: .default)
        // Create data task
        let dataTask = session.dataTask(with: url) { (data, response, error) in
          if let res = response as? HTTPURLResponse {
            if error == nil && res.statusCode == 200 {
              // Success, convert the data into Array of objects
              if let data = data {
                if let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: AnyObject] {
                  // Parse the json object
                  if let movies = jsonObject["results"] as? [[String : AnyObject]],
                    let currentPage = jsonObject["page"] as? Int,
                    let totalPages = jsonObject["total_pages"] as? Int {
                    // Array to hold the movie objects
                    var movieArray = [MovieServiceObject]()
                    
                    for movie in movies {
                      if let title = movie["title"] as? String,
                        let posterPath = movie["poster_path"] as? String,
                        let overview = movie["overview"] as? String,
                        let releaseDate = movie["release_date"] as? String {
                        let movieModel = MovieServiceObject(title: title, posterPath: posterPath, overview: overview, releaseDate: releaseDate)
                        movieArray.append(movieModel)
                      }
                    }
                    
                    //Call the success handler
                    success(movieArray, currentPage, totalPages)
                  }
                  else {
                    failed(10013, nil) // Couln't parse movies object
                  }
                }
                else {
                  failed(10013, nil) //Json not valid
                }
              }
              else {
                failed(10012, nil) // Couln't get the response data
              }
            }
            else {
              failed(res.statusCode, error)
            }
          }
          else {
            failed(10011, error) // Couln't get the response
          }
        }
        // Start the task
        dataTask.resume()
      }
      else {
        failed(10009, nil) // Couldn't form url
      }
    }
    else {
      failed(10010, nil) // Couldn't encode search text
    }
  }
}

