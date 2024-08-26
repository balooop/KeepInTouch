//
//  ContactTests.swift
//  Keep in TouchTests
//
//  Created by Pavan Baloo on 8/25/24.
//

import XCTest
@testable import Keep_in_Touch

class ContactTests: XCTestCase {
    func testContactInitialization(){
        let contact = Contact(
            id: "1",
            name: "John Doe",
            phoneNumber: "1234567890",
            bucket: .regularReminders
        )
        XCTAssertEqual(contact.id, "1")
        XCTAssertEqual(contact.name, "John Doe")
        XCTAssertEqual(contact.phoneNumber, "1234567890")
        XCTAssertEqual(contact.bucket, ContactBucket.regularReminders)
        XCTAssertNil(contact.lastContactedDate)
    }
    func testContactBucketRawValues() {
        XCTAssertEqual(ContactBucket.noReminders.rawValue, "No Reminders")
        XCTAssertEqual(ContactBucket.regularReminders.rawValue, "Regular Reminders")
        XCTAssertEqual(ContactBucket.sporadicReminders.rawValue, "Sporadic Reminders")
    }

}
