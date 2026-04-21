struct NASAErrorResponse: Decodable {
    var error: ErrorBody?
    var msg: String?
}

extension NASAErrorResponse {
    struct ErrorBody: Decodable {
        var message: String?
    }
}
