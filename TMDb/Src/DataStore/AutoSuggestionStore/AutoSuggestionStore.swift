//
//  AutoSuggestionStore.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 06/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import Foundation

protocol AutoSuggestionStoreProtocol {
  
  /// Gets the auto suggested list based on text criteria
  ///
  /// - Parameters:
  ///   - text: text to be matched, if nil then retuns the last searched items
  /// - Returns: returns the auto suggested list
  func getSearchList(text: String?) -> [String]
  
  
  /// Saves the search item
  ///
  /// - Parameter text: text to be saved
  func saveSearch(text: String)
}


// Saves and retrieves data from NSUserDefaul, can use core data as well, but not needed for this trivial data
class AutoSuggestionStore: AutoSuggestionStoreProtocol {
  private let key = "AutoSuggestionStoreKey"
  // MARK:- AutoSuggestionStoreProtocol
  func getSearchList(text: String?) -> [String] {
    if let array = UserDefaults.standard.object(forKey: key) as? [String] {
      if text != nil && !(text!.isEmpty) {
        // Filter the string having prefix as search string
        return array.filter{ $0.lowercased().hasPrefix(text!.lowercased()) }
      }
      else {
        return array
      }
    }
    else {
      return[]
    }
  }
  
  
  /// Saves the search string in user defaults
  ///
  /// - Parameter text: text to be saved
  func saveSearch(text: String) {
    if var array = UserDefaults.standard.object(forKey: key) as? [String] {
      // Check if searched item already exists in the list
      for i in 0..<array.count {
        let movieName = array[i]
        if movieName.caseInsensitiveCompare(text) == .orderedSame {
          // Remove the object at this index
          array.remove(at: i)
          break
        }
      }
      
      // Append to array and remove the first object if count >= 10
      if array.count >= 10 {
        array.remove(at: 0)
      }
      // Add the latest search
      array.append(text)
      
      // Save the search
      UserDefaults.standard.set(array, forKey: self.key)
    }
    else {
      // This is the first entry thus create array and append the search and save it
      var array = [String]()
      // Add the latest search
      array.append(text)
      // Save the search
      UserDefaults.standard.set(array, forKey: self.key)
    }
  }
}
