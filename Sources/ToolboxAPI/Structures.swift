import Foundation

/// A raw usernote representation.
public struct RawUsernote: Hashable {
    /// Timestamp (seconds since epoch)
    public let t: Int?
    /// Note text
    public let n: String?
    /// Index in constants.users of moderator who left this note
    public let m: Int?
    /// Index in constants.warnings of this note's type's key
    public let w: Int?
    /// Permalink of note context, in shortened format
    public let l: String?
}

/// A usernote type, e.g. "Permanant ban", "Good contributor", etc.
public struct UsernoteType: Hashable {
    /// The name of the note type
    public let name: String
    /// The color associated with this note type
    public let color: String // TODO: return this as a friendlier type
    /// The internal storage key used for the note type
    public let key: String
}

/// A single usernote.
public struct Usernote: Hashable {
    /// The name of the user associated with the note
    public let user: String
    /// The text of the note
    public let text: String
    /// The name of the moderator who left the note
    public let mod: String?
    /// The type of the note
    public let type: UsernoteType?
    /// The context link for the note
    public let link: String?
    /// The date and time of the note's creation
    public let date: Date?
}
