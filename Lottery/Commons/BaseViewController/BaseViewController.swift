//
//  BaseViewController.swift
//  
//
//  Created by TriState on 1/17/17.
//  Copyright © 2017 Tristate Technology. All rights reserved.
//

import UIKit
import AVFoundation
import IQKeyboardManagerSwift
import Alamofire
import MBProgressHUD
import Kingfisher
import Toast
import Localize_Swift
extension String
{
    var lang : String{
        return self.localized()
    }
    
}
class BaseViewController: UIViewController,UITextFieldDelegate {
    //MARK: - Variable Declaration
    func setString(tag:Int,str:String){
        let v = self.view.viewWithTag(tag)
        if v is UILabel
        {
            (v as! UILabel).text = str.localized()
        }
        else if v is UIButton
        {
            (v as! UIButton).setTitle(str.localized(), for: .normal)
        }
    }
    var viewSpinner: UIView = UIView()
    @IBOutlet var spinnerView: UIActivityIndicatorView!
    func getLanguage() -> String
    {
        return Localize.currentLanguage()
    }
    func setLanguage(s:String)
    {
        Localize.setCurrentLanguage(s)
    }
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func SVSetValue(SV:UIStackView) {
        for a in SV.subviews
        {
            a.layer.masksToBounds = true
            
            a.layer.cornerRadius = a.frame.size.width/2
        }
    }
    func SVSetValues(SV:UIStackView,number:String,removeSpace:CGFloat){
        var tempArr = number.components(separatedBy: " ")
        
        if number == ""
        {
            SV.isHidden = true
        }
        else
        {
            SV.isHidden = false
            for i in 0..<SV.subviews.count
            {
                SV.subviews[i].isHidden = false
            }
        for i in 0..<tempArr.count
        {
            if i>5
            {
                tempArr.remove(at: i)
            }
        }
        for i in 0..<SV.subviews.count
        {
            SV.subviews[i].isHidden = false
        }
        let space = self.view.frame.size.width-removeSpace
        let cons = SV.constraints.filter {
            $0.firstAttribute == NSLayoutConstraint.Attribute.width
            }.first
        cons?.constant = space < CGFloat(35 * tempArr.count)-5 ? space : CGFloat(35 * tempArr.count)-5
        for i in 0..<SV.subviews.count-tempArr.count
        {
            SV.subviews[i].isHidden = true
        }
        for i in 0..<tempArr.count
        {
            (SV.subviews[i+SV.subviews.count-tempArr.count].subviews[0] as! UILabel).text = tempArr[i]
        }
        for a in SV.subviews
        {
            a.layer.masksToBounds = true
            let cw = cons!.constant-CGFloat((tempArr.count-1)*5)
            a.layer.cornerRadius = (cw/CGFloat(tempArr.count))/2
        }
        }
    }
    func setSliderLabel1(slider:UISlider,lblView:UIView,lblSlider:UILabel) {
        let _thumbRect: CGRect = slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: slider.value)
        
