import Foundation

protocol Modelble {
    func isValid() -> (error: Bool, message: String)
    func toMap() -> [String: Any]
}
