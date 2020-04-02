/// Errors related to parsing Toolbox data from wiki pages.
public enum ToolboxAPIError: Error {
    /// This version of the library can't handle the page's schema version.
    case schemaTooOld
    /// This version of the library can't handle the page's schema version.
    case schemaTooNew
    /// The data doesn't follow a schema version or the version is missing.
    case invalidData
}
