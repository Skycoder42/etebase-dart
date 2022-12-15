// coverage:ignore-file

/// Error codes indicating what went wrong.
enum EtebaseErrorCode {
  /// No error occurred.
  noError,

  /// A generic error occurred.
  generic,

  /// Failed to parse a URL or to locate a cached resource.
  urlParse,

  /// Invalid message pack data.
  msgPack,

  /// API missuses.
  programmingError,

  /// Required content of an item is missing.
  missingContent,

  /// Invalid padding detected.
  padding,

  /// Invalid base64 encoded data detected.
  base64,

  /// An error occurred in a cryptographic operation.
  encryption,

  /// Authorization is required to access the resource.
  unauthorized,

  /// A conflict between local and remote changes has been detected.
  conflict,

  /// Access to the resource has not been granted.
  permissionDenied,

  /// The resource was not found on the server.
  notFound,

  /// Problems with establishing the connection to the server.
  connection,

  /// A temporary server error occurred.
  temporaryServerError,

  /// A permanent server error occurred.
  serverError,

  /// A http error occurred.
  http,
}
