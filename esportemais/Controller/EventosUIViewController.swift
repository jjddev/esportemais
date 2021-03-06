import UIKit
import Firebase
import SwiftyJSON

class EventosUIViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var evento = Evento()
    var acaoStatus = (error: false, message: "123")
    var alert: UIAlertController!
    var modalidades = [String]()
    var localDescricao = ""
    var localCoord : (lat: Double, lon: Double) = (0, 0)
    
    @IBOutlet weak var btnSalvar: UIButton!
    @IBOutlet weak var vNome: UITextField!
    @IBOutlet weak var vLocal: UITextField!
    @IBOutlet weak var vData: UIDatePicker!
    @IBOutlet weak var vVagas: UITextField!
    @IBOutlet weak var vModalidade: UIPickerView!
    
    @IBOutlet weak var vObservacoes: UITextField!
   
    override func viewWillAppear(_ animated: Bool) {
       //self.navigationItem.title = "Novo Evento"

    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vModalidade.delegate = self
        self.vModalidade.dataSource = self
        
        ModalidadeService.getModalidade(handler: { response in
            self.modalidades = response
            
            let indexModalidade =  self.modalidades.firstIndex(of: self.evento.modalidade)
            
            if indexModalidade != nil {
                self.vModalidade.selectRow(indexModalidade!, inComponent: 0, animated: true)
            }
            
            
            self.vModalidade.reloadAllComponents()
        })
        
        vNome.text = evento.nome
        vObservacoes.text = evento.observacoes
        vLocal.text = localDescricao
        vVagas.text = String(evento.vagas)
        vData.date = evento.data
        
        btnSalvar.layer.cornerRadius = 15
        btnSalvar.clipsToBounds = true
        
    }
    

    
    func salvarEvento() -> Bool {
       
        evento.nome = vNome.text ?? ""
        evento.data = vData.date
        evento.vagas = Int(vVagas.text!) ?? 0
        evento.observacoes = vObservacoes.text ?? ""
        evento.local = vLocal.text ?? ""
        evento.localLat = localCoord.lat
        evento.localLon = localCoord.lon
        
        let modalidadeIndex = vModalidade.selectedRow(inComponent: 0)
        evento.modalidade = modalidades[modalidadeIndex]
        
        acaoStatus = evento.isValid()

        
        return acaoStatus.error
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        
        if salvarEvento() {
            alert = FactoryAlert.infoDialog(title: "Falha", messaage: acaoStatus.message, buttonText: "OK")
        }else{

            let defaults = UserDefaults.standard
            let idUsuario = defaults.string(forKey: "idUsuario") ?? ""
            var eventosInscritos = defaults.stringArray(forKey: "eventos#\(idUsuario)") as? [String] ?? [String]()
            
            
            let e = EventoService.newEvento(evento, idUsuario)
            eventosInscritos.append(e.id)
            EventoService.saveEventosCache(eventosInscritos)
            
            alert = FactoryAlert.infoDialog(title: "Sucesso", messaage: "Evento criado", buttonText: "OK")
            //print(defaults.stringArray(forKey: "eventos") as! [String])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.present(self.alert, animated: true)
        }
        
        performSegue(withIdentifier: "voltarEventos", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "definirLocalizacao" {
            let next = segue.destination as! LocalViewController
            salvarEvento() //apenas seta os valores da tela no objeto evento
            next.evento = evento
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modalidades.count
    }
    
    
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = modalidades[row]
        evento.modalidade = item
        return item
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
