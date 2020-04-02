import Foundation
import SwiftyJSON
import Gzip

/// Converts a Toolbox blob into a JSON object.
func inflateBlob(_ blob: String) throws -> JSON {

    // Base64 to raw data
    guard let data = Data(base64Encoded: blob) else { throw ToolboxAPIError.invalidData }

    // Decompress
    guard let decompressedData = try? data.gunzipped() else { throw ToolboxAPIError.invalidData }

    // Parse JSON
    return try JSON(data: decompressedData)
}

/// Converts a JSON object into a Toolbox blob.
func deflateBlob(_ json: JSON) throws -> String {

    // Use blank serialization options to ensure the string doesn't get pretty-printed
    var options: JSONSerialization.WritingOptions
    if #available(OSX 10.13, *) {
        options = JSONSerialization.WritingOptions.sortedKeys
    } else {
        options = JSONSerialization.WritingOptions()
    }

    // Convert JSON to string
    guard let string = json.rawString([.jsonSerialization: options]) else { throw ToolboxAPIError.invalidData }
    guard let data = string.data(using: .utf8) else { throw ToolboxAPIError.invalidData }

    // Compress data
    guard let compressedData = try? data.gzipped() else { throw ToolboxAPIError.invalidData }

    // Base64-encode
    return compressedData.base64EncodedString()
}

/// TODO
class UsernotesData {

    // MARK: Constants

    /// The latest usernotes schema version that this library can handle. If a usernotes page reports a schema version higher than this number, it can't be processed with this version of the library.
    static let latestKnownSchema = 6;

    /// The earliest usernotes schema version that this library can handle. If a usernotes page reports a schema version lower than this number, it can't be processed with this version of the library.
    static let earliestKnownSchema = 4;
    
    // MARK: Instance properties

    let ver: Int
    let json: JSON
    let users: JSON

//    var notes: [RawUsernote]

    // MARK: Initializers
    
    private init(json: JSON) throws {
        self.json = json

        guard let ver = self.json["ver"].int else { throw ToolboxAPIError.invalidData }
        self.ver = ver
        guard self.ver <= UsernotesData.latestKnownSchema else { throw ToolboxAPIError.schemaTooNew }
        guard self.ver >= UsernotesData.earliestKnownSchema else { throw ToolboxAPIError.schemaTooOld }

        // TODO: Schema upgrades

        guard let blob = json["blob"].string else { throw ToolboxAPIError.invalidData }
        guard let users = try? inflateBlob(blob) else { throw ToolboxAPIError.invalidData }
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
}
