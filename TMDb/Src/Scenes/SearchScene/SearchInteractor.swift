//
//  SearchInteractor.swift
//  TMDb
//
//  Created by Inder Kumar Rathore on 06/09/18.
//  Copyright © 2018 Inder Kumar Rathore. All rights reserved.
//

import Foundation


protocol SearchBusinessLogic {
}


class SearchInteractor {
  var presenter: SearchPresentationLogic?
}

// MARK:- SearchBusinessLogic
extension SearchInteractor: SearchBusinessLogic {
}



