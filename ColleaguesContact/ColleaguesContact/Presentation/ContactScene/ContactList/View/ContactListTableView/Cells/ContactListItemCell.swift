//
//  ContactListItemCell.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import UIKit

final class ContactListItemCell: UITableViewCell {

    static let reuseIdentifier = String(describing: ContactListItemCell.self)
    static let height = CGFloat(130)

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var favouriteColorLabel: UILabel!
    @IBOutlet private var jobtitleLabel: UILabel!
    @IBOutlet private var posterImageView: UIImageView!

    private var viewModel: ContactListItemViewModel!

    func fill(with viewModel: ContactListItemViewModel) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
        favouriteColorLabel.text = "Favourite Color : \(viewModel.favouriteColor)"
        jobtitleLabel.text = viewModel.jobtitle
        updatePosterImage(posterImagePath: viewModel.posterImagePath ?? "")
    }

    private func updatePosterImage(posterImagePath: String) {
        posterImageView.image = nil
        posterImageView.image = UIImage(url: URL(string: posterImagePath))
        posterImageView.layer.masksToBounds = false
        posterImageView.layer.cornerRadius = posterImageView.frame.height/2
        posterImageView.clipsToBounds = true
    }
    
    
}

