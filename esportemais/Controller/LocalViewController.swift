import UIKit
import MapKit
import CoreLocation

class LocalViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var vMapa: MKMapView!
    var locationManager = CLLocationManager()
    static let geocoder = CLGeocoder()
    var localDescricao: String!
    var localCoord : (lat: Double, lon: Double) = (0, 0)
    var evento: Evento!
    var lat: Double!
    var lon: Double!
    
    @IBOutlet var clicked: UITapGestureRecognizer!
    @IBOutlet weak var vLocal: UILabel!
    @IBOutlet weak var btnConfirmar: UIButton!
    @IBOutlet weak var vGrupoLocal: UIView!
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        var tituloTela = ""
        
        if localDescricao != nil {
            tituloTela = "Localização"
            btnConfirmar.isHidden = true
        } else {
            tituloTela = "Definir localização"
        }
        
        self.navigationItem.title = tituloTela
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vLocal.text = localDescricao
        
        
        if lat == nil {
            localCoord.lat = -25.451739
            localCoord.lon = -49.251087
        } else {
            localCoord.lat = lat
            localCoord.lon = lon
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = localCoord.lat
            annotation.coordinate.longitude = localCoord.lon
            annotation.title = ">>Evento<<<"
            self.vMapa.addAnnotation(annotation)
        }
        
   
        vGrupoLocal.layer.borderWidth = 1
        vGrupoLocal.layer.borderColor = UIColor.blue.cgColor
        
        self.locationManager.requestAlwaysAuthorization()
        
         self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        vMapa.mapType = .standard
        vMapa.isZoomEnabled = true
        vMapa.isScrollEnabled = true

        if let coor = vMapa.userLocation.location?.coordinate{
            vMapa.setCenter(coor, animated: true)
        }
    }
    
    @IBAction func salvarLocal(_ sender: Any) {
        if localDescricao == nil {
            let alert = FactoryAlert.infoDialog(title: "Falha", messaage: "Defina o local do evento", buttonText: "OK")
            self.present(alert, animated: true)
            return
        }
        performSegue(withIdentifier: "definidaLocalizacao", sender: nil)
    }
    
    @IBAction func click(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: vMapa)
       
        let locCoord = self.vMapa.convert(location, toCoordinateFrom: vMapa)
        let annotation = MKPointAnnotation()
        
        let x = CLLocation(latitude: locCoord.latitude, longitude: locCoord.longitude)
        
            LocalViewController.geocoder.reverseGeocodeLocation(x) { (placemarks, _) in
                if let marca = placemarks?.first {
                    //print("nome: \(marca.name), cidade: \(marca.locality) \(marca)")
                    //print(marca)
                    self.localDescricao = "\(marca.name!) - \(marca.locality!)"
                    self.vLocal.text = self.localDescricao
                    self.localCoord.lat = locCoord.latitude
                    self.localCoord.lon = locCoord.longitude
                    
                    print("lat: \(locCoord.latitude) long: \(locCoord.longitude)")
                    
                }
        }
        
        
        self.vMapa.annotations.forEach({
            vMapa.removeAnnotation($0)
        })
        
        self.vMapa.removeAnnotation(annotation)
        
        annotation.coordinate = locCoord
        annotation.title = ">>Evento<<<"
        self.vMapa.addAnnotation(annotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            //let logitude = -49.251087
            //let latitude = -25.451739
            
            let logitude = localCoord.lon
            let latitude = localCoord.lat
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.vMapa.setRegion(region, animated: true)
        }
        
        print(locations.description)
    }
    
    
    func handleLongPress (gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint: CGPoint = gestureRecognizer.location(in: vMapa)
            let newCoordinate: CLLocationCoordinate2D = vMapa.convert(touchPoint, toCoordinateFrom: vMapa)
            addAnnotationOnLocation(pointedCoordinate: newCoordinate)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: vMapa)
        //print("x: \(location.x)| y: \(location.y)")
        //print(location)
    }
    
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pointedCoordinate
        annotation.title = "Loading..."
        annotation.subtitle = "Loading..."
        vMapa.addAnnotation(annotation)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "definidaLocalizacao" {
            let next = segue.destination as! EventosUIViewController
            next.localDescricao = localDescricao
            next.localCoord.lat = self.localCoord.lat
            next.localCoord.lon = self.localCoord.lon
            next.evento = evento
        }
    }
}
