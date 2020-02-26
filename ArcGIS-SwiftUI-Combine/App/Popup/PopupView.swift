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

import ArcGIS
import SwiftUI
import Combine

class PopupViewModel: ObservableObject {
    
    struct Field : Identifiable {
        let id: Int
        let name: String
        let value: String
    }
        
    init(popup: AGSPopup) {
        let popupManager = AGSPopupManager(popup: popup)
        fields = popupManager.displayFields.map { Field(id: $0.hash, name: $0.fieldName, value:popupManager.formattedValue(for: $0)) }
    }
    
    @Published var fields: [Field]
}

struct PopupView : View {
    
    let model: PopupViewModel
    
    init(popup: AGSPopup) {
        self.model = PopupViewModel(popup: popup)
    }

    var body : some View {
        List(model.fields) { field in
            VStack(alignment: .leading, spacing: 4) {
                Text(field.name)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(field.value)
            }
            .padding([.top, .bottom], 8)
        }
    }
}

