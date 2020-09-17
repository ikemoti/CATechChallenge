//
//  CommentModel.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//
import Foundation
import RxSwift

protocol commentProtocol {
    func getCommentMessage() -> Observable<[Comment]>
    
}

final class CommentModel: commentProtocol {
    func getCommentMessage() -> Observable<[Comment]> {
        return Observable.create{observer in
               let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .formatted({
                   let f = DateFormatter()
                   f.calendar = Calendar(identifier: .gregorian)
                   f.locale = .current
                   f.dateFormat = "yyyyMMddHHmmssSS"
                   return f
               }())
               guard
                   let path = Bundle.main.path(forResource: "comments", ofType: "json"),
                   let jsonData = try? self.getJSONData(path: path),
                   let apiComments = try? decoder.decode(Comment.ApiComments.self, from: jsonData)
                   else { return [] as! Disposable}
            observer.onNext(apiComments.comments)
                   observer.onCompleted()
                   return Disposables.create()
           }
    }
    private func getJSONData(path: String) throws -> Data {
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}

