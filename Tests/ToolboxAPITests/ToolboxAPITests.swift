import XCTest
@testable import ToolboxAPI

let jsonStrings = ["""
{
    "ver": 6,
    "blob": "eJyrVkpPzTc0sLBQsqpWyitWsoquVipRsjI0NbU0NjQwNzXQUcpTslLyLFEvVkhUKE5NLkotUSjJV0gtSy2qzM9LVdJRKgcq11HKBZK1sbW1AKKCF4Q="
}
"""]

final class ToolboxAPITests: XCTestCase {
    func testUsernotesData() {
        for string in jsonStrings {
            let usernotes = try! UsernotesData(parseJSON: string)! as UsernotesData
            XCTAssertNotNil(usernotes, "wat")

            let string = usernotes.asString()
            XCTAssertNotNil(string, "wat")
            XCTAssertFalse(string!.contains("\n"), "Output must be minified")

            let data = usernotes.asData()
            XCTAssertNotNil(data, "wat")

            let otherUsernotes = try! UsernotesData(data: data!)
            // TODO: test data equality between usernotes and otherUsernotes

            let username = "geo1088"
            let notesForUser = usernotes.notes(onUser: username)
            debugPrint(notesForUser)
            XCTAssertEqual(notesForUser[0].user, username, "Username should match")
            XCTAssertEqual(notesForUser[0].text, "It's a secret to everyone", "Note text should match")
        }
    }

    static var allTests = [
        ("testUsernotesData", testUsernotesData),
    ]
}
