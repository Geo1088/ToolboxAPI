# ToolboxAPI

Swift helpers for interfacing with Reddit Moderator Toolbox usernotes and settings.

## Usage

```swift
// Get JSON data from Reddit however you like
let jsonString = "{"ver": 6, "constants": ...}"

// Create a UsernotesData instance
let usernotes = UsernotesData(parseJSON: jsonString)

// Get usernotes for a certain user
usernotes.notes(onUser: "geo1088").forEach { note in
    print("\(note.user): \(note.text)")
}
```
