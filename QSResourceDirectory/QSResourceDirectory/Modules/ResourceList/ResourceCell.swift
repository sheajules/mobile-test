//
//  ResourceCell.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

final class ResourceCell: UITableViewCell {
    static let cellID = "ResourceCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: ResourceCell.cellID)
        accessoryType = .disclosureIndicator
        backgroundColor = .white
        detailTextLabel?.numberOfLines = 0

        let backgroundView = UIView()
        backgroundView.backgroundColor = .tertiaryRed
        selectedBackgroundView = backgroundView
        textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textLabel?.textColor = .primaryRed
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    func setModel(_ destination: Destination) {
        textLabel?.text = destination.title.uppercased()
        detailTextLabel?.text = destination.description.withoutHtmlTags()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

