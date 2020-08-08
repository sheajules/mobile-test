//
//  ResourceListVCDataModel.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

protocol ResourceListDataModelInterface {
    func fetchDestinationsForCategory(_ categoryType: CategoryType)
    func getDestinationByIndexPath(_ indexPath: IndexPath) -> Destination?
    func getNumberOfPlacesForSection(_ section: Int) -> Int
    func sortedAlphabeticallyDestinationList(_ sort: Bool)
}

final class ResourceListVCDataModel: ResourceListDataModelInterface {

    private var api: APIServiceInterface
    private var destinations: [Destination] = []

    init(api: APIServiceInterface = ResourceAPIService()) {
        self.api = api
    }

    func fetchDestinationsForCategory(_ categoryType: CategoryType) {
        api.fetchByCategoryType(categoryType) { result in
            switch result{
                case .success(let destinations):
                    self.destinations = destinations
                case .failure(let error):
                    debugPrint("Error fetching Restaurants with error: \(error)")
            }
        }
    }

    func sortedAlphabeticallyDestinationList(_ sort: Bool) {
        if sort {
            return destinations.sort { $0 > $1 }
        } else {
            return destinations.sort { $0 < $1 }
        }
    }

    func getDestinationByIndexPath(_ indexPath: IndexPath) -> Destination? {
        if destinations.indices.contains(indexPath.row) {
            return destinations[indexPath.row]
        }
        return nil
    }

    func getNumberOfPlacesForSection(_ section: Int) -> Int {
        return destinations.count
    }
}
