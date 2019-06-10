//
//  cellTableView.swift
//  Lotery
//
//  Created by Kavi Patel on 11/01/19.
//  Copyright © 2019 Kavi Patel. All rights reserved.
//

import Foundation
import UIKit



//MARK: cell for HomeBottom list



//MAR: headerCell for HomeBottomList




//MARK: cell for homeView cell

class cellHomeViewPopupList: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!{
        didSet{
            imgView.layer.cornerRadius = imgView.bounds.height/2
            imgView.layer.masksToBounds = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                
                self.imgView.layer.cornerRadius = self.imgView.bounds.height/2
                self.imgView.layer.masksToBounds = true
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGet: UIButton!{
        didSet{
            btnGet.layer.cornerRadius = 6
            btnGet.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var btnGive: UIButton!{
        didSet{
            btnGive.layer.cornerRadius = 6
            btnGive.layer.masksToBounds = true
        }
    }
    
    
}
