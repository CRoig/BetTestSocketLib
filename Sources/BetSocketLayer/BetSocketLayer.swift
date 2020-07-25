import Starscream
import Foundation

protocol SocketLayerDelegate {
    func startConnect(completionResponse:@escaping (StockCompanyData) -> (), completionConnect:@escaping (Bool, Error?) -> ())
    func handleSubscription(with state: SubscriptionState, _ companySymbol: String) 
}

class SocketLayer: WebSocketDelegate, SocketLayerDelegate {
    
    var completionResponse:((StockCompanyData) -> Void)?
    var completionConnection:((Bool, Error?) -> Void)?
    
    var socket: WebSocket!
    let server = WebSocketServer()
    var token: String
    
    let encoder = JSONEncoder()
    
    init(token: String) {
        self.token = token
        var request = URLRequest(url: URL(string: "wss://ws.finnhub.io/?token=\(token)")!)
        request.timeoutInterval = 1
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func startConnect(completionResponse:@escaping (StockCompanyData) -> (), completionConnect:@escaping (Bool, Error?) -> ()) {
        self.completionConnection = completionConnect
        self.completionResponse = completionResponse
        socket.connect()
    }
    
    func handleSubscription(with state: SubscriptionState, _ companySymbol: String) {
        let dic = ["type":state.rawValue,"symbol":companySymbol]
        if let jsonData = try? encoder.encode(dic), let jsonString = String(data: jsonData, encoding: .utf8) {
            socket.write(string: jsonString, completion: nil)
        }
    }
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            completionConnection?(true, nil)
        case .disconnected( _, _):
            completionConnection?(false, SocketError.disconnected)
        case .text(let string):
            do {
                let company = try JSONDecoder().decode(StockCompany.self, from: string.data(using: .utf8)!)
                completionResponse?(company.data.first!)
            } catch {
                break
            }
        case .error(let error):
            completionConnection?(false, error)
        default: break
        }
    }
}
