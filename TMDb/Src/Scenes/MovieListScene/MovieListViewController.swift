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
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
