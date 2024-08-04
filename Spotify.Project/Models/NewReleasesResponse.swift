import Foundation

struct NewReleasesResponse: Codable {
    let albums: Album
}

struct Album: Codable {
    let href: String
    let items: [Item]
}

struct Image: Codable {
    let height: Int?
    let width: Int?
    let url: String
}
