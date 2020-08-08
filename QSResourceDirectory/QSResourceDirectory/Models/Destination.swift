//
//  Destination.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import Foundation

struct Destination: Codable {
    let id: String
    let slug: String
    let eid: String
    let title: String
    let v: Int
    let photo: String
    let description: String
    let bizHours: [String: BusinessHours]?
    let category_eid: String
    let isActive: Bool
    let socialMedia: SocialMediaLinks?
    let updatedAt: String
    let createAt: String
    let addresses: [Address]?
    let contactInfo: ContactInfo

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case isActive = "_active"
        case updatedAt = "updated_at"
        case createAt = "created_at"
        case slug
        case eid
        case title
        case photo
        case category_eid
        case description
        case bizHours
        case addresses
        case socialMedia
        case contactInfo
    }
}

extension Destination: Comparable {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.title == rhs.title
    }

    static func < (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.title < rhs.title
    }
}

//TODO: Seperate into their own files

struct ContactInfo: Codable {
    let website: [String]?
    let email: [String]?
    let phoneNumber: [String]?
    let faxNumber: [String]?
    let tollFree: [String]?
}

struct SocialMediaLinks: Codable {
    let youtubeChannel: [String]?
    let twitter: [String]?
    let facebook: [String]?
}

struct Address: Codable {
    let address: String?
    let label: String?
    let zipCode: String?
    let city: String?
    let state: String?
    let country: String?
    let coordinates: MapCoordinate?

    private enum CodingKeys: String, CodingKey {
        case address = "address1"
        case label
        case zipCode
        case city
        case state
        case country
        case coordinates = "gps"
    }
}

struct BusinessHours: Codable {
    let from: String
    let to: String

    func getHourFormat() -> String {
        return "\(from) - \(to)"
    }
}

struct MapCoordinate: Codable {
    let latitude: String
    let longitude: String
}
