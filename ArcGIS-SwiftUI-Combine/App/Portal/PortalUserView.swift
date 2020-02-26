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

class PortalUserViewModel : ObservableObject {
    
    // MARK:- Bindings
    
    // Portal
    @Published var portalName: String = "Portal"
    
    // User
    struct User {
        
        let thumbnail : UIImage
        let fullName : String
        let email : String
        
        init(thumbnail: UIImage? = nil, fullName: String? = nil, email: String? = nil) {
            self.thumbnail = thumbnail ?? UIImage(systemName: "person")!
            self.fullName = fullName ?? ""
            self.email = email ?? ""
        }
    }
    
    @Published var user: User?
    
    // Org
    struct Organization {
        
        let name: String
        let subdomain: String
        let id: String
        
        init(name: String? = nil, subdomain: String? = nil, id: String? = nil) {
            self.name = name ?? ""
            self.subdomain = subdomain ?? ""
            self.id = id ?? ""
        }
    }
    
    @Published var organization: Organization?
    
    // Error
    @Published var errorMessage : String?
    
    // MARK:- Init
    
    init(portal: AGSPortal) {
        
        // 1. Portal User Image
        
        let portalUserImageSubject = PassthroughSubject<AGSLoadableImage, Error>()
        
        portalUserImageSubject
            .flatMap { (loadableImage) -> AnyPublisher<UIImage?, Error> in
                loadableImage.publisher
                    .load()
                    .compactMap { (loadableImage) in loadableImage.image }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (_) in
                // If failure, do nothing.
            }) { (image) in
                self.user = User(thumbnail: image, fullName: self.user?.fullName, email: self.user?.email)
            }
            .store(in: &disposable)
        
        // 2. Portal User
        
        let portalUserSubject = PassthroughSubject<AGSPortalUser, Never>()
            
        portalUserSubject
            .receive(on: RunLoop.main)
            .sink { (user) in
                self.user = User(thumbnail: user.thumbnail?.image, fullName: user.fullName, email: user.email)
                if let thumbnail = user.thumbnail {
                    portalUserImageSubject.send(thumbnail)
                }
            }
            .store(in: &disposable)
        
        // 3. Portal Info
        
        let portalInfoSubject = PassthroughSubject<AGSPortalInfo, Never>()
        
        portalInfoSubject
            .receive(on: RunLoop.main)
            .sink { (info) in
                self.portalName = info.portalName ?? "Portal"
                self.organization = Organization(name: info.organizationName, subdomain: info.organizationSubdomain, id: info.organizationID)
            }
            .store(in: &disposable)
        
        // 4. Load Portal, begin process
        
        portal.publisher
            .load()
            .filter { (portal) in portal.loadStatus == .loaded }
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    break
                case .finished:
                    break
                }
            }) { (portal) in
                if let info = portal.portalInfo {
                    portalInfoSubject.send(info)
                }
                if let user = portal.user {
                    portalUserSubject.send(user)
                }
            }
            .store(in: &disposable)
    }

    private var disposable = Set<AnyCancellable>()
    
    deinit {
        disposable.forEach { $0.cancel() }
    }
}

struct PortalUserView : View {
    
    @EnvironmentObject private var portalModel: AppPortalModel
    @ObservedObject var model : PortalUserViewModel
    @Binding var showUserProfile : Bool
    
    init(portal: AGSPortal, showUserProfile: Binding<Bool>) {
        self.model = PortalUserViewModel(portal: portal)
        self._showUserProfile = showUserProfile
    }
    
    var body: some View {
        NavigationView {
            List {
                if model.user != nil {
                    UserSection
                }
                if model.organization != nil {
                    OrganizationSection
                }
                if model.errorMessage != nil {
                    ErrorSection
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(model.portalName)
            .navigationBarItems(trailing: done)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var done: some View {
        Button(action: { self.showUserProfile = false }) {
            Text("Done")
        }
    }
    
    private var UserSection : some View {
        Section(header: Text("User")) {
            HStack {
                RoundedCornerImageView(image: Image(uiImage: model.user!.thumbnail), width: 44, height: 44, radius: 4)
                VStack(alignment: .leading, spacing: 0) {
                    Text(model.user!.fullName)
                        .foregroundColor(.primary)
                    Text(model.user!.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: { self.portalModel.signOutFromPortal() }) { Text("Sign Out") }
            }
            .padding([.top, .bottom], 8)
        }
    }
    
    private var OrganizationSection : some View {
        Section(header: Text("Organization")) {
            HStack {
                Text("Name")
                Spacer()
                Text(model.organization!.name)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Subdomain")
                Spacer()
                Text(model.organization!.subdomain)
                    .foregroundColor(.secondary)
                
            }
            HStack {
                Text("ID")
                Spacer()
                Text(model.organization!.id)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var ErrorSection : some View {
        Section {
            Text(model.errorMessage!)
        }
    }
}
