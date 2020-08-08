//
//  CategoriesListDataModel.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

protocol CategoriesListDataModelInterface {
    func fetchCategories()
    func getNumberOfCategoriesForSection(_ section: Int) -> Int
    func getCategoryByIndexPath(_ indexPath: IndexPath) -> Category?
}

final class CategoriesListDataModel: CategoriesListDataModelInterface {

    private var api: APIServiceInterface
    private var categories: [Category] = []

    init(api: APIServiceInterface = ResourceAPIService()) {
        self.api = api
    }

    func fetchCategories() {
        api.fetchCategories { [weak self] result in
            guard let self = self else { return }
            switch result{
                case .success(let categories):
                    self.categories = categories
                case .failure(let error):
                    debugPrint("Error fetching Restaurants with error: \(error)")
            }
        }
    }

    func getNumberOfCategoriesForSection(_ section: Int) -> Int {
        return categories.count
    }

    func getCategoryByIndexPath(_ indexPath: IndexPath) -> Category? {
        if categories.indices.contains(indexPath.row) {
            return categories[indexPath.row]
        }
        return nil
    }
}

