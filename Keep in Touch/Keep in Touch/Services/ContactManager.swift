//
//  ContactManager.swift
//  Keep in Touch
//
//  Created by Pavan Baloo on 8/26/24.
//

import Foundation
import Contacts
enum ContactError: Error{
    case permissionDenied
    case fetchFailed
    case noContacts
    case unknown(Error)

}


final class ContactManager{
    // defines ContactManager object called "shared"
    static let shared = ContactManager()                    // lazy init
    private init(){}                                        // is a singleton b/c of private
    // list of keys we want to request for each contact
    private let contactKeys =  [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
    
    
    // function to fetch contacts. runs asynchronously
    func fetchContacts() async throws -> [Contact]{
        let contactStore = CNContactStore();                // initialize a contact store to access contacts on device
        var contacts : [Contact] = []                       // initialize an array to store contacts for the app


        
        do{
            // request access for contacts
            let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            
            switch authorizationStatus {
            case .notDetermined:
                let authorized = try await contactStore.requestAccess(for: .contacts)
                if !authorized {
                    throw ContactError.permissionDenied
                }
            case .restricted, .denied:
                throw ContactError.permissionDenied
            case .authorized:
                break
            @unknown default:
                throw ContactError.unknown(NSError(domain: "ContactError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"]))
            }

            // request to fetch info specified in contactKeys
            let request =  CNContactFetchRequest(keysToFetch : contactKeys as [CNKeyDescriptor])
            try contactStore.enumerateContacts(with: request) { (cnContact, _) in
                // only add a contact if there is a phone number
                if let phoneNumber = cnContact.phoneNumbers.first?.value {
                    let name = "\(cnContact.givenName) \(cnContact.familyName)".trimmingCharacters(in: .whitespaces)
                    // add contact
                    contacts.append(Contact(
                                        id: UUID().uuidString,
                                        name: name,
                                        phoneNumber: phoneNumber,
                                        bucket: ContactBucket.regularReminders
                                    ))
                }
            }
            // if no contacts
            if contacts.isEmpty {
                throw ContactError.noContacts
            }
        } catch let error as CNError {
            print("CNError: \(error.localizedDescription)")
            throw ContactError.unknown(error)
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw ContactError.unknown(error)
        }

        return contacts
    }
}
