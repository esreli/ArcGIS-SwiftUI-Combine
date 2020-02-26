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

extension AGSLocationDisplay: ArcGISPublishable { }

extension ArcGISPublisher where Base == AGSLocationDisplay {

    var heading: AnyPublisher<Double, Never> {
        base.publisher(for: \.heading).eraseToAnyPublisher()
    }
    
    var location: AnyPublisher<AGSLocation?, Never> {
        base.publisher(for: \.location).eraseToAnyPublisher()
    }
    
    var navigationPointHeightFactor: AnyPublisher<Float, Never> {
        base.publisher(for: \.navigationPointHeightFactor).eraseToAnyPublisher()
    }
    
    var opacity: AnyPublisher<Float, Never> {
        base.publisher(for: \.opacity).eraseToAnyPublisher()
    }
    
    var started: AnyPublisher<Bool, Never> {
        base.publisher(for: \.started).eraseToAnyPublisher()
    }
    
    var showLocation: AnyPublisher<Bool, Never> {
        base.publisher(for: \.showLocation).eraseToAnyPublisher()
    }
    
    var showAccuracy: AnyPublisher<Bool, Never> {
        base.publisher(for: \.showAccuracy).eraseToAnyPublisher()
    }
}
