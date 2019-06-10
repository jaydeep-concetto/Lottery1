//
//  LotteryPreview1VC.swift
//  Lottery
//
//  Created by Vachhani Jaydeep on 13/02/19.
//  Copyright © 2019 Vachhani Jaydeep. All rights reserved.
//

import UIKit

class CalculatorVC: BaseViewController {
    @IBOutlet weak var lblMyInitialPrizeVale: UILabel!
    @IBOutlet weak var lblMyLumpSumReduction: UILabel!
    @IBOutlet weak var lblMyFederalTax: UILabel!
    @IBOutlet weak var lblMyStateTax: UILabel!
    @IBOutlet weak var lblMyCashValue: UILabel!
    @IBOutlet weak var lblMyWinningClub: UILabel!
    @IBOutlet weak var lblMyLSSLFee: UILabel!
    @IBOutlet weak var lblMyFinalCashValue: UILabel!
    @IBOutlet weak var lblMyLumpSumReductionPer: UILabel!
    @IBOutlet weak var lblMyFederalTaxPer: UILabel!
    @IBOutlet weak var lblMyStateTaxPer: UILabel!
    @IBOutlet weak var lblMyWinningClubPer: UILabel!
    @IBOutlet weak var lblMyLSSLFeePer: UILabel!
    
    @IBOutlet weak var lblMyClubInitialPrizeVale: UILabel!
    @IBOutlet weak var lblMyClubPerMember: UILabel!
    @IBOutlet weak var lblMyClubCashValue: UILabel!
    @IBOutlet weak var lblMyClubLSSLFee: UILabel!
    @IBOutlet weak var lblMyClubFinalCashValue: UILabel!
    @IBOutlet weak var lblMyClubPerMemberPer: UILabel!
    @IBOutlet weak var lblMyClubLSSLFeePer: UILabel!
    
    @IBOutlet weak var lblOMyInitialPrizeVale: UILabel!
    @IBOutlet weak var lblOMyShare: UILabel!
    @IBOutlet weak var lblOMyFinalCashValue: UILabel!
    @IBOutlet weak var lblOMySharePer: UILabel!

    @IBOutlet weak var lblOMyClubInitialPrizeVale: UILabel!
    @IBOutlet weak var lblOMyClubShare: UILabel!
    @IBOutlet weak var lblOMyClubFinalCashValue: UILabel!
    @IBOutlet weak var lblOMyClubSharePer: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtKind: UITextField!
    @IBOutlet weak var txtTicketPurchased: UITextField!
    @IBOutlet weak var txtShare: UITextField!
    @IBOutlet weak var txtNumberOfPeople: UITextField!
    var arrKind:[[String:Any]] = [[String:Any]]()
    var arrTicketPurchased:[[String:Any]] = [[String:Any]]()
    var arrShare:[[String:Any]] = [["name":"10%","id":"10"],["name":"20%","id":"20"],["name":"30%","id":"30"],["name":"50%","id":"50"],["name":"70%","id":"70"]]
    var arrNumberOfPeople:[[String:Any]] = [[String:Any]]()
    var selectedKind:String = ""
    var selectedTicketPurchased:String = ""
    var selectedShare:String = ""
    var selectedNumberOfPeople:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1..<101
        {
            arrNumberOfPeople.append(["name":"\(i) people","id":"\(i)"])
        }
        txtAmount.text = "0"
        selectedKind = arrKind[0]["id"] as? String ?? ""
        txtKind.text = arrKind[0]["name"] as? String ?? ""

        txtKind.loadDropdownDataFromDictionaryArray(data: arrKind , keyForValue: "name", toolbarColor: UIColor.init(hex: "FD5D0F")) { (a) in
            if a.count != 0
            {
                self.selectedKind = a["id"] as? String ?? ""
                self.getCalculatorAmount()
            }
        }
        selectedShare = arrShare[0]["id"] as? String ?? ""
        txtShare.text = arrShare[0]["name"] as? String ?? ""

