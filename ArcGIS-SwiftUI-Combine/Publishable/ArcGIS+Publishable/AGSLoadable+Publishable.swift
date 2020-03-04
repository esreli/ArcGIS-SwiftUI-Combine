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

extension Publishable where Base: AGSLoadable, Base: NSObject {
    
    func load() -> Future<Base, Error> {
        Future<Base, Error> { promise in
            self.base.load { (error) in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(self.base))
                }
            }
        }
    }
    
    var loadStatus: AnyPublisher<AGSLoadStatus, Never> {
        base.publisher(for: \.loadStatus).eraseToAnyPublisher()
    }
    
    var loadError: AnyPublisher<Error?, Never> {
        base.publisher(for: \.loadError).eraseToAnyPublisher()
    }
}


