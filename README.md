# ToolboxAPI

Swift helpers for interfacing with Reddit Moderator Toolbox usernotes and settings.

This repo is heavily in development. It currently only supports reading usernotes from individual users, and will always report `nil` for dates, note types, and and links.

## Intallation

**Note:** It's recommended to install via the `master` branch rather than a specific commit/version until a 1.0 release is made.

### Via Swift Package Manager

Add this repository through File > Swift Packages > Add Package Dependency, or add directly to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Geo1088/ToolboxAPI.git", .branch("master")),
]
```

### Via CocoaPods

Add this repository in your `Podfile`:

```ruby
pod 'ToolboxAPI', :git => 'https://github.com/Geo1088/ToolboxAPI.git', :branch => 'master'
```

Then run `pod install` to fetch the latest version.

### Via Carthage

Maybe eventually, drop an issue if you see this and use Carthage

## Usage

The main class of the library at the moment is `UsernotesData`. Pass it the contents of a usernotes wiki page as a string or `Data`, and it'll give you easy access to the usernotes of any user you like.

```swift
// Get the contents of /r/<sub>/wiki/usernotes via a web request
let jsonString = "{"ver": 6, "constants": ...}"

// Create a UsernotesData instance from a JSON string
let usernotes = UsernotesData(parseJSON: jsonString)
// Or create a UsernotesData instance from a Data object
let usernotes = UsernotesData(data: jsonString.data(using: .utf8))

// Get usernotes for a certain user
usernotes.notes(onUser: "geo1088").forEach { note in
    // note is a Usernote structure
    print("\(note.mod ?? 'No mod'): \(note.text)")
}
```

The library also defined structures to represent usernotes and note types (`Usernote` and `UsernoteType` respectively), as well as a `ToolboxBlob` class with static methods for converting between JSON objects and Toolbox's compressed base64 blob strings. You shouldn't need to invoke this class normally, but it's exposed for completeness.

## License

[MIT &copy; Geo1088](/LICENSE)
