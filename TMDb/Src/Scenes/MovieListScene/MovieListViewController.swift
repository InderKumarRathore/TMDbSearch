//
//  MovieListViewController.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 07/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  // Movie List
  var movieArray = [MovieViewModel]()
  
  // Current page, default is 1
  var currentPage = 1
  
  // Total pages, default is max
  var totalPages = Int.max

  /// Image fetcher to fetch the images asyncronously
  let imageFetcher = ImageFetcher(concurrentOperations: 3, cacheImageCount: 50)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK:- UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
  
}


// MARK:- UITableView
extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
    // Get the movie object
    let movie = self.movieArray[indexPath.row]
    cell.movieTitleLabel.text = movie.title
    cell.movieReleaseDateLabel.text = movie.releaseDate
    cell.movieOverviewLabel.text = movie.overview
    
    /* Get the poster image for this movie */
    // Set the tag to compare in the completion handler
    cell.tag = indexPath.row
    // Get the width
    let width = cell.moviePosterImageView.frame.size.width * UIScreen.main.scale
    // Get the directory where images need to be saved/searched
    let dirPath = NSTemporaryDirectory()
    if let serverUrl = movie.getPosterUrl(width: width), let diskUrl = movie.getDiskUrl(width: width, dirPath: dirPath) {
      // Create the image info
      let imageInfo = ImageInfo(id: movie.posterLastPathComponent, serverUrl: serverUrl, diskUrl: diskUrl)
      self.imageFetcher.getImageFor(imageInfo: imageInfo, width: width, priority: .high, index: indexPath.row) { (image) in
        DispatchQueue.main.async {
          //Check if the cell is the same cell that requested this image
          if cell.tag == indexPath.row {
            cell.moviePosterImageView.image = image
          }
        }
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
