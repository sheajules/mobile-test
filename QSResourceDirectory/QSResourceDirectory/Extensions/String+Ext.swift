//
//  String+Ext.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import Foundation

extension String {
    func withoutHtmlTags() -> String {
        let str = self.replacingOccurrences(of: "<style>[^>]+</style>", with: "", options: .regularExpression, range: nil)
        return str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
