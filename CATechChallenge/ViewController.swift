//
//  ViewController.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//

import AVKit
import UIKit
import RxSwift
import RxCocoa

final class FeedCellViewController: UIViewController {
    
    private(set) var channel: Channel?
    private(set) var page: Int?
    private let commentButton: UIButton = .init()
    private let hideTableViewButton: UIButton = .init()
    private let hideFlowCommentButton: UIButton = .init()
    private let tableView: UITableView = .init()
    private let headerView: UIView = .init()
    private let headerCommentLabel: UILabel = .init()
    private let headerPersonLabel: UILabel = .init()
    private let clearView: UIView = .init()
    private var tableViewBool:Bool = true
    private(set) var personCount: Int = 0
    private let randomCommentHeight: [CGFloat] = [10,20,30,40,45,60,70,80,90,110,120,0,150,180,
                                                  190]
    private let randomSpeed: [TimeInterval] = [5,10,15,2]
    
    let viewModel = FeedCellViewModel()
    private let disposeBag: DisposeBag = .init()
    
    @IBOutlet weak var playerContainerView: UIView!
    private let playerViewController: AVPlayerViewController = {
        let playerVC = AVPlayerViewController()
        playerVC.showsPlaybackControls = false
        playerVC.videoGravity = .resizeAspectFill
        playerVC.view.isUserInteractionEnabled = false
        playerVC.view.backgroundColor = .darkGray
        playerVC.view.translatesAutoresizingMaskIntoConstraints = false
        return playerVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CommentCell.self, forCellReuseIdentifier: "Cell")
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.backgroundColor =  UIColor(white: 0.1, alpha: 1)
        setLayout()
        setClearLabel()
        setCommentButton()
        setHedaerView()
        setUpRx()
    }
    private func setUpRx(){
        commentButton.rx.tap
                   .bind(to: viewModel.commentButtonTaped)
                   .disposed(by: disposeBag)
               
        hideTableViewButton.rx.tap
                   .bind(to: viewModel.hideTableViewButtonTaped)
                   .disposed(by: disposeBag)
        
        hideFlowCommentButton.rx.tap
                   .bind(to: viewModel.hideFlowCommentButtonTaped)
                   .disposed(by: disposeBag)
        
        viewModel.comments
                   .bind(to: self.tableView.rx.items(cellIdentifier: "Cell", cellType: CommentCell.self))
                   { (row, element, cell) in
                    let message = element.message
                   cell.addItem(text: message)}
                   .disposed(by: disposeBag)
               
        viewModel.addcomments.subscribe(onNext:{[weak self] comment in
                   guard let self = self else {return}
                   self.postComment(comment: comment.message)
                   self.headerCommentLabel.text = "\(self.viewModel.comments.value.count)"
                   self.personCount += (Int.random(in: 0...1000))
                   self.headerPersonLabel.text = "\(self.personCount)"
                   })
                   .disposed(by: disposeBag)
               
        viewModel.hideTableViewBool.subscribe(onNext: {[weak self] isHidden in
                   guard let self = self else {return}
                   self.tableView.isHidden = isHidden
                if self.tableView.isHidden == true { self.hideTableViewButton.setTitle("コメント表示", for: .normal)
                    self.hideTableViewButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
                }
                else {
                    self.hideTableViewButton.setTitle("コメント非表示", for: .normal)
                    self.hideTableViewButton.backgroundColor = UIColor(white: 0.3, alpha: 1)
                }
                   })
                .disposed(by: disposeBag)
        
        viewModel.hideFlowCommentBool.subscribe(onNext: {[weak self] isHidden in
                guard let self = self else {return}
                self.clearView.isHidden = isHidden
                if  self.clearView.isHidden ==  true {
                    self.hideFlowCommentButton.setTitle("ニコニコ風ON", for: .normal)
                    self.hideFlowCommentButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
                } else {
                    self.hideFlowCommentButton.setTitle("ニコニコ風OFF", for: .normal)
                    self.hideFlowCommentButton.backgroundColor = UIColor(white: 0.3, alpha: 1)
                     
                }})
            .disposed(by: disposeBag)
        }
    
    
    private func setCommentButton(){
        commentButton.backgroundColor = UIColor(white: 0.3, alpha: 1)
        commentButton.setTitle("コメントを入力", for: .normal)
        commentButton.clipsToBounds = true
        commentButton.layer.cornerRadius = 6.0
    }
    private func postComment(comment:String){
        let commentView: commetView = .init()
        commentView.backgroundColor = .clear
        clearView.addSubview(commentView)
        commentView.commentLabel.text = "「\(comment)」"
        commentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentView.heightAnchor.constraint(equalToConstant: 40),
            commentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            commentView.topAnchor.constraint(equalTo: playerContainerView.topAnchor, constant: randomCommentHeight.randomElement() ?? 0)
        ])
        UIView.animate(withDuration: randomSpeed.randomElement() ?? 10, delay: 0.0, options: .curveLinear, animations: {
            commentView.center.x -= 300
        }, completion: {(finished) in commentView.removeFromSuperview()})
        
    }
    
    func play(with player: AVPlayer) {
        guard let channel = channel else {
            assertionFailure("should not reach here")
            return
        }
        
        guard let url = URL(string: channel.url) else {
            assertionFailure("invalid URL")
            return
        }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        playerViewController.player = player
        player.play()
    }
    func stop() {
        playerViewController.player = nil
    }
    private func setClearLabel(){
        clearView.backgroundColor = .clear
        playerContainerView.addSubview(clearView)
        clearView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor),
            clearView.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
            clearView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor)
        ])
    }
}

