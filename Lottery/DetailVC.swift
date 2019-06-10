//
//  LotteryPreview1VC.swift
//  Lottery
//
//  Created by Vachhani Jaydeep on 13/02/19.
//  Copyright © 2019 Vachhani Jaydeep. All rights reserved.
//

import UIKit
class myClubNumberCell:UITableViewCell
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var conSVWidth: NSLayoutConstraint!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnSign: UIButton!
}
class DetailVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,ModalViewControllerDelegate {
    func sendData(clubid: String) {
        clubId = clubid
        viewWillAppear(true)
    }
    var arrKind:[[String:Any]] = [[String:Any]]()
    @IBOutlet weak var conTblMyNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var conTblMyClubNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMyNumber: UITableView!
    @IBOutlet weak var tblMyClubNumber: UITableView!
    @IBOutlet weak var lblMakedBy: UILabel!
    @IBOutlet weak var lblClubNumber: UILabel!
    @IBOutlet weak var svFollowNumber: UIStackView!
    @IBOutlet weak var svUnfollowNumber: UIStackView!
    @IBOutlet weak var lblNumberOfMember: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblPriceWhenIWon: UILabel!
    @IBOutlet weak var lblProbabilityWhenIWon: UILabel!
    @IBOutlet weak var viewMyNumberShare: UIView!
    
