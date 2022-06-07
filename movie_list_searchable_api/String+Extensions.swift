//
//  String+Extensions.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 30/05/22.
//

import Foundation

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
