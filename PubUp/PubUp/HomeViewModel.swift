//
//  HomeViewModel.swift
//  PubUp
//
//  Created by Shannon Burke on 5/8/23.
//  Sources: Gary Tokman Yelp API Tutorial & Yelp API Documentation
//  Packages: Gary Tokman ExtensionKit

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import MapKit
import CoreData
import ExtensionKit
import CoreLocation
import CoreLocationUI


final class HomeViewModel: ObservableObject {
   
    @Published var businesses = [Business]()
    @Published var searchText: String
    @Published var region: MKCoordinateRegion
    @Published var business: Business?
    @Published var cityName = ""
    @Published var completions = [String]()
    @Published var selectedCategory: String
    @Published var showModal: Bool
    
    
    var cancellables = [AnyCancellable]()
    let locationManager = CLLocationManager()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BusinessModel")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Could not find core data database!")
            }
        }
        return container
    }()
    
    init() {
        searchText = ""
        selectedCategory = ""
        region = .init()
        business = nil
        showModal = locationManager.authorizationStatus == .notDetermined
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        request()
    }
    
    @MainActor
    func requestPermision() {
        locationManager
            .requestLocationWhenInUseAuthorization()
            .map {$0 == .notDetermined}
            .assign(to: &$showModal)
    }
        

    func getLocation() -> AnyPublisher<CLLocation, Never> {
        locationManager.receiveLocationUpdates(oneTime: true)
            .replaceError(with: [])
            .compactMap(\.first)
            .eraseToAnyPublisher()
    }
    
    func request(service: YelpApiService = .live) {
        let location = getLocation().share()
        
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .combineLatest($showModal, $selectedCategory, location)
            .map { (term, show, cat, location) in
                service.request (
                    .search(
                        term: term,
                        location: location,
                        cat: term.isEmpty ? cat : nil
                    )
                )
            }
            .switchToLatest()
            .assign(to: &$businesses)
        
        location
            .map {
                $0.reverseGeocode()
            }
            .switchToLatest()
            .compactMap(\.first)
            .compactMap(\.locality)
            .replaceError(with: "")
            .assign(to: &$cityName)
        
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .combineLatest(location)
            .map { term, location in
                service.completion(.completion(text: term, location: location))
                
            }
            .switchToLatest()
            .map{$0.map(\.text)}
            .assign(to: &$completions)
    }
    
   
    
   
    func delete(business: Business, with context: NSManagedObjectContext) throws {
    
        let fetchRequest: NSFetchRequest<BusinessModel> = BusinessModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", business.id ?? "")
        if let model = try? context.fetch(fetchRequest).first {
            context.delete(model)
                
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func saveBusinessToFirestore(business: Business) throws {
        let db = Firestore.firestore()
        do {
            let documentData = try Firestore.Encoder().encode(business)
            guard let id = business.id else {
                let collectionRef = db.collection("businesses")
                collectionRef.addDocument(data: documentData)
                return
            }
            let collectionRef = db.collection("businesses")
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
    
    func save(business: Business, with context: NSManagedObjectContext) throws {
        let model = BusinessModel(context: context)
        model.id = business.id
        model.imageUrl = business.imageURL
        model.name = business.name
        model.cat = business.catDesc
        model.price = business.price
        model.location = business.formatAddress
        model.phone = business.formatPhone
      
        try context.save()
        
    }
    
    
}
