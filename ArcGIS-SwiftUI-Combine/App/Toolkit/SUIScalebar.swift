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
import ArcGISToolkit
import SwiftUI

struct SUIScalebar : UIViewRepresentable {
    
    let mapView: AGSMapView

    let units : ScalebarUnits
    let style : ScalebarStyle
    let alignment : ScalebarAlignment
    
    func makeUIView(context: Context) -> Scalebar {
        Scalebar(mapView: mapView)
    }
    
    func updateUIView(_ uiView: Scalebar, context: UIViewRepresentableContext<SUIScalebar>) {
        uiView.units = units
        uiView.style = style
        uiView.alignment = alignment
    }
}
