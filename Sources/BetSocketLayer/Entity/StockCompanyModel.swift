
import Foundation

public final class StockCompany: Codable {
    var type: String
    public var data: [StockCompanyData]
}

public struct StockCompanyData: Codable {
    public var symbol: String
    public var lastPrice: Double
    public var timestamp: Double
    public var volume: Double
    
    private enum CodingKeys : String, CodingKey {
        case lastPrice = "p", symbol = "s", timestamp = "t", volume = "v"
    }
}
