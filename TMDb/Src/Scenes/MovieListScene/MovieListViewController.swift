//
//  MovieListViewController.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 07/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import UIKit

// Class only protocol, b'coz MovieListVC needs to be weak in presenter
protocol MovieListDisplayLogic: class {
  /// Shows the list of movies
  /// - Parameters:
  ///   - movies: movies array
  ///   - canLoadMore: tell whether to load more or not
  func showMovieList(movies: [MovieViewModel], canLoadMore: Bool)
  
  /// Show the error msg
  ///
  /// - Parameter msg: message string
  func showError(msg: String)
}

class MovieListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  // Movie result, assing it while showing this vc
  var movieResult: MovieResult?
  
  // Movie List
  private var movieArray = [MovieViewModel]()

  /// Image fetcher to fetch the images asyncronously
  let imageFetcher = ImageFetcher(concurrentOperations: 3, cacheImageCount: 50)
  
  /// Indicates that more data can be loaded
  private var canLoadMore = false
  
  /// Interactor
  var interactor: MovieListBusinessLogic!
  
  // MARK: Object lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setUpCleanArchitecture()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpCleanArchitecture()
  }
  
  /// Set ups the clean architecture
  /// You can read more about it at the below link
  /// https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf
  private func setUpCleanArchitecture() {
    let viewController = self
    let interactor = MovieListInteractor()
    let presenter = MovieListPresenter()
    viewController.interactor = interactor // strong reference
    interactor.presenter = presenter // strong reference
    presenter.viewController = viewController // weak reference
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    self.tableView.rowHeight = UITableViewAutomaticDimension
//    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    
    // Set the load more boolean
    if let result = self.movieResult {
      self.canLoadMore = result.currentPage < result.totalPages
      self.movieArray = result.movies
      self.interactor.searchText = result.searchText
      self.interactor.currentPage = result.currentPage
      
      // set the title of the view controller
      self.title = result.searchText
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    imageFetcher.clearCache()
  }
  
  private func loadMoreMovies() {
    // Tell the interactor to load more movies
    self.interactor.fetchNextPage()
  }
}

// MARK:- MovieListDisplayLogic
extension MovieListViewController: MovieListDisplayLogic {
  func showMovieList(movies: [MovieViewModel], canLoadMore: Bool) {
    // Set the load more
    self.canLoadMore = canLoadMore
    // Append the new result
    var indexPaths = [IndexPath]()
    let count = self.movieArray.count
    for i in 0..<movies.count {
      let indexPath = IndexPath(row: count + i, section: 0)
      indexPaths.append(indexPath)
    }
    if self.canLoadMore {
      let indexPath = IndexPath(row: count + movies.count, section: 0)
      indexPaths.append(indexPath)
    }
    self.movieArray.append(contentsOf: movies)
    self.tableView.beginUpdates()
    self.tableView.deleteRows(at: [IndexPath(row: count, section: 0)], with: .none)
    self.tableView.insertRows(at: indexPaths, with: .automatic)
    self.tableView.endUpdates()
//    self.tableView.reloadData()
  }
  
  func showError(msg: String) {
    // Show the alert
    let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK:- UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
  
}


// MARK:- UITableView
extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.canLoadMore {
      // Show load more cell
      return self.movieArray.count + 1
    }
    else {
      return self.movieArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row < self.movieArray.count { // This is normal cell
      let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
      // Get the movie object
      let movie = self.movieArray[indexPath.row]
      cell.movieTitleLabel.text = movie.title
      cell.movieReleaseDateLabel.text = movie.releaseDate
      cell.movieOverviewLabel.text = movie.overview
      
      /* Get the poster image for this movie */
      // Set the tag to compare in the completion handler
      cell.tag = indexPath.row
      if let posterPathComponent = movie.posterLastPathComponent {
        // Get the width
        let width = cell.moviePosterImageView.frame.size.width * UIScreen.main.scale
        // Get the directory where images need to be saved/searched
        let dirPath = NSTemporaryDirectory()
        if let serverUrl = movie.getPosterUrl(width: width), let diskUrl = movie.getDiskUrl(width: width, dirPath: dirPath) {
          // Create the image info
          let imageInfo = ImageInfo(id: posterPathComponent, serverUrl: serverUrl, diskUrl: diskUrl)
          self.imageFetcher.getImageFor(imageInfo: imageInfo, width: width, priority: .high, index: indexPath.row) { (image) in
            DispatchQueue.main.async {
              //Check if the cell is the same cell that requested this image
              if cell.tag == indexPath.row {
                cell.moviePosterImageView.image = image
              }
            }
          }
        }
      }
      return cell
    }
    else {
      // This is load more cell
      // Return load more cell
      let loadMoreCell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
      return loadMoreCell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == self.movieArray.count {
      print("Will display row:\(indexPath.row) X X X X X X X X X X X X X X X X X X")
      // This is load more cell thus load more movies
      loadMoreMovies()
    }
    else {
      print("Will display row:\(indexPath.row)")
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // Cell is removed from the table view, cancel in progress requests for data for the specified index paths
    print("did end cell: \(indexPath.row)")
    // This method gets called when we reload data, check for the array bounds
    // Also check if this had path components for nil components we didn't initialted the
    // Operation
    if self.movieArray.count > indexPath.row, let posterPath = self.movieArray[indexPath.row].posterLastPathComponent {
      self.imageFetcher.cancelImageLoadingFor(imageId: posterPath)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == self.movieArray.count {
      // This is load more cell
      return 44.0
    }
    else {
      return UITableViewAutomaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == self.movieArray.count {
      // This is load more cell
      return 44.0
    }
    else {
      return 130.0
    }
  }
  
}
