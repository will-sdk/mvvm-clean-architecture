
import Foundation

protocol ContactDetailsViewModelInput {
}

protocol ContactDetailsViewModelOutput {
    var title: String { get }
    var overview: String { get }
    var posterImagePath: String { get }
}

protocol ContactDetailsViewModel: ContactDetailsViewModelInput, ContactDetailsViewModelOutput { }

final class DefaultContactDetailsViewModel: ContactDetailsViewModel {

    // MARK: - OUTPUT
    let title: String
    let overview: String
    let posterImagePath: String
    
    init(contact: Contact) {
        self.title = contact.firstName ?? ""
        self.overview = "\n Name: \(contact.firstName ?? "") \(contact.lastName  ?? "") \n Email: \(contact.email ?? "") \n Favourite Color : \(contact.favouriteColor ?? "") \n Job Title : \(contact.jobtitle ?? "")"
        self.posterImagePath = contact.avatar ?? ""
    }
}
