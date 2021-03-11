//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate , WeatherManagerDelegate{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weathermanager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weathermanager.delegate = self
        searchTextField.delegate = self
    }


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

