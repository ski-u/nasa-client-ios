import Foundation

public enum NASAClientError: LocalizedError {
    case httpError(statusCode: Int, message: String?)
    case missingAPIKey
    case unexpectedResponse
    
    public var errorDescription: String? {
        switch self {
        case let .httpError(statusCode, message):
            let detail = message ?? Self.defaultMessage(for: statusCode)
            return [
                "HTTP \(statusCode)",
                detail,
            ].compactMap { $0 }.joined(separator: ": ")

        case .missingAPIKey:
            return String(
                localized: "API key configuration is required in the Settings tab to retrieve data",
                bundle: .module,
            )

        case .unexpectedResponse:
            return String(
                localized: "Received an unexpected non-HTTP response",
                bundle: .module,
            )
        }
    }
    
    private static func defaultMessage(for statusCode: Int) -> String? {
        switch statusCode {
        case 400: "Bad Request"
        case 401: "Unauthorized"
        case 403: "Forbidden"
        case 404: "Not Found"
        case 429: "Too Many Requests"
        case 500: "Internal Server Error"
        case 503: "Service Unavailable"
        default: nil
        }
    }
}
