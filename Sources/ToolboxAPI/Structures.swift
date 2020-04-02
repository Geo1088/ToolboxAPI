import Foundation

/// A raw usernote representation.
struct RawUsernote {
    /// Timestamp (seconds since epoch)
    let t: Int?
    /// Note text
    let n: String?
    /// Index in constants.users of moderator who left this note
    let m: Int?
    /// Index in constants.warnings of this note's type's key
    let w: Int?
    /// Permalink of note context, in shortened format
    let l: String?
}

/// A usernote type, e.g. "Permanant ban", "Good contributor", etc.
struct UsernoteType {
    /// The name of the note type
    let name: String
    /// The color associated with this note type
    let color: String // TODO: return this as a friendlier type
    /// The internal storage key used for the note type
    let key: String
}

/// A single usernote.
struct Usernote {
    /// The name of the user associated with the note
    let user: String
    /// The text of the note
    let text: String
    /// The name of the moderator who left the note
    let mod: String?
    /// The type of the note
    let type: UsernoteType?
    /// The context link for the note
    let link: String?
    /// The date and time of the note's creation
    let date: Date
}
