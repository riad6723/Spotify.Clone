import Foundation

struct NewReleasesResponse: Codable {
    let albums: Album
}

struct Image: Codable {
    let height: Int?
    let width: Int?
    let url: String
}
