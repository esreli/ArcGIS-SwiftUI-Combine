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

struct PortalItemViewModel {
    
    let title: String
    let typeName: String
    let viewCount: Int
    let thumbnail: Image
    
    init(item: AGSPortalItem) {
        self.title = item.title
        self.typeName = item.typeName
        self.viewCount = item.viewCount
        if let image = item.thumbnail?.image {
            self.thumbnail = Image(uiImage: image)
        }
        else {
            self.thumbnail = Image(systemName: "globe")
        }
    }
}

struct PortalItemView : View {
    
    let model : PortalItemViewModel
    
    init(item: AGSPortalItem) {
        self.model = PortalItemViewModel(item: item)
    }
    
    var body : some View {
        HStack {
            RoundedCornerImageView(image: model.thumbnail, width: 44, height: 44, radius: 4)
            VStack {
                HStack {
                    Text(model.title)
                    Spacer()
                }
                HStack {
                    Text(model.typeName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(model.viewCount) \(model.viewCount > 1 ? "views" : "view")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 8)
        }
    }
}
