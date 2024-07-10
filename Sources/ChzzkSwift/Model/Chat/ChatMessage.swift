import Foundation

struct ChzzkChatProfile: Codable {
    let userIdHash: String
    let nickname: String
    let profileImageUrl: String?
    let userRoleCode: String
    let badge: String?
    let title: String?
    let verifiedMark: Bool
    let activityBadges: [ChzzkActivityBadge]
    let streamingProperty: ChzzkStreamingProperty
}

struct ChzzkActivityBadge: Codable {
    let badgeNo: Int
    let badgeId: String
    let imageUrl: String
    let activated: Bool
}

struct ChzzkStreamingProperty: Codable {
    let nicknameColor: ChzzkNicknameColor
}

struct ChzzkNicknameColor: Codable {
    let colorCode: String
}

struct ChzzkDonationExtras: Codable {
    let isAnonymous: Bool
    let payType: String
    let payAmount: Int
    let nickname: String
    let donationType: String
    let weeklyRankList: [ChzzkWeeklyRank]
    let donationUserWeeklyRank: ChzzkDonationUserWeeklyRank
}

struct ChzzkWeeklyRank: Codable {
    let userIdHash: String
    let nickName: String
    let verifiedMark: Bool
    let donationAmount: Int
    let ranking: Int
}

struct ChzzkDonationUserWeeklyRank: Codable {
    let userIdHash: String
    let nickName: String
    let verifiedMark: Bool
    let donationAmount: Int
    let ranking: Int
}

struct ChzzkMessage: Codable {
    let msg: String
    let nickname: String
    let colorCode: String?
    let donationAmount: Int?

    init(fromChat chat: ChzzkChatMessage) {
        self.msg = chat.msg
        self.nickname = chat.profile.nickname
        self.colorCode = chat.profile.streamingProperty.nicknameColor.colorCode
        self.donationAmount = nil
    }

    init(fromRecentChat chat: ChzzkNewRecentChatMessage.ChzzkRecentChatMessage) {
        self.msg = chat.content
        self.nickname = chat.profile.nickname
        self.colorCode = chat.profile.streamingProperty.nicknameColor.colorCode
        self.donationAmount = nil
    }

    init(fromDonation donation: ChzzkDonationMessage) {
        self.msg = donation.msg
        self.nickname = donation.profile.nickname
        self.colorCode = nil
        self.donationAmount = donation.extras.payAmount
    }
}

struct ChzzkChatMessage: Codable {
    let svcid: String
    let cid: String
    let mbrCnt: Int
    let uid: String
    let profile: ChzzkChatProfile
    let msg: String
    let msgTypeCode: Int
    let msgStatusType: String
    let extras: String?
    let ctime: Int
    let utime: Int
    let msgTid: String?
    let msgTime: Int

    enum CodingKeys: String, CodingKey {
        case svcid
        case cid
        case mbrCnt
        case uid
        case profile
        case msg
        case msgTypeCode
        case msgStatusType
        case extras
        case ctime
        case utime
        case msgTid
        case msgTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.svcid = try container.decode(String.self, forKey: .svcid)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.mbrCnt = try container.decode(Int.self, forKey: .mbrCnt)
        self.uid = try container.decode(String.self, forKey: .uid)
        let profileString = try container.decode(String.self, forKey: .profile)
        let profileData = Data(profileString.utf8)
        self.profile = try JSONDecoder().decode(ChzzkChatProfile.self, from: profileData)
        self.msg = try container.decode(String.self, forKey: .msg)
        self.msgTypeCode = try container.decode(Int.self, forKey: .msgTypeCode)
        self.msgStatusType = try container.decode(String.self, forKey: .msgStatusType)
        self.extras = try container.decodeIfPresent(String.self, forKey: .extras)
        self.ctime = try container.decode(Int.self, forKey: .ctime)
        self.utime = try container.decode(Int.self, forKey: .utime)
        self.msgTid = try container.decodeIfPresent(String.self, forKey: .msgTid)
        self.msgTime = try container.decode(Int.self, forKey: .msgTime)
    }
}

struct ChzzkDonationMessage: Codable {
    let svcid: String
    let cid: String
    let mbrCnt: Int
    let uid: String
    let profile: ChzzkChatProfile
    let msg: String
    let msgTypeCode: Int
    let msgStatusType: String
    let extras: ChzzkDonationExtras
    let ctime: Int
    let utime: Int
    let msgTid: String?
    let msgTime: Int

    enum CodingKeys: String, CodingKey {
        case svcid
        case cid
        case mbrCnt
        case uid
        case profile
        case msg
        case msgTypeCode
        case msgStatusType
        case extras
        case ctime
        case utime
        case msgTid
        case msgTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.svcid = try container.decode(String.self, forKey: .svcid)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.mbrCnt = try container.decode(Int.self, forKey: .mbrCnt)
        self.uid = try container.decode(String.self, forKey: .uid)
        let profileString = try container.decode(String.self, forKey: .profile)
        let profileData = Data(profileString.utf8)
        self.profile = try JSONDecoder().decode(ChzzkChatProfile.self, from: profileData)
        self.msg = try container.decode(String.self, forKey: .msg)
        self.msgTypeCode = try container.decode(Int.self, forKey: .msgTypeCode)
        self.msgStatusType = try container.decode(String.self, forKey: .msgStatusType)
        self.extras = try container.decode(ChzzkDonationExtras.self, forKey: .extras)
        self.ctime = try container.decode(Int.self, forKey: .ctime)
        self.utime = try container.decode(Int.self, forKey: .utime)
        self.msgTid = try container.decodeIfPresent(String.self, forKey: .msgTid)
        self.msgTime = try container.decode(Int.self, forKey: .msgTime)
    }
}

struct ChzzkNewRecentChatMessage: Codable {
    let messageList: [ChzzkRecentChatMessage]
    let userCount: Int
    let notice: String?

    struct ChzzkRecentChatMessage: Codable {
        let serviceId: String
        let channelId: String
        let messageTime: Int
        let userId: String
        let profile: ChzzkChatProfile
        let content: String
        let extras: String
        let memberCount: Int
        let messageTypeCode: Int
        let messageStatusType: String
        let createTime: Int
        let updateTime: Int
        let msgTid: String?

        private enum CodingKeys: String, CodingKey {
            case serviceId, channelId, messageTime, userId, profile, content, extras, memberCount, messageTypeCode, messageStatusType, createTime, updateTime, msgTid
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.serviceId = try container.decode(String.self, forKey: .serviceId)
            self.channelId = try container.decode(String.self, forKey: .channelId)
            self.messageTime = try container.decode(Int.self, forKey: .messageTime)
            self.userId = try container.decode(String.self, forKey: .userId)
            let profileString = try container.decode(String.self, forKey: .profile)
            let profileData = profileString.data(using: .utf8)!
            self.profile = try JSONDecoder().decode(ChzzkChatProfile.self, from: profileData)
            self.content = try container.decode(String.self, forKey: .content)
            self.extras = try container.decode(String.self, forKey: .extras)
            self.memberCount = try container.decode(Int.self, forKey: .memberCount)
            self.messageTypeCode = try container.decode(Int.self, forKey: .messageTypeCode)
            self.messageStatusType = try container.decode(String.self, forKey: .messageStatusType)
            self.createTime = try container.decode(Int.self, forKey: .createTime)
            self.updateTime = try container.decode(Int.self, forKey: .updateTime)
            self.msgTid = try container.decodeIfPresent(String.self, forKey: .msgTid)
        }
    }
}
