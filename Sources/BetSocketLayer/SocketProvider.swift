import Foundation
import Starscream

public enum SubscriptionState: String {
    case subscribe
    case unsubscribe
}

public class SocketProvider {
    var socketLayer: SocketLayerDelegate?
    
    public init(token: String) {
        socketLayer = SocketLayer(token: token)
    }
    
    public func startConnect(completionConnect:@escaping (Bool, Error?) -> (), completionResponse:@escaping (StockCompanyData) -> ()) {
        socketLayer?.startConnect(completionResponse: completionResponse, completionConnect: completionConnect)
    }
    
    public func handleSubscription(with state: SubscriptionState, _ companySymbol: String) {
        socketLayer?.handleSubscription(with: state, companySymbol)
    }
}

