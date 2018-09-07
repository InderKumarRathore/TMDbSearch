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
        
//        // If active text field is hidden by keyboard, scroll it so it's visible
//        // Your app might not need or want this behavior.
//        CGRect aRect = self.view.frame
//        aRect.size.height -= kbSize.height
//        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//          [self.scrollView scrollRectToVisible:activeField.frame animated:YES]
//        }
      }
    }}
  
  // Called when the UIKeyboardWillHideNotification is sent
  @objc func keyboardWillBeHidden(notification: Notification) {
    let contentInsets = UIEdgeInsets.zero
    self.tableView.contentInset = contentInsets
    self.tableView.scrollIndicatorInsets = contentInsets
  }
}


