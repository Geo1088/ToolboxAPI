import Foundation
import SwiftyJSON
import Gzip

/// TODO
public class UsernotesData {

    // MARK: Constants

    /// The latest usernotes schema version that this library can handle. If a usernotes page reports a schema version higher than this number, it can't be processed with this version of the library.
    static let latestKnownSchema = 6;

    /// The earliest usernotes schema version that this library can handle. If a usernotes page reports a schema version lower than this number, it can't be processed with this version of the library.
    static let earliestKnownSchema = 4;
    
    // MARK: Instance properties

    let ver: Int
    let users: JSON

//    var notes: [RawUsernote]

    // MARK: Initializers
    
    private init(json: JSON) throws {
        guard let ver = json["ver"].int else { throw ToolboxAPIError.invalidData }
        self.ver = ver
        guard self.ver <= UsernotesData.latestKnownSchema else { throw ToolboxAPIError.schemaTooNew }
        guard self.ver >= UsernotesData.earliestKnownSchema else { throw ToolboxAPIError.schemaTooOld }

        // TODO: Schema upgrades

        guard let blob = json["blob"].string else { throw ToolboxAPIError.invalidData }
        guard let users = try? ToolboxBlob.inflate(blob) else { throw ToolboxAPIError.invalidData }
        self.users = users
    }

    convenience init(data: Data) throws {
        guard let json = try? JSON(data: data) else {
            throw ToolboxAPIError.invalidData
        }
        try self.init(json: json)
    }
    
    convenience init?(parseJSON: String) throws {
        try self.init(json: JSON(parseJSON: parseJSON))
    }

    // MARK: Data retrieval

    public func asJSON() -> JSON? {
        guard let blob = try? ToolboxBlob.deflate(self.users) else {
            return nil
        }
        return JSON([
            "ver": self.ver,
            "blob": blob,
        ])
    }

    public func asString() -> String? {
        guard let json = self.asJSON() else { return nil }
        return json.rawString([.jsonSerialization: JSONSerialization.WritingOptions()])
    }

    public func asData() -> Data? {
        return self.asString()?.data(using: .utf8)
    }

    // MARK: - Getting usernotes

    /// Returns all usernotes on a specific user.
    public func notes(onUser user: String) -> [Usernote] {
        // If the user isn't in the users map, return no notes
        guard let notes = self.users[user]["ns"].array else {
            return []
        }
        return notes.map { note in
            Usernote(user: user, text: note["n"].string ?? "", mod: nil, type: nil, link: nil, date: nil)
        }
    }
}