        let thumbRect: CGRect = lblView.superview!.convert(_thumbRect, from: slider)
        lblView.frame = CGRect(x: thumbRect.origin.x-4, y: thumbRect.origin.y-33, width: lblView.frame.size.width, height: lblView.frame.size.height)
        lblSlider.text = "X\(String(format: "%0.1f", slider.value))"
        
    }
    func setSliderLabel2(slider:UISlider,lblView:UIView,lblSlider:UILabel) {
        let _thumbRect: CGRect = slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: slider.value)
        
        let thumbRect: CGRect = lblView.superview!.convert(_thumbRect, from: slider)
        lblView.frame = CGRect(x: thumbRect.origin.x-4, y: thumbRect.origin.y-33, width: lblView.frame.size.width, height: lblView.frame.size.height)
        lblSlider.text = Int(slider.value) == 0 ? "not set" : "\(Int(slider.value))"
        
    }
    func setSliderLabel(slider:UISlider,lblView:UIView,lblSlider:UILabel) {
        let _thumbRect: CGRect = slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: slider.value)
        
        let thumbRect: CGRect = lblView.superview!.convert(_thumbRect, from: slider)
        lblView.frame = CGRect(x: thumbRect.origin.x-4, y: thumbRect.origin.y-33, width: lblView.frame.size.width, height: lblView.frame.size.height)
        lblSlider.text = "\(Int(slider.value)) %"
        
    }
    func findClosest( values: [CGFloat],  slider: UISlider){
        let givenValue = CGFloat(slider.value)
        let sorted = values.sorted()
        
        let over = sorted.first(where: { $0 >= givenValue })!
        let under = sorted.last(where: { $0 <= givenValue })!
        
        let diffOver = over - givenValue
        let diffUnder = givenValue - under
        
        slider.value = Float((diffOver < diffUnder) ? over : under)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Back Button Action
    @IBAction func backButtonAction(sender: UIButton?) {
        if let navigationViewController = self.navigationController {
            navigationViewController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        //
        
    }
    
    //MARK: - Gradient View Method
    // For UIVIEW
    @objc func setText() {
        
    }
    func setViewRoundCorner(view:UIView)  {
        view.layer.cornerRadius=view.frame.size.width/2
        view.layer.masksToBounds=true
    }
    
    func checkIfExpiredSession(dict:Dictionary<String,Any>) {
        
        
        
    }
    
    //TextField Delegate Method
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Tap Gesture
    func addTapGestureInView(view: UIView) {
        var tap: UITapGestureRecognizer!
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestureAction(){
        
    }
    
    func addTapGestureInAnotherView(view: UIView) {
        var tap: UITapGestureRecognizer!
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureClicked))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestureClicked(){
        
    }
    
    func showAlert(string : String) -> Void {
        let alertWarning = UIAlertController(title: Constant_String.APP_NAME, message: string, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertWarning.addAction(defaultAction)
        Constant_String.appDelegate.window?.rootViewController?.present(alertWarning, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(title : String, string : String) -> Void {
        let alertWarning = UIAlertController(title: title, message: string, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertWarning.addAction(defaultAction)
        self.present(alertWarning, animated: true, completion: nil)
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func getWidthFromText(text:String,font:UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        
        let size = text.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width
    }
    // MARK: - Recability Method
    func isConnectedToNetwork() -> Bool {
        if (currentReachabilityStatus == ReachabilityStatus.reachableViaWiFi){
            return true
        }else if (currentReachabilityStatus == ReachabilityStatus.reachableViaWWAN){
            return true
        }else{
            return false
        }
    }
    
    
    
    //MARK: - Check Key is Exiest or not in UserDefault.
    func isKeyExiestInStorage(_ key:String) ->Bool{
        let userDefault = UserDefaults.standard.dictionaryRepresentation()
        
        if userDefault.keys.contains(key){
            
            if userDefault[key] is String{
                
                if (userDefault[key] as! String == "") {
                    return false
                }else{
                    return true
                }
            }else{
                if (userDefault[key] as! Int == 0){
                    return false
                }else{
                    return true
                }
            }
        }else{
            return false
        }
    }
    
    //if Locale.current.languageCode == "de"{
    func languageCode() ->String{
        if Locale.current.languageCode == "de"{
            return "GE"
        }else{
            return "EN"
        }
    }
    
    
    //MARK: - Validations
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /*  func isValidPassword(_ passwordString: String) -> Bool {
     // let stricterFilterString = "^(?=.*\\p{Alpha})(?=.*\\p{Digit}).{8,}$"
     let stricterFilterString = "^[A-Z0-9a-z._%+-]{5,}$"
     let passwordTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
     let result = passwordTest.evaluate(with: passwordString)
     return result
     }*/
    
    func isValidPassword(_ passwordString: String) -> Bool {
        let stricterFilterString = "^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        let result = passwordTest.evaluate(with: passwordString)
        return result
    }
    
    
    func validatePhone(_ phoneNumber: String?) -> Bool {
        let phoneRegex = "^[0-9]{10}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
        return valid
    }
    
    
    func isValidUserName(_ nameString: String) -> Bool{
        let stricterFilterString = "^[A-Z0-9a-z-._]{1,20}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        let result = nameTest.evaluate(with: nameString)
        return result
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func validateUrl (urlString: String) -> Bool {
        let urlRegEx = "((http|https)://)(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: urlString)
        return result
    }
    
    func trimString(string : String) -> String {
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func noDataView(str:String,tableView:UITableView) -> UILabel {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.font = UIFont.systemFont(ofSize: 13.0)
        noDataLabel.text          = str
        noDataLabel.textColor     = UIColor.lightGray
        noDataLabel.textAlignment = .center
        return noDataLabel
    }
    func noDataView1(str:String,fr:CGRect) -> UILabel {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: fr.size.width, height: fr.size.height))
        noDataLabel.font = UIFont.systemFont(ofSize: 13.0)
        noDataLabel.text          = str
        noDataLabel.textColor     = UIColor.lightGray
        noDataLabel.backgroundColor = UIColor.white
        noDataLabel.textAlignment = .center
        return noDataLabel
    }
    func noDataView2(str:String,fr:CGRect) -> UIView {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 194, width: fr.size.width, height: fr.size.height-194))
        noDataLabel.font = UIFont.systemFont(ofSize: 13.0)
        noDataLabel.text          = str
        noDataLabel.textColor     = UIColor.lightGray
        noDataLabel.backgroundColor = UIColor.white
        noDataLabel.textAlignment = .center
        let noDataLabel1: UIView     = UIView(frame: CGRect(x: 0, y: 0, width: fr.size.width, height: fr.size.height))
        noDataLabel1.addSubview(noDataLabel)
        return noDataLabel1
    }
    func backgroundpostapi(url:String,maindict:Dictionary<String,Any>, withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        let headers = ["lang": getLanguage()]
        let mainurl = "\(Constant_Url.Url)\(url)"
        Alamofire.request(mainurl, method: .post, parameters: maindict, encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                if response.result.value != nil
                {
                    let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                    print(JSON)
                    if response.response?.statusCode ?? 0 == 200 {
                        callback(JSON)
                    }
                    else
                    {
                        callback([:])
                    }
                }
                else
                {
                    callback([:])
                }
        }
    }
    func postapi(url:String,maindict:Dictionary<String,Any>, withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers = ["lang": getLanguage()]
        let mainurl = "\(Constant_Url.Url)\(url)"
        Alamofire.request(mainurl, method: .post, parameters: maindict, encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if response.result.value != nil
                {
                    let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                    print(JSON)
                    if response.response?.statusCode ?? 0 == 200 {
                        callback(JSON)
                    }
                    else if response.response?.statusCode ?? 0 == 400 && JSON["errors"] != nil && ((JSON["errors"] as? [String])?.count != 0){
                        if JSON["errors"] is String
                        {
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! String))
                            callback([:])
                        }
                        else
                        {
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! [String])[0] )
                            callback([:])
                        }
                    }
                    else {
                        
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Server Error")
                        callback([:])
                    }
                }
                else
                {
                    self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Connection Error")
                    callback([:])
                }
        }
        
        
    }
    func putapi(url:String,maindict:Dictionary<String,Any>, withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers = ["lang": getLanguage()]
        let mainurl = "\(Constant_Url.Url)\(url)"
        Alamofire.request(mainurl, method: .put, parameters: maindict, encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if response.result.value != nil
                {
                    let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                    print(JSON)
                    if response.response?.statusCode ?? 0 == 200 {
                        callback(JSON)
                    }
                    else if response.response?.statusCode ?? 0 == 400 && JSON["errors"] != nil && ((JSON["errors"] as? [String])?.count != 0){
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! [String])[0] )
                        callback([:])
                    }
                    else {
                        
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Server Error")
                        callback([:])
                    }
                }
                else
                {
                    self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Connection Error")
                    callback([:])
                }
        }
        
        
    }
    func getapi(url:String, withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers = ["lang": getLanguage()]
        let mainurl = "\(Constant_Url.Url)\(url)"
        Alamofire.request(mainurl, method: .get, parameters: nil, encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if response.result.value != nil
                {
                    let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                    print(JSON)
                    if response.response?.statusCode ?? 0 == 200 {
                        callback(JSON)
                    }
                    else if response.response?.statusCode ?? 0 == 400 && JSON["errors"] != nil && ((JSON["errors"] as? [String])?.count != 0){
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! [String])[0] )
                        callback([:])
                    }
                    else {
                        
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Server Error")
                        callback([:])
                    }
                }
                else
                {
                    self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Connection Error")
                    callback([:])
                }
        }
    }
    func uploadimageapi(url:String,maindict:Dictionary<String,String>,imageKey:String,imageValue:UIImage, withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let headers = ["Content-Type": "multipart/form-data; charset=UTF-8","Accept": "application/json","Keep-Alive":"Connection","lang": getLanguage()]
        
        let URL = try! URLRequest(url: "\(Constant_Url.Url)\(url)", method: .post, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if let tempimage = imageValue.jpegData(compressionQuality: 1){
                multipartFormData.append(tempimage, withName: imageKey, fileName: "pic.jpeg", mimeType: "image/jpeg")
            }
            maindict.map({ (a:String,b:Any) -> Bool in
                multipartFormData.append((b as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: a)
                return true
            })
            
            
        }, with:URL)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON { response in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if response.result.value != nil
                    {
                        let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                        print(JSON)
                        if response.response?.statusCode ?? 0 == 200 {
                            callback(JSON)
                        }
                        else if response.response?.statusCode ?? 0 == 400 && JSON["errors"] != nil && ((JSON["errors"] as? [String])?.count != 0){
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! [String])[0] )
                            callback([:])
                        }
                        else {
                            
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Server Error")
                            callback([:])
                        }
                    }
                    else
                    {
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Connection Error")
                        callback([:])
                    }
                    
                    
                }
                
                
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
                callback([:])
            }}
    }
    func uploadmultipleimageapi1(url:String, withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let headers = ["Content-Type": "multipart/form-data; charset=UTF-8","Accept": "application/json","Keep-Alive":"Connection","lang": getLanguage()]
        
        let URL = try! URLRequest(url: "\(Constant_Url.Url)\(url)", method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData1) in
            var a = "lottery[0]"
            var b =  ["lottery_id": "2",
                      "lottery_sign_image": UIImage(named: "ic_loto.png")!.pngData()!.base64EncodedString(),
                      "lottery_front_image": UIImage(named: "ic_loto.png")!.jpegData(compressionQuality: 1)!.base64EncodedString(),
                      "lottery_back_image": UIImage(named: "ic_loto.png")!.jpegData(compressionQuality: 1)!.base64EncodedString(),
                      "lottery_detail": [
                        [
                            "lottery_number": "12 34 56 56 56 56",
                            "share": "5",
                            "day": "5-7",
                            "club": "join",
                            "join_club": "2",
                            "overseas": "0"
                        ],
                        [
                            "lottery_number": "09 87 65 43 43 43",
                            "share": "10.2",
                            "day": "5-7",
                            "club": "new",
                            "new_club": [
                                "limit": "50",
                                "unfollow": "15 16 17",
                                "follow": "10 11 12"
                            ],
                            "overseas": "1",
                            "overseas_value": "2134"
                        ]
                ]
                ] as [String : Any]
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: b, options: [.prettyPrinted])
                multipartFormData1.append(jsonData, withName: a)
            }
            catch let parseError {
                print("json serialization error: \(parseError)")
                
            }
            a = "lottery[1]"
            b =  ["lottery_id": "2",
                  "lottery_sign_image": UIImage(named: "ic_loto.png")!.jpegData(compressionQuality: 1)!.base64EncodedString(),
                  "lottery_front_image": UIImage(named: "ic_loto.png")!.jpegData(compressionQuality: 1)!.base64EncodedString(),
                  "lottery_back_image": UIImage(named: "ic_loto.png")!.jpegData(compressionQuality: 1)!.base64EncodedString(),
                  "lottery_detail": [
                    [
                        "lottery_number": "12 34 56 56 56 56",
                        "share": "5",
                        "day": "5-7",
                        "club": "join",
                        "join_club": "2",
                        "overseas": "0"
                    ],
                    [
                        "lottery_number": "09 87 65 43 43 43",
                        "share": "10.2",
                        "day": "5-7",
                        "club": "new",
                        "new_club": [
                            "limit": "50",
                            "unfollow": "15 16 17",
                            "follow": "10 11 12"
                        ],
                        "overseas": "1",
                        "overseas_value": "2134"
                    ]
                ]
                ] as [String : Any]
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: b, options: [.prettyPrinted])
                multipartFormData1.append(jsonData, withName: a)
            }
            catch let parseError {
                print("json serialization error: \(parseError)")
                
            }
            multipartFormData1.append("94".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: "user_id")
        }, with:URL)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON { response in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if response.result.value != nil
                    {
                        let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                        print(JSON)
                        if response.response?.statusCode ?? 0 == 200 {
                            callback(JSON)
                        }
                        else if response.response?.statusCode ?? 0 == 400 && JSON["errors"] != nil && ((JSON["errors"] as? [String])?.count != 0){
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! String) )
                            callback([:])
                        }
                        else {
                            
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Server Error")
                            callback([:])
                        }
                    }
                    else
                    {
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Connection Error")
                        callback([:])
                    }
                    
                    
                }
                
                
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
                callback([:])
            }}
    }
    func uploadmultipleimageapi(url:String,maindict:[String:Any], withcalllback callback: @escaping (_ response: Dictionary<String,Any>) -> Void)
    {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let headers = ["Content-Type": "multipart/form-data; charset=UTF-8","Accept": "application/json","Keep-Alive":"Connection","lang": getLanguage()]
        
        let URL = try! URLRequest(url: "\(Constant_Url.Url)\(url)", method: .post, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            _ = maindict.map({ (a:String,b:Any) -> Bool in
                if a.contains("image")
                {
                    if let tempimage = (b as! UIImage).jpegData(compressionQuality: 1){
                        multipartFormData.append(tempimage, withName: a, fileName: "pic\(a).jpeg", mimeType: "image/jpeg")
                    }
                }
                else if b is String
                {
                    multipartFormData.append((b as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: a)
                }
                else{
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: b, options: [.prettyPrinted])
                        multipartFormData.append(jsonData, withName: a)
                    }
                    catch let parseError {
                        print("json serialization error: \(parseError)")
                        
                    }
                }
                return true
            })
            
            
        }, with:URL)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON { response in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if response.result.value != nil
                    {
                        let JSON = (response.result.value as! Dictionary<String,Any>).dictionaryByReplacingNullsWithBlanks()
                        print(JSON)
                        if response.response?.statusCode ?? 0 == 200 {
                            callback(JSON)
                        }
                        else if response.response?.statusCode ?? 0 == 400 && JSON["errors"] != nil && ((JSON["errors"] as? [String])?.count != 0){
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: (JSON["errors"] as! String) )
                            callback([:])
                        }
                        else {
                            
                            self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Server Error")
                            callback([:])
                        }
                    }
                    else
                    {
                        self.showAlertWithTitle(title: Constant_String.APP_NAME, string: "Connection Error")
                        callback([:])
                    }
                    
                    
                }
                
                
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
                callback([:])
            }}
    }
    func convertDateMMMd(str:String) -> String
    {
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let df1:DateFormatter = DateFormatter()
        df1.dateFormat = "MMM d"
        return df1.string(from: df.date(from: str)!)
    }
    func convertDateyyyyMMdd(str:String) -> String
    {
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let df1:DateFormatter = DateFormatter()
        df1.dateFormat = "yyyy-MM-dd"
        return df1.string(from: df.date(from: str)!)
    }
    func convertDatehhMMss(str:String) -> String
    {
        if str == ""
        {
            return ""
        }
        else
        {
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let hourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(hourMinuteSecond, from:Date() , to:df.date(from: str)! );
        
        let seconds = difference.second ?? 0
        let minutes = difference.minute ?? 0
        let hours = difference.hour ?? 0
        
        
        return "\(hours):\(minutes):\(seconds)"
        }
    }
    func convertDatehh(str:String) -> String
    {
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let hourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(hourMinuteSecond, from:df.date(from: str)! , to: Date());
        
        
        let hours = difference.hour ?? 0
        
        
        return "\(hours)"
        
    }
    func formatPoints( s: String) ->String{
        if s == ""
        {
            return "$0M"
        }
        else
        {
            let num:Float = (Float(s.replacingOccurrences(of: ",", with: "")))!
            let millionNum = num/1000000
            
            return String(format: "$%.2fM", millionNum)
            
        }
    }
}
