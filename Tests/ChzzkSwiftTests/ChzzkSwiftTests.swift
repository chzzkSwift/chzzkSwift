@testable import chzzkSwift
import XCTest

final class ChzzkSwiftTests: XCTestCase {
    var chzzkSwift: ChzzkSwift!

    override func setUp() {
        super.setUp()
        chzzkSwift = ChzzkSwift()
    }

    override func tearDown() {
        chzzkSwift = nil
        super.tearDown()
    }

    func testRecommendationChannels() async throws {
        let res = try await chzzkSwift.getRecommendationChannels()

        XCTAssert(res.count > 0)
    }

    func testSearch() async throws {
        let res = try await chzzkSwift.searchChannels("랄로")

        XCTAssert(res.count > 0)
        print("res count: \(res.count)")
        XCTAssertEqual(res[0].channel.channelName, "랄로")
    }
    
    func testRecommendedLiveBroadcasts() async throws {
        let res = try await chzzkSwift.getRecommendedLiveBroadcasts(deviceType: "PC")
        
        print("res liveplaybackJson -> \(res[0].decodeLivePlaybackJson()!)")
        
        XCTAssert(res.count > 0)
    }
    
    func testgetLiveAddress() async throws {
        
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
        
        let res = try await chzzkSwift.getLiveAddress(channelId: "\(data.channelId)")
        print(res)
    }
}
