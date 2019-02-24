//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    let currencyArray           =  ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray     =  ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected        =  ""
    var finalURL                =  ""


    
    @IBOutlet weak var bitcoinPriceLabel   :   UILabel!
    @IBOutlet weak var currencyPicker      :   UIPickerView!
    @IBOutlet weak var symbolLabel         :   UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate     =  self
        currencyPicker.dataSource   =  self
       
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = fetchPrice(for: currencyArray[row])
        print(finalURL)
        currencySelected = currencySymbolArray[row]
        getBitcoinData(url: finalURL, code: currencyArray[row])
    }

    
    
    func fetchPrice(for code: String) -> String {
        let baseURL = "https://api.coindesk.com/v1/bpi/currentprice/\(code).json"
        return baseURL
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    
    func getBitcoinData(url: String, code: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            
            response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got the bitcoin")
                    let bitcoinDataJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(json: bitcoinDataJSON, code: code)
                    
                } else {
                    
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }

    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    func updateBitcoinData(json : JSON, code: String) {
        
        print(json)
        if let bitcoinResult = json["bpi"]["\(code)"]["rate"].string {
            
            bitcoinPriceLabel.text   =  bitcoinResult
            symbolLabel.text         =  currencySelected
            
        } else {
            
            bitcoinPriceLabel.text   = "Price Unavaileble"
        }
    }
}
