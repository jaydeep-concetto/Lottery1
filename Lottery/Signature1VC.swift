//
//  SignatureVC.swift
//  Lotery
//
//  Created by Bipin Patel on 2/5/19.
//  Copyright © 2019 Kavi Patel. All rights reserved.
//

import UIKit

class Signature1VC: BaseViewController {
    @IBOutlet weak var viewSignatureMain: EPSignatureView!
    @IBOutlet weak var btnaccept: UIButton!
    var delegate: LotteryInstructionVCDelegate! = nil
    @IBOutlet weak var lblTitle: UILabel!
    var strTitle: String = ""
    var firstSign:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
       lblTitle.text = strTitle
      
        // Do any additional setup after loading the view.
    }
  
   
    
    @IBAction func btnClearClick(_ sender: UIButton) {
        viewSignatureMain.clear()
    }
    @IBAction func btnBackClick(_ sender: UIButton) {
       delegate.back()
    }
    @IBAction func btnAcceptClick(_ sender: UIButton) {
        btnaccept.isSelected = !btnaccept.isSelected
    }
    @IBAction func btnCreateSignatureClicked(_ sender: UIButton) {
        if !btnaccept.isSelected {
            showAlertWithTitle(title: Constant_String.APP_NAME, string: "Please accept the terms of disclosure.")
        }
        else if viewSignatureMain.getSignatureAsImage() != nil
        {
            uploadimageapi(url: URL_NAME.uploadSignature, maindict: ["user_id":users.id], imageKey: "signature", imageValue: viewSignatureMain.getSignatureAsImage()!) { (dict) in
                if dict.count != 0
                {
                
                    let alertWarning = UIAlertController(title: Constant_String.APP_NAME, message: (dict["message"] as! String), preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (a) in
                        if UserDefaults.standard.value(forKey: "userInfo") != nil
                        {
                            var tempDict1 = UserDefaults.standard.value(forKey: "userInfo") as! Dictionary<String, Any>
                            var tempDict = tempDict1["user"] as! Dictionary<String, String>
                            
                            tempDict["signature"] = (dict["data"] as! Dictionary<String, String>) ["signature"]
                            tempDict1["user"] = tempDict
                            UserDefaults.standard.set(tempDict1, forKey: "userInfo")
                        }
                        users.signature = (dict["data"] as! Dictionary<String, String>) ["signature"]!
                        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryInstructionVC") as! LotteryInstructionVC
                        SecondVC.delegate = self.delegate
                       SecondVC.fromSign = true
                       SecondVC.firstSign = self.firstSign
                        self.navigationController?.pushViewController(SecondVC, animated: true)
                    })
                    alertWarning.addAction(defaultAction)
                    self.present(alertWarning, animated: true, completion: nil)
                }
            }
        }
    }
   
}
