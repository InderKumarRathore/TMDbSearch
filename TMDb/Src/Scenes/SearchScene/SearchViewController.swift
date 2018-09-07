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
  
  /// Show the list of previously searched movies
  ///
  /// - Parameter array: Array of strings
  func showSearchedItems(array: [String])
}

class SearchViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  // List holding the previous search movies
  var previousSearchedMovies = [String]()
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Register keyboard notifications
    registerForKeyboardNotifications()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    // Register keyboard notifications
    deregisterForKeyboardNotifications()
  }
}

// MARK:- SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {
  func showSearchedItems(array: [String]) {
    self.previousSearchedMovies = array
    self.tableView.reloadData()
  }
  
}


// MARK:- UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  // Search bar has gained the focus
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    print("Editing called")
    self.interactor.fetchPreviousSearchList(text: searchBar.text)
  }
  
  // Search bar text did changed
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("Did chagne text:\(searchText)")
    self.interactor.fetchPreviousSearchList(text: searchBar.text)
  }
  
  
  // Search tapped on keyboard
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {    
    if let searchStr = searchBar.text {
      performSegue(withIdentifier: "MovieListViewControllerSegue", sender: searchStr)
    }
    
    
    
    // TODO: Saving search here
    if searchBar.text != nil && !searchBar.text!.isEmpty {
      self.interactor.saveSearch(text: searchBar.text!)
    }
    
  }
  
  // Cancel tapped
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}


// MARK:-
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.previousSearchedMovies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
    searchCell.titleLabel.text = self.previousSearchedMovies[indexPath.row]
    return searchCell
  }
}


// MARK:- KeyboardHandling
extension SearchViewController {
  /// Registers for Keyboard notifications
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: .UIKeyboardDidShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  /// De-Registers for Keyboard notifications
  private func deregisterForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }
  
  // Called when the UIKeyboardDidShowNotification is sent.
  @objc func keyboardWasShown(notification: Notification) {
    if let info = notification.userInfo as? [String: AnyObject] {
      if let kbValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
        // KeyboardSize
        let kbSize = kbValue.cgRectValue.size
        // Create the insents for scroll view
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
      }
    }}
  
  // Called when the UIKeyboardWillHideNotification is sent
  @objc func keyboardWillBeHidden(notification: Notification) {
    let contentInsets = UIEdgeInsets.zero
    self.tableView.contentInset = contentInsets
    self.tableView.scrollIndicatorInsets = contentInsets
  }
}


