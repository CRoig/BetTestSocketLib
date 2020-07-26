import Foundation
import Starscream

public enum SubscriptionState: String {
    case subscribe
    case unsubscribe
}

final public class SocketProvider {
    
    var socketLayer: SocketLayer?
    
    /// Designated initializers of SocketLayer
    ///
    /// - warning: token should be in right form, this method do not validate token.
    /// - parameter token: String that represent API token
    /// - returns: instance object of SocketLayer
    public init(token: String) {
        socketLayer = SocketLayerImp(token: token)
    }
    
    /// Initiate and start connection with WSS
    ///
    /// - parameter completionConnect: handle connectivity of socket connection
    /// - parameter completionResponse: handle response of socket connection
    public func startConnect(completionConnect:@escaping (Bool, Error?) -> (), completionResponse:@escaping (StockCompanyData) -> ()) {
        socketLayer?.startConnect(completionResponse: completionResponse, completionConnect: completionConnect)
    }
    
    /// Handle subscription of company, subscribe or unsubscribe
    ///
    /// - parameter state: enum case of type: SubscriptionState
    /// - parameter companySymbol: symbol (company abbreviation) that should be subscribed or unsubscribed
    public func handleSubscription(with state: SubscriptionState, _ companySymbol: String) {
        socketLayer?.handleSubscription(with: state, companySymbol)
    }
}

