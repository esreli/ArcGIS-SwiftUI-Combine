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
import Combine

struct Publishable<Base: PublishableBase> {
    let base: Base
}

protocol PublishableBase {
    associatedtype ArcGISPublisherBase: PublishableBase
    
    static var publishable: Publishable<ArcGISPublisherBase>.Type { get }
    var publishable: Publishable<ArcGISPublisherBase> { get }
}

extension PublishableBase {
    
    static var publishable: Publishable<Self>.Type {
        Publishable<Self>.self
    }
    
    var publishable: Publishable<Self> {
        Publishable<Self>(base: self)
    }
}
