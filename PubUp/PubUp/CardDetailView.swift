//
//  PubDetailView.swift
//  PubUp
//
//  Created by Shannon Burke on 4/20/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CardDetailView: View {
    let business: Business
    @FirestoreQuery(collectionPath: "reviews") var reviews: [Review]
    @Environment(\.dismiss) private var dismiss
    @State var showReview = false
    var previewRunning = false
    
    var avgRating: String {
        guard reviews.count != 0 else {
            return "-.-"
        }
        let averageVal = Double(reviews.reduce(0) {$0 + $1.rating}) / Double(reviews.count)
        return String(format: "%.1f", averageVal)
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                
                    AsyncImage(url: business.formatImageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            image.frame(height: UIScreen.main.bounds.height * 0.10)

                    } placeholder: {
                        Color.gray.shimmer()
                    }
                    .frame(height: 200)
            }
            .ignoresSafeArea(edges: [.top, .bottom])
                
                
        
            VStack(alignment: .leading, spacing: 2){
                
                Group {
                    HStack {
                        Text(business.formatName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 5)
                        Spacer()
                        
                        Button {
                            showReview.toggle()
                        } label: {
                            Image(systemName: "ellipsis.message.fill")
                                .font(.title)
                                .foregroundColor(Color("login"))
                        }
                            
                    }
                        Text(business.catDesc)
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                        
                }
                 
                Group {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(Color("login"))
                        Button(action: openMaps) {
                            Text(business.formatAddress)
                        }
                        Spacer()
                        
                        Image(systemName: "banknote.fill")
                            .foregroundColor(Color("login"))
                        Text(business.formatPrice)
                            .foregroundColor(.black)
                        Spacer()
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("login"))
                        Text(avgRating)
                            .foregroundColor(.black)
                        Spacer()
                        
                    }.font(.subheadline)
                       
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Color("login"))
                        Button(action: displayPhone) {
                            Text(business.formatPhone)
                        }
                        Spacer()
                        
                    }.font(.subheadline)
                        
                }
                .padding(.bottom, 20)
                    
                Text("Reviews")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                List {
                    ForEach(reviews) { review in
                        VStack(alignment: .leading) {
                            Text(review.reviewer)
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            HStack {
                                RatingView(rating: .constant(review.rating))
                                    .font(.headline)
                                    .fontWeight(.regular)
                                
                                
                                Text(review.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                            }
                            Text(review.body)
                                .font(.body)
                                .fontWeight(.regular)
                        }
                        .listRowSeparator(.hidden)
                       
                    }.foregroundColor(.black)
                        .padding(.bottom, 15)
                }
                .listStyle(.plain)
               
                Spacer()
                    
        }
        .onAppear {
            if !previewRunning {
                $reviews.path = "businesses/\(business.id ?? "")/reviews"
                print("reviews.path = \($reviews.path)")
            }
        }
        .padding().padding()
        .frame(maxWidth: .infinity, maxHeight: 800)
        .background(Color.white)
        .cornerRadius(30)
        .ignoresSafeArea(edges: [.top, .bottom])
              
        .sheet(isPresented: $showReview) {
            NavigationStack {
                ReviewView(business: business, review: Review())
            }
        }
                
    }
    .toolbar {
        ToolbarItem(placement: .navigationBarLeading){
            Button(action: {dismiss()}) {
                Image(systemName: "chevron.backward.circle.fill")
                    .font(.title)
            }
            .tint(Color("loginCard"))
        }
    }
    .navigationBarBackButtonHidden(true)
        
}
    
    func displayPhone() {
        UIApplication.shared.openPhone(calling: business.phone ?? "")
    }
    
    func openMaps() {
        let query = "\(business.coordinates?.latitude ?? 0), \(business.coordinates?.longitude ?? 0)"
        UIApplication.shared.openExternalMapApp(query: query)
    }
        

}


struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           
            CardDetailView(
                business: .init(
                    id: nil,
                    price: "$",
                    alias: nil,
                    phone: "(847) 222-8724",
                    isClosed: nil,
                    categories: [.init(alias: nil, title: "Bar")],
                    name: "HomeBrew",
                    url: nil,
                    coordinates: nil,
                    imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/j_Ut4i4j2Q4d2TVEDPVt4g/o.jpg",
                    location: .init(city: "Bloomington", country: nil, address2: nil, address3: nil, state: "IL", address1: "nil", zipCode: "61761", displayAddress: ["701 Blossom St"])
               
                ),previewRunning: true
            )
        
        }
                            .environmentObject(HomeViewModel())
                            .environmentObject(ReviewViewModel())
                
    
}
    
}



