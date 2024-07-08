import XCTest
@testable import chzzkSwift

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
    
    func testSearch() {
        let expectation = self.expectation(description: "Search API Call")
        
        chzzkSwift.getRecommendationChannels()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
