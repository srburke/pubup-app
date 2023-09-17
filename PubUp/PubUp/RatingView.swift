//
//  RatingView.swift
//  PubUp
//
//  Created by Shannon Burke on 5/10/23.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int 
    let maxRating = 5
    let notSelected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { num in
                showStar(for: num)
                    .foregroundColor(num <= rating ? Color("login") : Color.gray)
                    .onTapGesture {
                        rating = num
                    }
            }
            
        }
    }
    
    func showStar(for num: Int) -> Image {
        if num > rating {
            return notSelected
        } else {
            return selected
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
