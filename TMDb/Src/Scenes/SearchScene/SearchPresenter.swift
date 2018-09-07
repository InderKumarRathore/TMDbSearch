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
}
