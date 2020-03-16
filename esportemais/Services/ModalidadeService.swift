import Foundation
import Firebase
import SwiftyJSON

class ModalidadeService {
    private static func getConnection() -> DatabaseReference {
        return  Database.database().reference()
    }
    
    static func getModalidade(handler: @escaping (([String]) -> Void)){
        let ref = getConnection()
        ref.child("Modalidades").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var response = [String]()
            
            for item in value {
                let i = JSON(item.value)
                response.append(i["descricao"].stringValue)
            }
            handler(response)
        })
    }
}
