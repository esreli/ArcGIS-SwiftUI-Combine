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

extension AGSPortalItem: PublishableBase { }

extension Publishable where Base == AGSPortalItem {
    
    var title: AnyPublisher<String, Never> {
        base.publisher(for: \.title).eraseToAnyPublisher()
    }
    
    var typeName: AnyPublisher<String, Never> {
        base.publisher(for: \.typeName).eraseToAnyPublisher()
    }
    
    var viewCount: AnyPublisher<Int, Never> {
        base.publisher(for: \.viewCount).eraseToAnyPublisher()
    }
}
