//
//  ViewController.swift
//  App Aonde estou
//
//  Created by Henrique Silva on 28/10/20.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var velocidadeLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var enderecoLabel: UILabel!
    
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last
        
        let latitude = localizacaoUsuario?.coordinate.latitude
        let longitude = localizacaoUsuario?.coordinate.longitude
        
        self.latitudeLabel.text = String (latitude!)
        self.longitudeLabel.text = String (longitude!)
        
        if localizacaoUsuario!.speed > 0 {
            velocidadeLabel.text = String(localizacaoUsuario!.speed)
        }
        
        let deltaLatidute: CLLocationDegrees = 0.003
        let deltaLongitude: CLLocationDegrees = 0.003
        
        let localizacao = CLLocationCoordinate2D (latitude: latitude!, longitude: longitude!)
        let visualizacaoMapa = MKCoordinateSpan (latitudeDelta: deltaLatidute, longitudeDelta: deltaLongitude)
        let regiao = MKCoordinateRegion (center: localizacao, span: visualizacaoMapa)
        mapa.setRegion( regiao , animated: true)
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario!) { (detalhesLocal, erro) in
            
            if erro == nil {
                
                if let dadosLocal = detalhesLocal?.first {
                
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    
                    var subLocality = ""
                    if dadosLocal.subLocality != nil {
                        subLocality = dadosLocal.subLocality!
                    }
                    
                    var postalCode = ""
                    if dadosLocal.postalCode != nil {
                        postalCode = dadosLocal.postalCode!
                    }
                    
                    var country = ""
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
                    
                    var administrativeArea = ""
                    if dadosLocal.administrativeArea != nil {
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if dadosLocal.subAdministrativeArea != nil {
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    self.enderecoLabel.text = thoroughfare + " - "
                                              + subThoroughfare + " / "
                                              + locality + " / "
                                              + country
                }
            }
        }
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            let alertaController = UIAlertController(title: "Permissão de Localização", message: "Necessário a autorização para o uso da localização", preferredStyle: .alert)
            
            let acaoConfigaracoes = UIAlertAction(title: "Abrir Configurações", style: .default) { (UIAlertAction) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            alertaController.addAction(acaoConfigaracoes)
            alertaController.addAction(acaoCancelar)
    
    }
    }
