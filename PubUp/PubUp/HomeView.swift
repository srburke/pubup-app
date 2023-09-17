//
//  ListView.swift
//  PubUp
//
//  Created by Shannon Burke on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct HomeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.managedObjectContext) var context
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color("login"))]
    }
    
    @State var sheetIsPresented = false
    @State private var angle: Double = 0
    @State var toggleFav = false
  
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List(viewModel.businesses, id: \.id){ business in
                    ZStack {
                        
                        NavigationLink(destination: CardDetailView(business: business)) {
                            EmptyView().opacity(0).frame(width: 0)
                        }
                        
                        CardView(business: business)
                            .swipeActions(edge: .trailing,allowsFullSwipe: true) {
                                Button{
                                    do {
                                        try viewModel.save(business: business, with: context)
                                        print("saved")
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor( .white)
                                        .padding(.horizontal, 5)
                                }
                            }
                    }
                    .onAppear {
                        Task {
                            do {
                                try viewModel.saveBusinessToFirestore(business: business)
                                print("saved")
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                    .listRowSeparator(.hidden)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 15)
                }
                .listStyle(.plain)
                .navigationTitle(Text(viewModel.cityName))
                .searchable(text: $viewModel.searchText, prompt: Text("Search Bars, Food, Entertainment...")) {
                    ForEach(viewModel.completions, id: \.self) { completion in
                        Text(completion).searchCompletion(completion)
                    }
                }
                
                
            }
            .onChange(of: viewModel.showModal) { newValue in
                viewModel.request()
            }
            
        }
       
  
           
    }
}
    

        
        
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .environmentObject(HomeViewModel())
            
            
        }
    }
    
}

