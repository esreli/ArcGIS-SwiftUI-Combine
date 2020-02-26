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
import Combine

extension AGSMapViewInteractionOptions: ArcGISPublishable { }

extension ArcGISPublisher where Base == AGSMapViewInteractionOptions {

    var allowMagnifierToPan: AnyPublisher<Bool, Never> {
        base.publisher(for: \.allowMagnifierToPan).eraseToAnyPublisher()
    }
    
    var isEnabled: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isEnabled).eraseToAnyPublisher()
    }
    
    var isMagnifierEnabled: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isMagnifierEnabled).eraseToAnyPublisher()
    }
    
    var isPanEnabled: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isPanEnabled).eraseToAnyPublisher()
    }
    
    var isRotateEnabled: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isRotateEnabled).eraseToAnyPublisher()
    }
    
    var isZoomEnabled: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isZoomEnabled).eraseToAnyPublisher()
    }
    
    var zoomFactor: AnyPublisher<Double, Never> {
        base.publisher(for: \.zoomFactor).eraseToAnyPublisher()
    }
    
    func any() -> AnyPublisher<AGSMapViewInteractionOptions, Never> {
        allowMagnifierToPan
            .combineLatest(isEnabled)
            .combineLatest(isMagnifierEnabled)
            .combineLatest(isPanEnabled)
            .combineLatest(isRotateEnabled)
            .combineLatest(isZoomEnabled)
            .combineLatest(zoomFactor)
            .map { (_) in return self.base }
            .eraseToAnyPublisher()
    }
}
