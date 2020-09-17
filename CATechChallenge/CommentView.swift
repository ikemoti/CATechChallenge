//
//  CommentView.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//

import UIKit
import Foundation

class commetView: UIView {
    let imageView:UIImageView = .init()
    let nameLabel: UILabel = .init()
    let commentLabel: UILabel = .init()
    var names: [String] = ["あっきー","うめ","かわかみ","くどかい","ぐみおじ","こんちゃん","さたけ","しろくま八段","セーたろ","たいよー","つっちー","とも","なで","ぴーひろ","ふじ","まっつ","まる","ゆめ"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLAyout()
        setAttributes()
        guard let randomName = names.randomElement() else {return}
        guard let image = UIImage(named: "\(randomName)") else {return}
        setItem(comment: "「テスト」", name:"＠\(randomName)" ,  image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLAyout(){
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(commentLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor,constant: -10),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: commentLabel.leadingAnchor,constant: -10)
        ])
        NSLayoutConstraint.activate([
            commentLabel.heightAnchor.constraint(equalToConstant: 40),
            commentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    private func setAttributes(){
        let color = UIColor.random
        nameLabel.textColor = color
        commentLabel.textColor = color
    }
    public func setItem(comment: String, name:String, image: UIImage){
        self.imageView.image = image
        self.commentLabel.text = comment
        self.nameLabel.text = name
    }
    
}

