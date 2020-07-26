
import Foundation

class SocketLayerMock: SocketLayer {
    
    var isConnectionStart = false
    var handledSubscription = false
    
    func startConnect(completionResponse: @escaping (StockCompanyData) -> (), completionConnect: @escaping (Bool, Error?) -> ()) {
        isConnectionStart = true
    }
    
    func handleSubscription(with state: SubscriptionState, _ companySymbol: String) {
        handledSubscription = true
    }
}
