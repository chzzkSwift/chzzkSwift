import Foundation

struct UserProfileResponse: Decodable {
    let code: Int
    let message: String?
    let content: UserProfile
}

struct UserProfile: Decodable {
    let hasProfile: Bool
    let userIdHash: String?
    let nickname: String?
    let profileImageUrl: String?
    let penalties: [String]?
    let officialNotiAgree: Bool
    let officialNotiAgreeUpdatedDate: String?
    let verifiedMark: Bool
    let loggedIn: Bool
}
