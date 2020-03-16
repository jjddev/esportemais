import Foundation
import UIKit


class FactoryAlert {
    
    
    
    static func infoDialog(title: String, messaage: String, buttonText: String) -> UIAlertController {
        let ab = AlertBuilder(title, messaage)
        let button = UIAlertAction(title: buttonText, style: .default, handler: nil )
        return ab.addButton(button).build()
    }
    
    static func warningDialog(){
        
    }
    
    static func errorDialog(){
        
    }
    
    static func custom(){
        
    }
}
