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
            let usernotes = try! UsernotesData(parseJSON: string)
            XCTAssertNotNil(usernotes, "wat")
            let string = usernotes!.asString()
            XCTAssertNotNil(string, "wat")
            XCTAssertFalse(string!.contains("\n"), "Output must be minified")
            let data = usernotes!.asData()
            XCTAssertNotNil(data, "wat")
            let otherUsernotes = try! UsernotesData(data: data!)
            // TODO: test data equality
        }
    }

    static var allTests = [
        ("testUsernotesData", testUsernotesData),
    ]
}
