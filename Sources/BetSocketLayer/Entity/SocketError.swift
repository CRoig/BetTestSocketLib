
import Foundation

public enum SocketError: Error {
    case disconnected
}

extension SocketError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .disconnected:
            return NSLocalizedString("Seems to be disconnected", comment: "Error")
        }
    }
}
