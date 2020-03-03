//// Copyright 2019 Esri
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

import ArcGIS
import SwiftUI
import Combine

class AppPortalModel: ObservableObject {
    
    // MARK:- Portal Status
    
    enum Status {
        case notSignedIn
        case loading
        case signedIn(AGSPortal)
        case failureSigningIn(Error)
    }
    
    @Published var status: Status = .notSignedIn
    
    var portal : AGSPortal? {
        switch status {
        case .signedIn(let portal):
            return portal
        default:
            return nil
        }
    }
    
    // MARK:- Sign In / Sign Out
    
    func attemptSignIn(to portal: AGSPortal) {
        
        if case .loading = status { return }
        
        status = .loading
        
        // 1. Enable auto sync to keychain
        enableAutoSyncToKeychain()
        
        // 2. Load the portal
        portal.publishable
            .load()
            .tryMap { (portal) -> AGSPortal in
                guard portal.loadStatus == .loaded, portal.user != nil else { throw AppError.missingUserCredential }
                return portal
            }
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.status = .failureSigningIn(error)
                    break
                case .finished:
                    break
                }
            }) { self.status = .signedIn($0)  }
            .store(in: &subscriptions)
    }
    
    func signOutFromPortal() {
        // 1. Disable auto sync to keychain
        revokeAndDisableAutoSyncToKeychain()
        // 2. Specify status not signed in
        status = .notSignedIn
    }
    
    // MARK: Keychain
    
    private func enableAutoSyncToKeychain() {
        AGSAuthenticationManager.shared()
            .credentialCache
            .enableAutoSyncToKeychain(withIdentifier: "ArcGIS+SwiftUI+Combine", accessGroup: nil, acrossDevices: false)
    }
    
    private func revokeAndDisableAutoSyncToKeychain() {
        AGSAuthenticationManager.shared()
            .credentialCache.publishable
            .removeAndRevokeAllCredentials()
            .sink { _ in
                AGSAuthenticationManager.shared().credentialCache.disableAutoSyncToKeychain()
            }
            .store(in: &subscriptions)
    }
    
    private var subscriptions = Set<AnyCancellable>()
}
