import XCTest
@testable import BetSocketLayer

final class BetSocketLayerTests: XCTestCase {
    
    var sut: SocketProvider!
    var layerMock: SocketLayerMock!
    
    override func setUp() {
        super.setUp()
        sut = SocketProvider(token: "")
        
        layerMock = SocketLayerMock()
        sut.socketLayer = layerMock
    }
    
    func test_StartConnect_WhenLayerMock_ShouldStartConnection() {
        sut.startConnect(completionConnect: { (connect, error) in
            XCTAssertTrue(self.layerMock.isConnectionStart)
        }) { (company) in
            XCTAssertTrue(self.layerMock.isConnectionStart)
        }
    }
    
    func test_HandleSubscription_WhenSubscribe_ShouldCallLayer() {
        sut.handleSubscription(with: .subscribe, "AMZN")
        XCTAssertTrue(self.layerMock.handledSubscription)
    }
    
    static var allTests = [
        ("StartConnect", test_StartConnect_WhenLayerMock_ShouldStartConnection),
        ("HandleSubscription", test_HandleSubscription_WhenSubscribe_ShouldCallLayer),
    ]
}