extension FeedCellViewController {
    static func make(channel: Channel, page: Int) -> Self {
        let viewController = self.init(nibName: String(describing: self), bundle: nil)
        viewController.channel = channel
        viewController.page = page
        return viewController
    }
}

extension FeedCellViewController {
    private func setLayout(){
        self.view.addSubview(commentButton)
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        playerContainerView.addSubview(playerViewController.view)
        
        NSLayoutConstraint.activate([
            playerViewController.view.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
            playerViewController.view.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
            playerViewController.view.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor),
            playerViewController.view.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant:40 )
        ])
        NSLayoutConstraint.activate([
            commentButton.heightAnchor.constraint(equalToConstant: 40),
            commentButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            commentButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            commentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -40),
        ])
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: commentButton.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    private func setHedaerView(){
        let personImageView: UIImageView = .init()
        let commentImageView: UIImageView = .init()
        headerView.addSubview(headerCommentLabel)
        headerView.addSubview(headerPersonLabel)
        headerView.addSubview(personImageView)
        headerView.addSubview(commentImageView)
        headerView.addSubview(hideTableViewButton)
        headerView.addSubview(hideFlowCommentButton)
        headerCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        headerPersonLabel.translatesAutoresizingMaskIntoConstraints = false
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        hideTableViewButton.translatesAutoresizingMaskIntoConstraints = false
        hideFlowCommentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            personImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
            personImageView.widthAnchor.constraint(equalToConstant: 20),
            personImageView.heightAnchor.constraint(equalToConstant: 20),
            personImageView.trailingAnchor.constraint(equalTo: headerPersonLabel.leadingAnchor, constant: -10),
            personImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            personImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            headerPersonLabel.heightAnchor.constraint(equalToConstant: 40),
            headerPersonLabel.widthAnchor.constraint(equalToConstant: 80),
            headerPersonLabel.trailingAnchor.constraint(equalTo: commentImageView.leadingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            commentImageView.trailingAnchor.constraint(equalTo: headerCommentLabel.leadingAnchor, constant: -10),
            commentImageView.widthAnchor.constraint(equalToConstant: 20),
            commentImageView.heightAnchor.constraint(equalToConstant: 20),
            commentImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            commentImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            headerCommentLabel.heightAnchor.constraint(equalToConstant: 40),
            headerCommentLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            hideTableViewButton.heightAnchor.constraint(equalToConstant: 40),
            hideTableViewButton.widthAnchor.constraint(equalToConstant: 100),
            hideTableViewButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            hideTableViewButton.topAnchor.constraint(equalTo: headerView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hideFlowCommentButton.heightAnchor.constraint(equalToConstant: 40),
            hideFlowCommentButton.widthAnchor.constraint(equalToConstant: 100),
            hideFlowCommentButton.trailingAnchor.constraint(equalTo: hideTableViewButton.leadingAnchor),
            hideFlowCommentButton.topAnchor.constraint(equalTo: headerView.topAnchor)
        ])
        personImageView.image = UIImage(named: "人数")
        commentImageView.image = UIImage(named: "コメント")
        headerPersonLabel.textColor = .white
        headerCommentLabel.textColor = .white
        personImageView.contentMode = .scaleAspectFit
        headerPersonLabel.text = "0"
        headerCommentLabel.text = "0"
        headerView.backgroundColor = UIColor(white: 0.3, alpha: 1)
        hideTableViewButton.backgroundColor = UIColor(white: 0.3, alpha: 1)
        hideFlowCommentButton.backgroundColor = UIColor(white: 0.3, alpha: 1)
        hideTableViewButton.setTitle("コメント非表示", for: .normal)
        hideFlowCommentButton.setTitle("ニコニコ風OFF", for: .normal)
        hideFlowCommentButton.titleLabel?.font = .systemFont(ofSize: 10)
        hideTableViewButton.titleLabel?.font = .systemFont(ofSize: 10)
        hideFlowCommentButton.layer.borderColor = UIColor.gray.cgColor
        hideTableViewButton.layer.borderColor = UIColor.gray.cgColor
        hideFlowCommentButton.layer.borderWidth = 1
        hideTableViewButton.layer.borderWidth = 1
    }
    
}

