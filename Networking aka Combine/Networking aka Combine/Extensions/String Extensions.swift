//
//  String Extensions.swift
//  Networking aka Combine
//
//  Created by Hamza Azhar on 2024-03-28.
//

import Foundation

extension String {
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