        txtShare.loadDropdownDataFromDictionaryArray(data: arrShare , keyForValue: "name", toolbarColor: UIColor.init(hex: "FD5D0F")) { (a) in
            if a.count != 0
            {
                self.selectedShare = a["id"] as? String ?? ""
                self.getCalculatorAmount()
            }
        }
        selectedNumberOfPeople = arrNumberOfPeople[0]["id"] as? String ?? ""
        txtNumberOfPeople.text = arrNumberOfPeople[0]["name"] as? String ?? ""

        txtNumberOfPeople.loadDropdownDataFromDictionaryArray(data: arrNumberOfPeople , keyForValue: "name", toolbarColor: UIColor.init(hex: "FD5D0F")) { (a) in
            if a.count != 0
            {
                self.selectedNumberOfPeople = a["id"] as? String ?? ""
                self.getCalculatorAmount()
            }
        }
        getTicketPurchased()
        // Do any additional setup after loading the view.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtAmount
        {
            self.getCalculatorAmount()
        }
    }
    func getTicketPurchased(){
        getapi(url: URL_NAME.state_tax) { (dict) in
            if dict.count != 0
            {
                let t = dict["data"] as? [String:Any] ?? [:]
                _ = t.map({ (k,v) in
                    self.arrTicketPurchased.append(["name":k,"tax":v])
                })
                self.arrTicketPurchased.sort{
                    ($0["name"] as! String) < ($1["name"] as! String)
                }
                self.selectedTicketPurchased = self.arrTicketPurchased[0]["tax"] as? String ?? ""
                self.txtTicketPurchased.text = self.arrTicketPurchased[0]["name"] as? String ?? ""

                self.txtTicketPurchased.loadDropdownDataFromDictionaryArray(data: self.arrTicketPurchased , keyForValue: "name", toolbarColor: UIColor.init(hex: "FD5D0F")) { (a) in
                    if a.count != 0
                    {
                        self.selectedTicketPurchased = a["tax"] as? String ?? ""
                        self.getCalculatorAmount()
                    }
                }
                self.getCalculatorAmount()
            }
        }
    }
    func getCalculatorAmount(){
        postapi(url: URL_NAME.calculator, maindict:["lottery_id":selectedKind,"state_tax":selectedTicketPurchased,"share":selectedShare,"members":selectedNumberOfPeople,"amount":txtAmount.text!]) { (dict) in
            if dict.count != 0
            {
               
                self.setData(dict: dict["data"] as? [String:Any] ?? [:])
            }
        }
    }
    func setData(dict:[String:Any])
    {
        let l1 = self.view.viewWithTag(10) as! UILabel
        l1.text = "1 / \(selectedNumberOfPeople) People"
        lblMyInitialPrizeVale.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["initial_prize"] as? String ?? "0")
        lblMyLumpSumReduction.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["lumb_sum_reduction"] as? String ?? "0")
        lblMyFederalTax.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["federal_tax"] as? String ?? "0")
        lblMyStateTax.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["state_tax"] as? String ?? "0")
        lblMyCashValue.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["cash_value"] as? String ?? "0")
        lblMyWinningClub.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["winning_club"] as? String ?? "0")
        lblMyLSSLFee.text = setLbl1(s:(dict["when_user_won"] as? [String:Any] ?? [:])["lssl_fee"] as? String ?? "0")
        lblMyFinalCashValue.text = setLbl1(s: (dict["when_user_won"] as? [String:Any] ?? [:])["final_cash_value"] as? String ?? "0")
        lblMyLumpSumReductionPer.text = setLbl(s: (dict["when_user_won"] as? [String:Any] ?? [:])["lumb_sum_reduction_percentage"] as? String ?? "0")
        lblMyFederalTaxPer.text = setLbl(s: (dict["when_user_won"] as? [String:Any] ?? [:])["federal_tax_percentage"] as? String ?? "0")
        lblMyStateTaxPer.text = setLbl(s: (dict["when_user_won"] as? [String:Any] ?? [:])["state_tax_percentage"] as? String ?? "0")
        lblMyWinningClubPer.text = setLbl(s: (dict["when_user_won"] as? [String:Any] ?? [:])["share%"] as? String ?? "0")
        lblMyLSSLFeePer.text = setLbl(s: (dict["when_user_won"] as? [String:Any] ?? [:])["lssl_fee_percentage"] as? String ?? "0")

        lblMyClubInitialPrizeVale.text = setLbl1(s: (dict["when_club_won"] as? [String:Any] ?? [:])["initial_prize"] as? String ?? "0")
        lblMyClubPerMember.text = setLbl1(s: (dict["when_club_won"] as? [String:Any] ?? [:])["per_member_amount"] as? String ?? "0")
        lblMyClubCashValue.text = setLbl2(f: (dict["when_club_won"] as? [String:Any] ?? [:])["initial_prize"] as? String ?? "0", s: (dict["when_club_won"] as? [String:Any] ?? [:])["per_member_amount"] as? String ?? "0")
        lblMyClubLSSLFee.text = setLbl1(s: (dict["when_club_won"] as? [String:Any] ?? [:])["lssl_fee"] as? String ?? "0")
        lblMyClubFinalCashValue.text = setLbl1(s: (dict["when_club_won"] as? [String:Any] ?? [:])["final_cash_value"] as? String ?? "0")
        lblMyClubPerMemberPer.text = setLbl(s:"\(100-(100/Int(selectedNumberOfPeople)!))")
        lblMyClubLSSLFeePer.text = setLbl(s: (dict["when_club_won"] as? [String:Any] ?? [:])["lssl_fee_percentage"] as? String ?? "0")

        lblOMyInitialPrizeVale.text = setLbl1(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_user_won"] as? [String:Any] ?? [:])["initial_prize"] as? String ?? "0")
        lblOMyShare.text = setLbl1(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_user_won"] as? [String:Any] ?? [:])["share"] as? String ?? "0")
        lblOMyFinalCashValue.text = setLbl1(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_user_won"] as? [String:Any] ?? [:])["final_cash_value"] as? String ?? "0")
        lblOMySharePer.text = setLbl(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_user_won"] as? [String:Any] ?? [:])["overseas_percentage"] as? String ?? "0")

        lblOMyClubInitialPrizeVale.text = setLbl1(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_club_won"] as? [String:Any] ?? [:])["initial_prize"] as? String ?? "0")
        lblOMyClubShare.text = setLbl1(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_club_won"] as? [String:Any] ?? [:])["share"] as? String ?? "0")
        lblOMyClubFinalCashValue.text = setLbl1(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_club_won"] as? [String:Any] ?? [:])["final_cash_value"] as? String ?? "0")
        lblOMyClubSharePer.text = setLbl(s: ((dict["overseas_user_join"] as? [String:Any] ?? [:])["when_club_won"] as? [String:Any] ?? [:])["overseas_percentage"] as? String ?? "0")
    }
    func setLbl(s:String) -> String {
        var s1 = s.replacingOccurrences(of: ",", with: "")
        s1 = String(format: "%.2f", Float(s1)!)
        let s2 = s1.split(separator: ".")
        let largeNumber:Int = Int(s2[0])!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "(    \(numberFormatter.string(from: NSNumber(value:largeNumber))!).\(s2[1])%)"
    }
    func setLbl1(s:String) -> String {
        var s1 = s.replacingOccurrences(of: ",", with: "")
        s1 = String(format: "%.2f", Float(s1)!)
        let s2 = s1.split(separator: ".")
        let largeNumber:Int = Int(s2[0])!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "\(numberFormatter.string(from: NSNumber(value:largeNumber))!).\(s2[1])"
    }
    func setLbl2(f:String,s:String) -> String {
        let f1 = f.replacingOccurrences(of: ",", with: "")
        var s1 = s.replacingOccurrences(of: ",", with: "")
        s1 = String(format: "%.2f", Float(f1)! - Float(s1)!)
        let s2 = s1.split(separator: ".")
        let largeNumber:Int = Int(s2[0])!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "\(numberFormatter.string(from: NSNumber(value:largeNumber))!).\(s2[1])"
    }
}
