//
//  UIView+Ext.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

extension UIView {
    func fullConstraint() {
        guard let parent = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}

