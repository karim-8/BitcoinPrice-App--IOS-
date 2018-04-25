import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
   
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    var finalURL = ""
    
    var currencySelected = ""

    let currencyDataModel = CurrencyDataModel()
    
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    //determine how many columns 3amoood in our picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //set the nummbers as it comes from the site
        return 1
    }
    
    //determine how many Rows  in our picker
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //3ala 7asab elli medholk f el array 7otto
        
        return currencyDataModel.currencyArray.count
    }
    // fill the picker row titles with the Strings from our currencyArray
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //70t el title 3ala 7asab tartebhoom f el array
        return currencyDataModel.currencyArray[row]
    }
    
    //what to do when the user select a particular row
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //var setting symbols upon rows
        
        currencySelected = currencyDataModel.currencySigns[row]
        
        //site structure url+coin  so sending to make converstion
        
        finalURL = baseURL + currencyDataModel.currencyArray[row]

        //called network method to give the url
        
        getCurrencyData(url: finalURL)
    }
    

    
    //MARK: - Networking
    /***************************************************************/
    
    func getCurrencyData(url: String) {
    
        Alamofire.request(url, method: .get).responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the currency data")
                    let currencyJSON : JSON = JSON(response.result.value!)

                   self.updateCurrencyData(json: currencyJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }

    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateCurrencyData(json : JSON) {
        
        if let currencyResult = json["ask"].double {
            print(currencyResult)
          
            bitcoinPriceLabel.text = String(currencyResult) + "\(currencySelected)"
            
            print(currencyResult)

    }
    else {
    bitcoinPriceLabel.text = "Data Unavaliable"
    }
   }
}

