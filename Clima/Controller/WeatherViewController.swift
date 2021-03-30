//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weathermanager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weathermanager.delegate = self
        searchTextField.delegate = self
    }

    
    @IBAction func findCurrentLocationbtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //fecha o teclado
        print(searchTextField.text!)
    }
    
    //essa funcão veio do UITextFieldDelegate
    //o usuario apertou no botão Enter do teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //fecha o teclado
        print(searchTextField.text!)
        return true
    }
    
    //essa funcao veio do UITextFieldDelegate
    //usuario quer sair do teclado
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }
    
    //essa funcão veio do UITextFieldDelegate
    //quando o teclado se encerra
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weathermanager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate {
    //essa função veio do WeatherManagerDelegate
    //é rodada quando o Manager termina de buscar as informações
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // para evitar que ele fique sempre buscando a localizacao, ele ja buscou e ja está funcionando
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            
            weathermanager.fetchWeather(latitude: lat, longitude: lng)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()
    }
    
}

