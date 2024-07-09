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
        await chzzkSwift.connectChat(liveStatus.chatChannelId)
        await waitForExpectations(timeout: 3600)
    }
}