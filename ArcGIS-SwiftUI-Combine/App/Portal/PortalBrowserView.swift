//// Copyright 2020 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import SwiftUI
import Combine
import ArcGIS

class PortalBrowserViewModel : ObservableObject {
    
    @Published var items = [AGSPortalItem]()
    
    @Published var errorMessage : String?
    
    init(_ portal: AGSPortal) {
        
        // A subject to load all portal item thumbnails
        let portalItemsSubject = PassthroughSubject<[AGSPortalItem], Error>()
        portalItemsSubject
            .flatMap { (items) in Publishers.Sequence<[AGSPortalItem], Error>(sequence: items) }
            .compactMap { $0.thumbnail }
            .flatMap { (loadableImage) -> AnyPublisher<UIImage?, Error> in
                loadableImage.publisher
                    .load()
                    .compactMap { (loadableImage) in loadableImage.image }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (_) in }) { (_) in self.objectWillChange.send() }
            .store(in: &disposable)

        // Build a stream to fetch the authenticated user's content.
        portal.publisher
            .load()
            .tryMap { (portal) -> AGSPortalUser in
                guard portal.loadStatus == .loaded && portal.user != nil else { throw NSError.missingUserCredential }
                return portal.user!
            }
            .flatMap { (user) -> AnyPublisher<[AGSPortalItem], Error> in
                user.publisher
                    .fetchContent()
                    .map { (items, folders) -> [AGSPortalItem] in items.filter { $0.type == .webMap }}
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    break
                case .finished:
                    self.errorMessage = nil
                    break
                }
            }, receiveValue: { (items) in
                self.items = items
                portalItemsSubject.send(items)
            })
            .store(in: &disposable)
    }
    
    private var disposable = Set<AnyCancellable>()
    
    deinit {
        disposable.forEach { $0.cancel() }
    }
}

struct PortalBrowserView: View {
    
    @ObservedObject var model: PortalBrowserViewModel
    @Binding var showUserProfile: Bool
    
    init(portal: AGSPortal, showUserProfile: Binding<Bool>) {
        self.model = PortalBrowserViewModel(portal)
        self._showUserProfile = showUserProfile
    }
    
    private var userButton: some View {
        Button(action: { self.showUserProfile = true }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(model.items) { item in
                        NavigationLink(destination: MapView(map: AGSMap(item: item))) {
                            PortalItemView(item: item)
                                .padding(12)
                        }
                    }
                }
                if model.errorMessage != nil {
                    Section {
                        Text(model.errorMessage!)
                            .padding(12)
                    }
                }
            }
            .navigationBarTitle("Maps")
            .navigationBarHidden(false)
            .navigationBarItems(trailing: userButton)
        }
    }
}
