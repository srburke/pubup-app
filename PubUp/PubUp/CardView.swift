//
//  CardView.swift
//  PubUp
//
//  Created by Shannon Burke on 5/8/23.
//

import SwiftUI

struct CardView: View {
   
    let business: Business
  
    var body: some View {
        HStack {
            
            AsyncImage(url: business.formatImageURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray.shimmer()
            }
            .frame(width: 110, height: 110)
            .cornerRadius(10)
            
            
            
            VStack(alignment: .leading, spacing: 10){
                Text(business.formatName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.leading, 5)
               
              
                    Text(business.formatCat)
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.leading, 5)
                
                
              
            }
            Spacer()
            
           
            
        }
        .foregroundColor(.black)
        .padding([.leading,.top, .bottom], 20)
        .background(Color("loginCard"))
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 10, y: 10)
        .cornerRadius(10)
        
        
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        
            Group {
               
                CardView(
                    business: .init(
                        id: nil,
                        price: nil,
                        alias: nil,
                        phone: nil,
                        isClosed: nil,
                        categories: nil,
                        name: "HomeBrew",
                        url: nil,
                        coordinates: nil,
                        imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/j_Ut4i4j2Q4d2TVEDPVt4g/o.jpg",
                        location: nil
                       
                    )
                )
            
            }
                               
            .environmentObject(HomeViewModel())
        
    }
        
    
}

