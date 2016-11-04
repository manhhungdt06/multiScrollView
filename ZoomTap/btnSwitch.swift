//
//  btnSwitch.swift
//  ZoomTap
//
//  Created by techmaster on 11/4/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class btnSwitch: UIViewController {
    
    @IBAction func onClick(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            pushView(0)
        case 102:
            pushView(1)
        case 103:
            pushView(2)
        default:
            break
        }
    }
    
    func pushView(_ index: Int) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "View2") as! ViewController
        view.currentPage = index
        self.navigationController?.pushViewController(view, animated: true)
    }
}

