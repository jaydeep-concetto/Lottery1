//
//  HomeVC.swift
//  Lotery
//
//  Created by Kavi Patel on 11/01/19.
//  Copyright © 2019 Kavi Patel. All rights reserved.
//

import UIKit
import MarqueeLabel

class cellHomeBottomHeader: UITableViewCell {
}

class cellHomeBottomList: UITableViewCell {
    @IBOutlet weak var imgMainView: UIImageView!
    @IBOutlet var lblClubWon: UILabel!
    @IBOutlet var lblJoined: UILabel!
    @IBOutlet var lblDeadLine: UILabel!
    @IBOutlet var imgShape: UIImageView!
}

class cellHomeUpperCollection: UICollectionViewCell {
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgTag: UIImageView!
}

class cellHomeStaticOptionList: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class HomeVC: BaseViewController,FilterVCDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate {
    
    var strAnnounce : String = ""
    var selectedShare : String = ""
    var selectedSort : String = "DES"
    var selectedPosted : String = "AL"
    var arrSelectedTypesOfLottery : String = ""
    var arrSearchImages: [UIImage]! = [UIImage]()
    var arrHeaderImages:[[String:Any]] = [[String:Any]]()
    var arrClubList:[[String:Any]] = [[String:Any]]()
    var arrLang:[[String:Any]] = [["name":"English"],["name":"한국어"]]
    @IBOutlet weak var txtLang: UITextField!
    @IBOutlet weak var lblMarquee: MarqueeLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewStaticOptions: UICollectionView!
    @IBOutlet weak var viewBaseForTable: UIView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtLang.text = getLanguage() == "en" ? "English" : "한국어"
        txtLang.loadDropdownDataFromDictionaryArray(data: arrLang , keyForValue: "name", toolbarColor: UIColor.init(hex: "FD5D0F")) { (a) in
            if a.count != 0
            {
                self.setLanguage(s: (a["name"] as! String == "English") ? "en" : "ko")
                self.setScreen()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setToPeru3(notification:)), name: Notification.Name("peru3"), object: nil)
        arrSearchImages.append(#imageLiteral(resourceName: "search"))
        // arrSearchImages.append(#imageLiteral(resourceName: "ic_usa_flag"))
        arrSearchImages.append(#imageLiteral(resourceName: "add_user"))
        self.collectionViewStaticOptions.reloadData()
        //        arrSearchImages.append(#imageLiteral(resourceName: "tv"))
        //        arrSearchImages.append(#imageLiteral(resourceName: "sport_bg_orange"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false
        setScreen()
//        uploadmultipleimageapi1(url: URL_NAME.add_lottery_ticket) { (dict) in
//
//            if dict.count != 0
//            {
//                let alertWarning = UIAlertController(title: Constant_String.APP_NAME, message: (dict["message"] as! String), preferredStyle: .alert)
//
//                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (a) in
//                    let b = self.tabBarController?.viewControllers![0] as! UINavigationController
//                    b.popToRootViewController(animated: false)
//                    self.tabBarController?.selectedIndex = 0
//                })
//                alertWarning.addAction(defaultAction)
//                self.present(alertWarning, animated: true, completion: nil)
//            }
//        }
    }
    
    func setData(selectedShare1: String, selectedSort1: String, selectedPosted1: String, arrSelectedTypesOfLottery1: String) {
        selectedShare = selectedShare1
        selectedSort = selectedSort1
        selectedPosted = selectedPosted1
        arrSelectedTypesOfLottery = arrSelectedTypesOfLottery1
    }
    
    func setScreen() {
        setString(tag: 5, str: "List Your Lottery")
        self.tabBarController?.tabBar.items?[0].title = "Feed".lang
        self.tabBarController?.tabBar.items?[1].title = "Mail box".lang
        self.tabBarController?.tabBar.items?[2].title = "Scan".lang
        self.tabBarController?.tabBar.items?[3].title = "Result".lang
        getAnnounce()
        getClubList()
    }
    
    func getNo(s:String) -> String
    {
        switch s {
        case "1":
            return "1st"
        case "2":
            return "2nd"
        case "3":
            return "3rd"
        default:
            return "\(s)th"
        }
    }
    
    func getAnnounce()
    {
        backgroundpostapi(url: URL_NAME.announcement, maindict:[:]) { (dict) in
            if dict.count != 0
            {
                let arrud = dict["data"] as? [[String:Any]] ?? []
                var ts:String = " Congratulations!".lang
                let ts1:String = " have won ".lang
                let ts2:String = " for ".lang
                for i in arrud
                {
                    ts = "\(ts) \(((i["user_detail"] as? [String:Any] ?? [:])["name"] as? String ?? ""))\(ts1)\(self.getNo(s: i["user_rank"] as? String ?? ""))\(ts2)\(((i["lottery_detail"] as? [String:Any] ?? [:])["name"] as? String ?? ""))"
                }
                self.strAnnounce = "\(ts)."
            }
        }
    }
   
    func getClubList() {
        postapi(url: URL_NAME.clubListFilter, maindict:["user_id":users.id,"lottery_id":arrSelectedTypesOfLottery,"share":selectedShare,"posted":selectedPosted,"sortBy":selectedSort]) { (dict) in
            self.getLotteryType()
            if dict.count != 0
            {
                self.arrClubList = (dict["data"] as? [String:Any] ?? [:])["user_clubs"] as? [[String:Any]] ?? []
                for a in (dict["data"] as? [String:Any] ?? [:])["other_clubs"] as? [[String:Any]] ?? []
                {
                    self.arrClubList.append(a)
                }
                self.arrClubList = self.arrClubList.filter({ (a) -> Bool in
                    return !(a["lottery_image"] as? String ?? "").contains("korean_lotto")
                })
                self.tableView.reloadData()
            }
            else
            {
                self.arrClubList.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    func getLotteryType() {
        getapi(url: URL_NAME.lottery_company_list) { (dict) in
            let arrLang = ["KINDS","SHARE %","MEMBERS","DEADLINE"]
            for i in 0..<arrLang.count
            {
                self.setString(tag: i+1, str: arrLang[i])
            }
            self.lblMarquee.text = self.strAnnounce
            //  self.lblMarquee.speed = .rate(7)
            if dict.count != 0
            {
                self.arrHeaderImages = dict["data"] as? [[String:Any]] ?? []
                self.arrHeaderImages = self.arrHeaderImages.filter({ (a) -> Bool in
                    return a["country"] as? String ?? "" != "Korea"
                })
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func setToPeru3(notification: NSNotification) {
        self.tabBarController?.tabBar.items![2].image = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 253/255.0, green: 93/255.0, blue: 15/255.0, alpha: 1)], for: .normal)
        self.tabBarController?.tabBar.items![4].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.init(red: 199/255.0
            , green: 199/255.0, blue: 205/255.0, alpha: 1)], for: .normal)
        self.tabBarController?.tabBar.tintColor = UIColor.init(red: 199/255.0
            , green: 199/255.0, blue: 205/255.0, alpha: 1)
        //  self.tabBar.tintColor = UIColor.init(red: 253/255.0, green: 93/255.0, blue: 15/255.0, alpha: 1)
        let objPopup = self.storyboard?.instantiateViewController(withIdentifier: "LotteryNC") as! LotteryNC
        //  objPopup.modalTransitionStyle = .crossDissolve
        objPopup.modalPresentationStyle = .overFullScreen
        let tableVC = objPopup.viewControllers.first as! LotteryPreview1VC
        tableVC.arrLotteryType = arrHeaderImages
        (tabBarController?.viewControllers![(tabBarController?.selectedIndex)!] as! UINavigationController).present(objPopup, animated: true, completion: nil)
    }
 
  
    @IBAction func btnListLotterypress(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("peru3"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewStaticOptions{
            return arrSearchImages.count
        }
        return arrHeaderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHomeUpperCollection", for: indexPath) as! cellHomeUpperCollection
            cell.imgTag.kf.indicatorType = .activity
            cell.imgTag.kf.setImage(with:  URL(string: arrHeaderImages[indexPath.row]["image"] as? String ?? ""))
            cell.lblPrice.text = "$\(arrHeaderImages[indexPath.row]["amount"] as? String ?? "")"
            cell.lblDate.text = convertDateMMMd(str:arrHeaderImages[indexPath.row]["result_date"] as? String ?? "")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHomeStaticOptionList", for: indexPath) as! cellHomeStaticOptionList
        cell.imageView.image = arrSearchImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView{
            return CGSize.init(width:( collectionView.bounds.width / 3), height: collectionView.bounds.height)
        }
        return CGSize.init(width:( collectionView.bounds.height-5), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
        }
        else{
            if indexPath.item == 1{
                let objPopup = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendVC") as! AddFriendVC
                objPopup.modalTransitionStyle = .crossDissolve
                objPopup.modalPresentationStyle = .overFullScreen
                self.present(objPopup, animated: true, completion: nil)
            }
                //            else if indexPath.item == 3{
                //                let shareSportVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareSportVC") as! ShareSportVC
                //                self.navigationController?.show(shareSportVC, sender: nil)
                //
                //            }
            else if indexPath.item == 0{
                let objPopup = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
                objPopup.arrTypesOfLottery = arrHeaderImages
                objPopup.selectedShare = selectedShare
                objPopup.selectedSort = selectedSort
                objPopup.selectedPosted = selectedPosted
                objPopup.arrSelectedTypesOfLottery = arrSelectedTypesOfLottery
                objPopup.delegate = self
                self.present(objPopup, animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrClubList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        SecondVC.clubId = arrClubList[indexPath.row]["id"] as? String ?? ""
        SecondVC.arrClubList = arrClubList
        SecondVC.arrKind = arrHeaderImages
        self.navigationController?.pushViewController(SecondVC, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHomeBottomList", for: indexPath) as! cellHomeBottomList
        cell.imgMainView.kf.indicatorType = .activity
        cell.imgMainView.kf.setImage(with:  URL(string: arrClubList[indexPath.row]["lottery_image"] as? String ?? ""))
        cell.lblClubWon.text = "\(Int(Float(arrClubList[indexPath.row]["share%"] as? String ?? "0")!))%"
        cell.lblJoined.text = "\((arrClubList[indexPath.row]["total_members"] as? String ?? ""))/\((arrClubList[indexPath.row]["join_limit"] as? String ?? ""))"
        cell.lblDeadLine.text = convertDatehhMMss(str:arrClubList[indexPath.row]["lottery_result_date"] as? String ?? "")
        if Int(convertDatehh(str:arrClubList[indexPath.row]["lottery_result_date"] as? String ?? ""))! < 1{
            cell.lblDeadLine.textColor = UIColor.init(hex: "ff0000", alpha: 1)
            cell.imgShape.isHidden = true
            cell.contentView.backgroundColor =   UIColor.init(hex: "ffffff", alpha: 1)
        }
        else if Int(convertDatehh(str:arrClubList[indexPath.row]["lottery_result_date"] as? String ?? ""))! < 24{
            cell.lblDeadLine.textColor = UIColor.init(hex: "003399", alpha: 1)
            cell.imgShape.isHidden = true
            cell.contentView.backgroundColor =   UIColor.init(hex: "ffffff", alpha: 1)
        }
        else
        {
            cell.imgShape.isHidden = true
            cell.contentView.backgroundColor =   UIColor.init(hex: "ffffff", alpha: 1)
            cell.lblDeadLine.textColor = UIColor.init(hex: "000000", alpha: 1)
        }
        //  cell.imgShape.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "cellHomeBottomHeader") as! cellHomeBottomHeader
        return cellHeader.contentView
    }
    
}
