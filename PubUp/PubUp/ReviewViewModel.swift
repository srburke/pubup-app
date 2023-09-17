//
//  ReviewViewModel.swift
//  PubUp
//
//  Created by Shannon Burke on 5/10/23.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func savePub(business: Business, review: Review) throws {
        let db = Firestore.firestore()
        do {
            let documentData = try Firestore.Encoder().encode(review)
            guard let businessID = business.id else {
                print("Error: business.id = nil")
                return
            }
            let collectionStr = "businesses/\(businessID)/reviews"
            
            guard let id = review.id else {
                let collectionRef = db.collection(collectionStr)
                collectionRef.addDocument(data: documentData)
                return
            }
            let collectionRef = db.collection(collectionStr)
            let documentRef = collectionRef.document(id)
            documentRef.setData(documentData) { error in
                if let error = error {
                    print("error saving business to Firestore \(error.localizedDescription)")
                } else {
                    print("Business saved to Firestore successfully.")
                }
            }
        } catch {
            print("error encoding business data: \(error.localizedDescription)")
        }
    }

}
