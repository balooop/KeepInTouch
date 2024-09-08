//
//  Contact.swift
//  Keep in Touch
//
//  Created by Pavan Baloo on 8/25/24.
//

import Foundation
import Contacts

// defines types of friends you can have
enum ContactBucket: String, CaseIterable {
    case noReminders = "No Reminders"
    case regularReminders = "Regular Reminders"
    case sporadicReminders = "Sporadic Reminders"
}

// defines a single contact
struct Contact: Identifiable {
    let id: String
    let name: String
    let phoneNumber: CNPhoneNumber
    var bucket: ContactBucket       // which type of contact this is
    var lastContactedDate: Date?
}

