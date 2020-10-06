//
//  ViewModel.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

final class FeedCellViewModel {
    private let model: CommentModel = .init()
    
    // input
    
    let commentButtonTaped = PublishRelay<Void>()
    let hideTableViewButtonTaped = PublishRelay<Void>()
    let hideFlowCommentButtonTaped = PublishRelay<Void>()
    
    // output
    
    private let fetchedComments = BehaviorRelay<[Comment]>(value: [])
    
    var comments = BehaviorRelay<[Comment]>(value: [])
    var addcomments = BehaviorRelay<Comment>(value: .init(id: "", userId: "", message: "", createdAt: Date(timeIntervalSince1970: 2)))
    
    var hideTableViewBool = BehaviorRelay<Bool>(value: false)
    var hideFlowCommentBool = BehaviorRelay<Bool>(value: false)
    
    private let disposebag = DisposeBag()
    
    
    init() {
        commentButtonTaped.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap{[weak self] ()  -> Observable<[Comment]> in
                guard let self = self else{return .empty()}
                return self.model.getCommentMessage()}
            .do(onNext: { [weak self] comment in self?.getRandomComment()})
            .bind(to: fetchedComments)
            .disposed(by:disposebag)
        
        hideTableViewButtonTaped.subscribe(onNext: {[weak self] _ in
                                            guard let self = self  else { return }
                                            self.hideTableViewBool.accept(!self.hideTableViewBool.value)})
            .disposed(by: disposebag)
        hideFlowCommentButtonTaped.subscribe(onNext: {[weak self] _ in
                                                guard let self = self  else { return }
                                                self.hideFlowCommentBool.accept(!self.hideFlowCommentBool.value)})
            .disposed(by: disposebag)
    }
    func requestApi(){
        model.getCommentMessage().bind(to: fetchedComments).disposed(by: disposebag)
    }
    
    private func getRandomComment(){
        guard  let comment = fetchedComments.value.randomElement() else { return }
        var comments2 = comments.value
        comments2.append(comment)
        addcomments.accept(comment)
        comments.accept(comments2)
    }
}





