//
//  Category.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import Foundation

enum CategoryType: String {
    case restaurants = "restaurants"
    case vacationSpots = "vacation-spots"
    case unknown
}

struct Category: Codable, Hashable {
    let id: String
    let title: String
    let description: String?
    let slug: String
    let isActive: Bool

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case slug
        case isActive = "_active"
    }

    func getCategoryType() -> CategoryType {
        guard let cat = CategoryType(rawValue: slug) else {
            return .unknown
        }
        return cat
    }
}
