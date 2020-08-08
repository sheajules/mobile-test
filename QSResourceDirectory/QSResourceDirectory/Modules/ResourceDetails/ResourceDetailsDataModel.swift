//
//  ResourceDetailsDataModel.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit
import WebKit

protocol ResourceDetailsDataModelInterface {
    var destination: Destination { get }
    func getSectionTitleForSection(_ section: Int) -> String?
    func getNumberOfSection() -> Int
    func getItemByIndexPath(_ indexPath: IndexPath) -> DetailComponent?
    func getNumberOfItemsForSection(_ section: Int) -> Int
}

final class ResourceDetailsDataModel: ResourceDetailsDataModelInterface {

    private var componentParser = ComponentsParsingService()
    var destination: Destination
    private var components: [ComponentSection] = []

    init(destination: Destination) {
        self.destination = destination
        let comps = componentParser.parseDestinationDetails(destination)
        components = comps
    }

    func getSectionTitleForSection(_ section: Int) -> String? {
        guard components.indices.contains(section) else {
            return nil
        }
        let section: ComponentSection = components[section]
        return section.type.rawValue
    }

    func getNumberOfSection() -> Int {
        return components.count
    }

    func getItemByIndexPath(_ indexPath: IndexPath) -> DetailComponent? {
        guard components.indices.contains(indexPath.section) else {
            return nil
        }
        let section: ComponentSection = components[indexPath.section]
        guard section.components.indices.contains(indexPath.row) else {
            return nil
        }
        return section.components[indexPath.row]
    }

    func getNumberOfItemsForSection(_ section: Int) -> Int {
        if components.indices.contains(section) {
            let section: ComponentSection = components[section]
            return section.components.count
        }
        return 0
    }
}
