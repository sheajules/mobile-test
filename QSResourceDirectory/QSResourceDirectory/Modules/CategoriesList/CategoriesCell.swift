//
//  CategoriesCell.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

final class CategoryTVCell: UITableViewCell {
    static let cellID = "CategoryTVCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: CategoryTVCell.cellID)
        accessoryType = .disclosureIndicator
        backgroundColor = .white

        let backgroundView = UIView()
        backgroundView.backgroundColor = .tertiaryRed
        selectedBackgroundView = backgroundView
        textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textLabel?.textColor = .primaryRed
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    func setModel(_ category: Category) {
        textLabel?.text = category.title.uppercased()
        detailTextLabel?.text = category.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

