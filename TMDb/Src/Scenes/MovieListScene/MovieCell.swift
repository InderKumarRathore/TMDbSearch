//
//  MovieCell.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 07/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  @IBOutlet weak var moviePosterImageView: UIImageView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var movieReleaseDateLabel: UILabel!
  @IBOutlet weak var movieOverviewLabel: UILabel!
  
  override func prepareForReuse() {
    self.moviePosterImageView.image = #imageLiteral(resourceName: "placeholder-image")
  }
}
