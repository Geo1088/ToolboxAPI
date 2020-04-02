import XCTest
@testable import ToolboxAPI

let jsonString = """
{
    "ver": 6,
    "blob": "eJyrVkpPzTc0sLBQsqpWyitWsoquVipRsjI0NbU0NjQwNzXQUcpTslLyLFEvVkhUKE5NLkotUSjJV0gtSy2qzM9LVdJRKgcq11HKBZK1sbW1AKKCF4Q="
}
"""

final class ToolboxAPITests: XCTestCase {
    func testUsernotesData() {
        debugPrint()

        guard let usernotes = try? UsernotesData(parseJSON: jsonString) else { return }

        debugPrint(try! deflateBlob(usernotes.users))

        XCTAssertEqual(usernotes.ver, 6)

        debugPrint()
    }

    static var allTests = [
        ("testUsernotesData", testUsernotesData),
    ]
}
