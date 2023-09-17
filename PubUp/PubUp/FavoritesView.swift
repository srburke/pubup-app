//
//  FavoritesView.swift
//  PubUp
//
//  Created by Shannon Burke on 4/20/23.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var context
    @Environment (\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: HomeViewModel
    @FetchRequest(
        entity: BusinessModel.entity(),
        sortDescriptors: [],
        animation: .easeInOut)
    
    var businessModel: FetchedResults<BusinessModel>
    var businesses: [Business] {
        businessModel.map(Business.init(model:))
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color("login"))]
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                List(businesses, id: \.id) { business in
                    ZStack {
                        NavigationLink(destination: CardDetailView(business: business)){
                            EmptyView().opacity(0).frame(width: 0)
                        }
                       
                        CardView(business: business)
                            .padding(.bottom, 5)
                            .swipeActions(edge: .trailing,allowsFullSwipe: true) {
                                Button{
                                    do {
                                        try viewModel.delete(business: business, with: context)
                                        print("Deleted")
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    
                                } label: {
                                    Image(systemName: "trash.fill" )
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                }
                            }
                        
                        
                        
                    }
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 15)
                }
                .listStyle(.plain)
               
                
           
            }.navigationBarTitle("Favorites")
            
              

        }
    }
}



struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(HomeViewModel())
    }
}
