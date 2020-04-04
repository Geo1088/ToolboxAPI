import Foundation
import SwiftyJSON
import Gzip

/// TODO
public class UsernotesData {

    // MARK: - Constants

    /// The latest usernotes schema version that this library can handle. If a usernotes page reports a schema version higher than this number, it can't be processed with this version of the library.
    public static let latestKnownSchema = 6;

    /// The earliest usernotes schema version that this library can handle. If a usernotes page reports a schema version lower than this number, it can't be processed with this version of the library.
    public static let earliestKnownSchema = 4;
    
    // MARK: - Instance properties

    let users: JSON
    let constants: [String: JSON]

    // MARK: - Initializers

    public init(_ inputJSON: JSON) throws {
        // TODO: We have to make a copy of the JSON object so we can modify it. Is there a better way?
        guard var json = try? inputJSON.merged(with: JSON([:])) else { throw ToolboxAPIError.invalidData }
        guard let ver = json["ver"].int else { throw ToolboxAPIError.invalidData }

        // Check if we can work with this schema
        guard ver <= UsernotesData.latestKnownSchema else { throw ToolboxAPIError.schemaTooNew }
        guard ver >= UsernotesData.earliestKnownSchema else { throw ToolboxAPIError.schemaTooOld }

        // Schema upgrades
        switch ver {
        case 4:
            // Version 4 specifies timestamps in milliseconds, version 5+ uses seconds
            guard let users = json["data"].dictionary else { throw ToolboxAPIError.invalidData }
            for (user, value) in users {
                guard let notes = value["ns"].array else { throw ToolboxAPIError.invalidData }
                for (index, note) in notes.enumerated() {
                    if note["t"].int != nil {
                        json["data"][user]["ns"][index]["t"].int = note["t"].intValue / 1000
                    }
                }
            }
            fallthrough

        case 5:
            // Version 5 uses a "data" key with raw JSON, version 6+ uses a "blob" key
            do {
                json["blob"].string = try ToolboxBlob.deflate(json["data"])
                json["data"].string = nil
            } catch {
                throw ToolboxAPIError.invalidData
            }
        default: break
        }

        guard let constants = json["constants"].dictionary else { throw ToolboxAPIError.invalidData }
        self.constants = constants

        guard let blob = json["blob"].string else { throw ToolboxAPIError.invalidData }
        guard let users = try? ToolboxBlob.inflate(blob) else { throw ToolboxAPIError.invalidData }
        self.users = users
    }

    public convenience init(data: Data) throws {
        guard let json = try? JSON(data: data) else {
            throw ToolboxAPIError.invalidData
        }
        try self.init(json)
    }
    
    public convenience init(parseJSON: String) throws {
        try self.init(JSON(parseJSON: parseJSON))
    }

    // MARK: - Data finalization

    public func asJSON() -> JSON? {
        guard let blob = try? ToolboxBlob.deflate(self.users) else {
            return nil
        }
        return JSON([
            // Usernotes are always updated to the latest version when they're read
            "ver": UsernotesData.latestKnownSchema,
            "constants": self.constants,
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
            // Look up mod name from constants
            var mod: String? = nil
            if let modIndex = note["m"].int {
                mod = constants["users"]?[modIndex].string
            }

            return Usernote(
                user: user,
                text: note["n"].string ?? "",
                mod: mod,
                type: nil,
                link: nil,
                date: nil)
        }
    }
}
