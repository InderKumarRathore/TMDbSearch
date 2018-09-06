//
//  SearchViewController.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 06/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import UIKit


// Class only protocol, b'coz SearchVC needs to be weak in presenter
protocol SearchDisplayLogic: class {
}

class SearchViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  // Clean Architecture references
  var interactor: SearchBusinessLogic!
  
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
    let interactor = SearchInteractor()
    let presenter = SearchPresenter()
    viewController.interactor = interactor // strong reference
    interactor.presenter = presenter // strong reference
    presenter.viewController = viewController // weak reference
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK:- SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {
}


// MARK:- UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  // Search tapped on keyboard
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  // Cancel tapped
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}


// MARK:-
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 15
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
    searchCell.titleLabel.text = "sea \(indexPath.row)"
    return searchCell
  }
}




