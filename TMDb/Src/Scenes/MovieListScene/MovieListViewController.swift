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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 130
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
    return 12
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
    cell.movieTitleLabel.text = "Title \(indexPath.row)"
    cell.movieReleaseDateLabel.text = "09/09/2018"
    var desc = ""
    if indexPath.row % 2 == 0 {
      desc = "The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker."
    }
    else {
      let rand = arc4random() % 20
      
      for _ in 0..<rand {
        desc += "Lorem ipsum dolor sit amet. "
      }
      
      desc += "The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker."
    }
    
    if indexPath.row == 6 {
      desc = "One liner text"
    }
    cell.movieDescLabel.text = desc
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  
}
