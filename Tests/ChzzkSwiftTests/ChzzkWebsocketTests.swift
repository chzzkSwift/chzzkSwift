@testable import chzzkSwift
import XCTest

final class ChzzkWebsocketTests: XCTestCase {
    var chzzkSwift: ChzzkSwift!
    var dummyData: RecommendationChannel!
    override func setUp() {
        super.setUp()
        chzzkSwift = ChzzkSwift()
    }

    override func tearDown() {
        chzzkSwift = nil
        super.tearDown()
    }

    func testWebSocket() async {
        let dummy = try! await chzzkSwift.getRecommendationChannels().filter( { $0.liveInfo.concurrentUserCount > 100 }).first

        guard let data = dummy else {
            XCTFail("data is nil")
            return
        }

        if !data.streamer.openLive {
            XCTFail("Streamer is not live")
            return
        }

        let liveStatus = try! await chzzkSwift.getLiveStatus(data.channel.channelId)

        print(liveStatus.liveTitle)

        print(liveStatus.chatChannelId!)
        await chzzkSwift.connectChat(liveStatus.chatChannelId!)
        // 일정 시간 동안 대기하여 메시지 수신 확인
        let expectation = self.expectation(description: "Waiting for messages")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 30, enforceOrder: false)
    }

    func testWebsocketInnitalMessage() async throws {
        let channelId: String? = try await chzzkSwift.getRecommendationChannels().filter( { $0.liveInfo.concurrentUserCount > 100 }).first?.channel.channelId
        let chatChannelId = try await chzzkSwift.getLiveStatus(channelId!).chatChannelId!
        let accessToken = try await chzzkSwift.getChatAccessToken(chatChannelId)
        let uid: String? = nil
        let connectMessage = """
        {"ver":"3","cmd":100,"svcid":"game","cid":"\(chatChannelId)","bdy":{"uid":"\(uid ?? "null")","devType":2001,"accTkn":"\(accessToken)","auth":"READ","libVer":"4.9.3","osVer":"macOS/10.15.7","devName":"Google Chrome/126.0.0.0","locale":"ko","timezone":"Asia/Seoul"},"tid":1}
        """
        
        let obj = ChzzkInitialConnectMessage(chatChannelId: chatChannelId, accessToken: accessToken, uid: uid)
        

        XCTAssertEqual(connectMessage, obj.description)
    }
}