    @IBOutlet weak var lblPriceWhenClubWon: UILabel!
    @IBOutlet weak var lblProbabilityWhenClubWon: UILabel!
    @IBOutlet weak var imgClub: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubAmount: UILabel!
    var clubId:String = ""
    var dictClubDetail:[String:Any] = [String:Any]()
    var arrMyNumber:[[String:Any]] = [[String:Any]]()
    var arrMyClubNumber:[[String:Any]] = [[String:Any]]()
    var arrClubList:[[String:Any]] = [[String:Any]]()
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden=true
        conTblMyNumberHeight.constant = 1*61
        conTblMyClubNumberHeight.constant = 0*61
        getClubDetail()

    }
    func getClubDetail()
    {
        postapi(url: URL_NAME.club_detail, maindict:["user_id":users.id,"club_id":clubId]) { (dict) in
            
            if dict.count != 0
            {
                self.dictClubDetail = dict["data"] as? [String:Any] ?? [:]
                self.setData()
                
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        

        let l3 = noDataView1(str: Constant_String.None,fr: (svFollowNumber.superview?.frame)!)
        l3.tag = 10001
        svFollowNumber.superview?.addSubview(l3)
        let l4 = noDataView1(str: Constant_String.None,fr: (svUnfollowNumber.superview?.frame)!)
        l4.tag = 10001
        svUnfollowNumber.superview?.addSubview(l4)
        setData()
    }
    func setData() {
        self.arrMyNumber = (self.dictClubDetail["user_list"] as? [[String:Any]] ?? []).filter({ (a) -> Bool in
            return (a["id"] as? String ?? "") == users.id
        })
        self.arrMyClubNumber = (self.dictClubDetail["user_list"] as? [[String:Any]] ?? []).filter({ (a) -> Bool in
            return (a["id"] as? String ?? "") != users.id
        })
        viewMyNumberShare.isHidden = self.arrMyNumber.count != 0
        self.conTblMyClubNumberHeight.constant = CGFloat((self.arrMyClubNumber).count * 61)
        self.conTblMyClubNumberHeight.constant = (self.conTblMyClubNumberHeight.constant == 0) ? 61 : self.conTblMyClubNumberHeight.constant
        self.tblMyClubNumber.reloadData()
        self.tblMyNumber.reloadData()
        lblMakedBy.text = "Maked by \(((self.dictClubDetail["club_creator"] as? [String:Any] ?? [:])["name"] as? String ?? ""))"
        lblClubNumber.text = "Club number : \((self.dictClubDetail["club_number"] as? String ?? ""))"
        lblDate.text = convertDatehhMMss(str: self.dictClubDetail["lottery_result_date"] as? String ?? "")
        lblAmount.text = "$\((self.dictClubDetail["lottery_amount"] as? String ?? ""))"
        imgClub.kf.indicatorType = .activity
        imgClub.kf.setImage(with:  URL(string: self.dictClubDetail["lottery_image"] as? String ?? ""))
         SVSetValues(SV: svFollowNumber, number: self.dictClubDetail["follow_number"] as? String ?? "", removeSpace: 30)
        SVSetValues(SV: svUnfollowNumber, number: self.dictClubDetail["unfollow_number"] as? String ?? "", removeSpace: 30)
        svFollowNumber.superview?.viewWithTag(10001)?.isHidden = (self.dictClubDetail["follow_number"] as? String ?? "") == "" ? false : true
        svUnfollowNumber.superview?.viewWithTag(10001)?.isHidden = (self.dictClubDetail["unfollow_number"] as? String ?? "") == "" ? false : true
        lblNumberOfMember.text = "\(self.dictClubDetail["total_members"] as? String ?? "") / \(self.dictClubDetail["limit_members"] as? String ?? "")"
        lblShare.text = "\((self.dictClubDetail["share%"] as? String ?? ""))%"
        lblPriceWhenIWon.text = "$\((self.dictClubDetail["user_amount"] as? String ?? ""))"
        lblPriceWhenClubWon.text = "$\((self.dictClubDetail["club_amount"] as? String ?? ""))"
        lblProbabilityWhenIWon.text = "1:\((self.dictClubDetail["total_users"] as? String ?? ""))"
        lblProbabilityWhenClubWon.text = "1:\((self.dictClubDetail["total_active_club"] as? String ?? ""))"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblMyNumber
        {
            return arrMyNumber.count
        }
        return arrMyClubNumber.count
    }
    
    @IBAction func btnSignClicked(_ sender: UIButton) {
        //        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "SignatureMainVC") as! SignatureMainVC
        //
        //        self.navigationController?.pushViewController(SecondVC, animated: true)
    }
    @IBAction func btnChangeClubClicked(_ sender: UIButton) {
        
        let arrClubList1 = arrClubList.filter({ (a) -> Bool in
            return a["club_number"] as? String ?? "" != self.dictClubDetail["club_number"] as? String ?? ""
        })
        let objPopup = self.storyboard?.instantiateViewController(withIdentifier: "ChangeClubVC") as! ChangeClubVC
        objPopup.strFromClub = self.lblClubNumber.text ?? ""
        objPopup.delegate = self
        objPopup.arrClubList = arrClubList1
        objPopup.modalTransitionStyle = .crossDissolve
        objPopup.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(objPopup, animated: true, completion: nil)
        
    }
    @IBAction func btnCalculatorClicked(_ sender: UIButton) {
        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "CalculatorVC") as! CalculatorVC
        
       SecondVC.arrKind = arrKind
        self.navigationController?.pushViewController(SecondVC, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tblMyClubNumber
        {
            tableView.backgroundView  = (arrMyClubNumber.count == 0) ? noDataView(str: Constant_String.None,tableView: tableView) : nil
            return (arrMyClubNumber.count == 0) ? 0 : 1
        }
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:myClubNumberCell = tableView.dequeueReusableCell(withIdentifier: "myClubNumberCell", for: indexPath) as! myClubNumberCell
        var tempDict:[String:Any] = [:]
        if tableView == tblMyClubNumber
        {
            tempDict = arrMyClubNumber[indexPath.row]
            
        }
        else
        {
            tempDict = arrMyNumber[indexPath.row]
        }
        SVSetValues(SV: cell.stackView, number: tempDict["lottery_number"] as? String ?? "", removeSpace: 125)
        
        cell.btnSign.isSelected = (tempDict["signature"] as? String ?? "") == ""
        cell.btnUser.isSelected = (tempDict["overseas"] as? String ?? "") != "1"
        return cell
    }
    
    
}
