//
//  ReviewView.swift
//  PubUp
//
//  Created by Shannon Burke on 5/10/23.
//

import SwiftUI

struct ReviewView: View {
    let business: Business
    @State var review: Review
    @Environment (\.dismiss) private var dismiss
    @State var postedByThisUser = false
    @StateObject var reviewVM = ReviewViewModel()
 
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    
                    VStack(alignment: .leading) {
                        Text(business.formatName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        Text("\(business.formatAddress), \(business.location?.city ?? "Unknown"), \(business.location?.state ?? "Unknown")")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("login"))
                    .foregroundColor(.white)
                    
                    Text("Rate")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                        .foregroundColor(.black)
                    
                    
                    HStack {
                        RatingView(rating: $review.rating)
                            .font(.largeTitle)
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Review Title")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        TextField("Title", text: $review.title)
                            .textFieldStyle(.roundedBorder)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black.opacity(0.5), lineWidth: 3)
                                    .background(.clear)
                            }
                            .textInputAutocapitalization(.never)
                        
                        TextField("Write Review", text: $review.body, axis: .vertical)
                            .padding(.leading, 5)
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                        
                        
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black.opacity(0.5), lineWidth: 3)
                                    .background(.clear)
                            }
                            .textInputAutocapitalization(.never)
                        Button("Submit") {
                            Task {
                                try reviewVM.savePub(business: business, review: review)
                            }
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let business = Business(id: nil, price: nil, alias: nil, phone: nil, isClosed: nil, categories: nil, name: "Example Business", url: nil, coordinates: nil, imageURL: nil, location: .init(city: "Bloomington", country: nil, address2: nil, address3: nil, state: "IL", address1: "nil", zipCode: "61761", displayAddress: ["701 Main St"]))
        ReviewView(business: business, review: Review())
    }
}
