//
//  CommentCell.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//

import Foundation
import UIKit

class CommentCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   public  func addItem(text:String){
        self.textLabel?.text = text
    }
    
    func setLayout(){
        self.backgroundColor = UIColor(white: 0.1, alpha: 1)
            self.textLabel?.textColor = .white
        
    }
}


