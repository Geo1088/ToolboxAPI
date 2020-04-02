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

