import Foundation

public struct ChatAccessTokenResponse: Codable {
    let code: Int
    let message: String?
    let content: ChatAccessTokenContent
}

// MARK: - Content
public struct ChatAccessTokenContent: Codable {
    let accessToken: String
    let temporaryRestrict: TemporaryRestrict
    let realNameAuth: Bool
    let extraToken: String
}

// MARK: - TemporaryRestrict
public struct TemporaryRestrict: Codable {
    let temporaryRestrict: Bool
    let times: Int
    let duration, createdTime: Int?
}