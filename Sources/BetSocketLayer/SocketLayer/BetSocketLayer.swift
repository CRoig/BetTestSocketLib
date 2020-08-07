import Starscream
import Foundation

protocol SocketLayer {
    func startConnect(completionResponse:@escaping (StockCompanyData) -> (), completionConnect:@escaping (Bool, Error?) -> ())
    func handleSubscription(with state: SubscriptionState, _ companySymbol: String) 
}

final class SocketLayerImp: WebSocketDelegate, SocketLayer {
    func websocketDidConnect(socket: WebSocketClient) {
         completionConnection?(true, nil)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        completionConnection?(false, SocketError.disconnected)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        do {
            let company = try JSONDecoder().decode(StockCompany.self, from: text.data(using: .utf8)!)
            completionResponse?(company.data.first!)
        } catch {}
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
    
    
    var completionResponse:((StockCompanyData) -> Void)?
    var completionConnection:((Bool, Error?) -> Void)?
    
    private var socket: WebSocket!
//    private let server = WebSocketServer()
    private var token: String
    private let encoder = JSONEncoder()
    
    init(token: String) {
        self.token = token
        //TODO: URL must be stored as baseURL, path and so on
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
    
//    internal func didReceive(event: WebSocketEvent, client: WebSocket) {
//        switch event {
//        case .connected(let headers):
//            completionConnection?(true, nil)
//        case .disconnected( _, _):
//            completionConnection?(false, SocketError.disconnected)
//        case .text(let string):
//            do {
//                let company = try JSONDecoder().decode(StockCompany.self, from: string.data(using: .utf8)!)
//                completionResponse?(company.data.first!)
//            } catch {
//                break
//            }
//        case .error(let error):
//            completionConnection?(false, error)
//        default: break
//        }
//    }
}
