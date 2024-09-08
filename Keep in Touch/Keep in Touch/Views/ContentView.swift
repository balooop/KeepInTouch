//
//  ContentView.swift
//  Keep in Touch
//
//  Created by Pavan Baloo on 8/25/24.
//

import SwiftUI

struct ContentView: View {
    // state properties of the view
    @State private var contacts: [Contact] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // creates vody
    var body: some View {
        // vertical stack with a "fetch contacts" button that calls the function
        VStack {
            Button("Fetch Contacts") {
                fetchContacts()
            }
            
            // defines behavior when when button is pressed
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                List(contacts) { contact in
                    Text(contact.name)
                }
            }
        }
    }
    
    // called when fetchContacts is pressed
    private func fetchContacts() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                contacts = try await ContactManager.shared.fetchContacts()
                isLoading = false
            } catch ContactError.permissionDenied {
                errorMessage = "Permission to access contacts was denied. Please go to Settings > Privacy > Contacts and enable access for this app."
            } catch ContactError.noContacts {
                errorMessage = "No contacts found on the device."
            } catch ContactError.unknown(let error) {
                errorMessage = "Error fetching contacts: \(error.localizedDescription)"
            } catch {
                errorMessage = "Unexpected error: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
#Preview {
    ContentView()
}
