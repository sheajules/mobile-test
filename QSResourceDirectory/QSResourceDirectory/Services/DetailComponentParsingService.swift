//
//  DetailComponentParsingService.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import Foundation

enum DetailSection: String {
    case contactInfo = "CONTACT INFORMATION"
    case address = "ADDRESS"
    case mediaLinks = "SOCIAL MEDIA"
    case businessHours = "BUSINESS HOURS"
}

struct ContactInfoHeaders {
    static let phone = "PHONE NUMBER"
    static let tollFree = "TOLL-FREE NUMBER"
    static let faxNumber = "FAX NUMBER"
    static let email = "EMAIL ADDRESS"
    static let website = "WEBSITE"
}

struct ComponentSection {
    let type: DetailSection
    let components: [DetailComponent]
}

struct ComponentsParsingService {

    private var components: [DetailComponent] = []

    func parseDestinationDetails(_ Destination: Destination) -> [ComponentSection] {
        var sections: [ComponentSection] = []
        if let contacts = createSectionForContactInfo(Destination.contactInfo) {
            sections.append(contacts)
        }
        if let addresses = Destination.addresses, let section = createSectionForAddress(addresses) {
            sections.append(section)
        }
        if let mediaLinks = Destination.socialMedia, let links = createSectionForMediaLinks(mediaLinks) {
            sections.append(links)
        }
        if let info = Destination.bizHours, let hours = createSectionForBusinessHours(info) {
            sections.append(hours)
        }
        return sections
    }

    func createSectionForContactInfo(_ info: ContactInfo) -> ComponentSection? {
        var contacts: [DetailComponent] = []
        info.phoneNumber?.forEach({ v in
            if !v.isEmpty {
                contacts.append(DetailComponent(
                    title: ContactInfoHeaders.phone,
                    text: v,
                    actionable: .phone(v)
                ))
            }
        })
        info.tollFree?.forEach({ v in
            if !v.isEmpty {
                contacts.append(DetailComponent(title: ContactInfoHeaders.tollFree, text: v, actionable: .phone(v)))
            }
        })
        info.faxNumber?.forEach({ v in
            if !v.isEmpty {
                contacts.append(DetailComponent(title: ContactInfoHeaders.faxNumber, text: v, actionable: .phone(v)))
            }
        })
        info.email?.forEach({ v in
            if !v.isEmpty {
                contacts.append(DetailComponent(title: ContactInfoHeaders.email, text: v, actionable: .email(v)))
            }
        })
        info.website?.forEach({ v in
            if !v.isEmpty {
                contacts.append(DetailComponent(title: ContactInfoHeaders.website, text: v, actionable: .website(v)))
            }
        })
        if contacts.isEmpty {
            return nil
        }
        return ComponentSection(type: .contactInfo, components: contacts)
    }

    func createSectionForAddress(_ info: [Address]) -> ComponentSection? {
        var addresses: [DetailComponent] = []

        info.forEach { addy in
            if
                let label = addy.label,
                let address = addy.address,
                let city = addy.city,
                let state = addy.state,
                let zipCode = addy.zipCode,
                let country = addy.country,
                let coordinate = addy.coordinates
            {
                addresses.append(DetailComponent(
                    title: label,
                    text:
                        "\(address) \n" +
                        "\(city), \(zipCode)" +
                        "\(state), \(country) \n",
                    actionable: .map(coordinate, label)
                ))
            }
        }
        if addresses.isEmpty {
            return nil
        }
        return ComponentSection(type: .address, components: addresses)
    }

    func createSectionForMediaLinks(_ info: SocialMediaLinks) -> ComponentSection? {
        var links: [DetailComponent] = []
        var socialLinks: [SocialIconType] = []
        var link = ""
        info.facebook?.forEach({ v in
            socialLinks.append(.facebook(v))
            link = v
        })
        info.twitter?.forEach({ v in
            socialLinks.append(.twitter(v))
            link = v
        })
        info.youtubeChannel?.forEach({ v in
            socialLinks.append(.youtube(v))
            link = v
        })
        if !link.isEmpty {
            links.append(DetailComponent(iconTypes: socialLinks))
        }

        if links.isEmpty {
            return nil
        }
        return ComponentSection(type: .mediaLinks, components: links)
    }

    func createSectionForBusinessHours(_ info: [String: BusinessHours]) -> ComponentSection? {
        var hours: [DetailComponent] = []
        info.keys.forEach { name in
            if let bizHours = info[name] {
                hours.append(DetailComponent(title: name, text: bizHours.getHourFormat()))
            }
        }
        if hours.isEmpty {
            return nil
        }
        return ComponentSection(type: .businessHours, components: hours)
    }
}
