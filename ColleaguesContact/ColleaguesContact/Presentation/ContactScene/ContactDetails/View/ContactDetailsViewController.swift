

import UIKit

final class ContactDetailsViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var overviewTextView: UITextView!

    // MARK: - Lifecycle

    private var viewModel: ContactDetailsViewModel!
    
    static func create(with viewModel: ContactDetailsViewModel) -> ContactDetailsViewController {
        let view = ContactDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    private func bind(to viewModel: ContactDetailsViewModel) {
        
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.title
        overviewTextView.text = viewModel.overview
        posterImageView.image = UIImage(url: URL(string: viewModel.posterImagePath))
        view.accessibilityIdentifier = AccessibilityIdentifier.contactDetailsView
    }
}
