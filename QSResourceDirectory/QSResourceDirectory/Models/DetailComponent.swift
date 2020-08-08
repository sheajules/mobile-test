//
//  DetailComponent.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import Foundation

struct DetailComponent {
    
    let title: String
    let text: String
    let iconTypes: [SocialIconType]?
    let actionable: ActionableType

    init(
        title: String = "",
        text: String = "",
        iconTypes: [SocialIconType]? = nil,
        actionable: ActionableType = .none
    ) {
        self.title = title
        self.text = text
        self.iconTypes = iconTypes
        self.actionable = actionable
    }
}

enum ActionableType {
    case phone(String)
    case email(String)
    case website(String)
    case map(MapCoordinate, String)
    case none
}

enum SocialIconType {
    case facebook(String)
    case twitter(String)
    case youtube(String)
}
