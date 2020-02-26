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

import Foundation
import SwiftUI
import ArcGIS
import Combine

struct PortalSignInView: View {
    
    @EnvironmentObject private var appPortalModel: AppPortalModel
    @State var enterpriseURLString = ""
    @State var error: AlertError? = nil
    @State var loading : Bool = false
    
    var body: some View {
        VStack {
            AGOL
            HorizontalDividerView(title:"or")
            Enterprise
        }
        .frame(width: 300, height: 300, alignment: .center)
        .alert(item: self.$error) { (alertError) -> Alert in
            Alert(title: Text(alertError.reason))
        }
        .onReceive(appPortalModel.$status) { (status) in
            switch status {
            case .signedIn(_):
                self.loading = false
                break
            case .failureSigningIn(let error):
                self.loading = false
                self.error = AlertError(reason: error.localizedDescription)
                break
            case .loading:
                self.loading = true
                break
            case .notSignedIn:
                self.loading = false
                break
            }
        }
    }
    
    // MARK:- AGOL
    
    private var AGOL: some View {
        Button(/*@START_MENU_TOKEN@*/"Sign In with ArcGIS Online"/*@END_MENU_TOKEN@*/, action: signInToArcGISOnline)
            .buttonStyle(ProminentButtonStyle())
            .disabled(loading)
    }
    
    private func signInToArcGISOnline() {
        self.appPortalModel.attemptSignIn(to: AGSPortal.arcGISOnline(withLoginRequired: true))
    }
    
    // MARK:- Enterprise
    
    private var Enterprise : some View {
        VStack {
            Text("Specify the URL to your portal")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextField("https://<server>/portal", text: self.$enterpriseURLString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(/*@START_MENU_TOKEN@*/"Sign In with ArcGIS Enterprise"/*@END_MENU_TOKEN@*/, action: signInToEnterprise)
                .buttonStyle(ProminentButtonStyle())
                .disabled(loading)
        }
    }
    
    private func signInToEnterprise() {
        if let url = URL(string: enterpriseURLString) {
            self.appPortalModel.attemptSignIn(to: AGSPortal(url: url, loginRequired: true))
        }
        else {
            self.error = AlertError(reason: "Invalid URL.")
        }
    }
}

#if DEBUG
struct PortalSignInView_Previews : PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
#endif
