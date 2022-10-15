//
//  ContactQueriesItemCell.swift
//  ColleaguesContact
//
//  Created by Willy on 13/10/2022.
//

import UIKit

final class ContactQueriesItemCell: UITableViewCell {
    static let height = CGFloat(50)
    static let reuseIdentifier = String(describing: ContactQueriesItemCell.self)

    @IBOutlet private var titleLabel: UILabel!
    
    func fill(with suggestion: ContactQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }
}

