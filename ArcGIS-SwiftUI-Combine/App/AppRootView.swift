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
import ArcGIS

struct AppRootView: View {
    
    @EnvironmentObject private var appPortalModel: AppPortalModel
    @State var portal : AGSPortal?
    @State var showUserProfile: Bool = false
    
    var body: some View {
        VStack {
            if portal != nil {
                PortalBrowser
            }
            else {
                PortalSignIn
            }
        }
        .onReceive(self.appPortalModel.$status) { (status) in
            switch status {
            case .signedIn(let portal):
                self.portal = portal
                break
            default:
                if self.showUserProfile == true { self.showUserProfile = false }
                self.portal = nil
            }
        }
        .sheet(isPresented: $showUserProfile) {
            if self.portal != nil {
                PortalUserView(portal: self.portal!, showUserProfile: self.$showUserProfile)
                    .environmentObject(self.appPortalModel)
                    .accentColor(Color("Accent"))
            }
        }
        .accentColor(Color("Accent"))
    }
    
    var PortalBrowser : some View {
        return PortalBrowserView(portal: portal!, showUserProfile: $showUserProfile)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var PortalSignIn : some View {
        ZStack {
            Image("BG")
                .resizable()
                .aspectRatio(UIImage(named: "BG")!.size, contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            Color("BG-color")
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                PortalSignInView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
