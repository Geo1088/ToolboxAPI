import XCTest
@testable import ToolboxAPI

let jsonStrings = ["""
{"ver":6,"constants":{"users":["geo1088","somebodyElse"],"warnings":[null,"spamwarn"]},"blob":"eJxdzEEKwjAQBdCrhL9xk0WGGk1zA88gUoqOgjSNJEEtJXd3aOnGzXyGz38zHhzJOAc/Y8zwZwl4nMouq15lviYuqkTFb05THBkaBZ6sbRsyR2s0ArzcQUbSfeSpl6o3tuv+4PzqQ5jUEpw2zVl3aN2+WTRatUHfiZ7f26qSqPUH9moxBA=="}
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
            XCTAssertNotNil(otherUsernotes, "wat")
            // TODO: test data equality between usernotes and otherUsernotes

            let username = "geo1088__"
            let notesForUser = usernotes.notes(onUser: username)
            debugPrint(notesForUser)
            XCTAssertEqual(notesForUser[0].user, username, "Username should match")
            XCTAssertEqual(notesForUser[0].text, "spammy spammer", "Note text should match")
            XCTAssertEqual(notesForUser[0].mod, "somebodyElse", "Mod should match")
        }
    }

    static var allTests = [
        ("testUsernotesData", testUsernotesData),
    ]
}
