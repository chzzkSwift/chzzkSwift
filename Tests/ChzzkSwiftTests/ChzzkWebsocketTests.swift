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
        let dummy = try! await chzzkSwift.getRecommendationChannels().first

        guard let data = dummy else {
            XCTFail("data is nil")
            return
        }

        if(!data.streamer.openLive)
        {
            XCTFail("Streamer is not live")
            return
        }

        let liveStatus = try! await chzzkSwift.getLiveStatus(data.channel.channelId)

        print(liveStatus.liveTitle)
        
        print(liveStatus.chatChannelId)
        await chzzkSwift.connectChat(liveStatus.chatChannelId!)
        // 일정 시간 동안 대기하여 메시지 수신 확인
       let expectation = self.expectation(description: "Waiting for messages")
       DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
           expectation.fulfill()
       }
        await waitForExpectations(timeout: 300, handler: nil)
    }
}
