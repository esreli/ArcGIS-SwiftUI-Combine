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
import Combine
import SwiftUI

class CompassViewModel : ObservableObject {
    
    @Published var rotation : Double = 0.0
    
    init(mapView: AGSMapView) {
        
        // 1. Recieve changes to rotation
        mapView.publishable
            .rotation
            .throttle(for: 0.01, scheduler: RunLoop.main, latest: true)
            .assign(to: \.rotation, on: self)
            .store(in: &subscriptions)
        
        // 2. Set Map View Viewpoint Rotation to North
        viewPointRotation
            .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
            .flatMap { (angle) in
                mapView.publishable
                    .setViewpointRotation(angle)
                    .ignoreOutput()
            }
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    // MARK: - Rotation
    
    func rotateMapTrueNorth() {
        viewPointRotation.send(0)
    }
    
    private let viewPointRotation = PassthroughSubject<Double, Never>()
    
    // MARK: - Disposable
    
    private var subscriptions = Set<AnyCancellable>()
}

struct CompassView : View {
    
    @ObservedObject var model: CompassViewModel
    
    var body : some View {
        Button(action: rotateMapTrueNorth) {
            Image("Compass")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .rotationEffect(.degrees(-model.rotation))
        .buttonStyle(PlainButtonStyle())
        .opacity(model.rotation == 0.0 ? 0.0 : 1.0)
    }
    
    private func rotateMapTrueNorth() {
        model.rotateMapTrueNorth()
    }
}
