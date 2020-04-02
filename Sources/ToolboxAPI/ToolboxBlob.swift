import Foundation
import SwiftyJSON

/// Provides static methods for converting between JSON and
public class ToolboxBlob {
    /// Converts a Toolbox blob into a JSON object.
    public static func inflate(_ blob: String) throws -> JSON {

        // Base64 to raw data
        guard let data = Data(base64Encoded: blob) else { throw ToolboxAPIError.invalidData }

        // Decompress
        guard let decompressedData = try? data.gunzipped() else { throw ToolboxAPIError.invalidData }

        // Parse JSON
        return try JSON(data: decompressedData)
    }

    /// Converts a JSON object into a Toolbox blob.
    public static func deflate(_ json: JSON) throws -> String {

        // Use blank serialization options to ensure the string doesn't get pretty-printed
        let options = JSONSerialization.WritingOptions()

        // Convert JSON to string
        guard let string = json.rawString([.jsonSerialization: options]) else { throw ToolboxAPIError.invalidData }
        guard let data = string.data(using: .utf8) else { throw ToolboxAPIError.invalidData }

        // Compress data
        guard let compressedData = try? data.gzipped() else { throw ToolboxAPIError.invalidData }

        // Base64-encode
        return compressedData.base64EncodedString()
    }

}
