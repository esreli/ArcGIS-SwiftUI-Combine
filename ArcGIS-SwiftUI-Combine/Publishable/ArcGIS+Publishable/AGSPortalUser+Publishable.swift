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

extension AGSPortalUser: PublishableBase { }

extension Publishable where Base == AGSPortalUser {
    
    var fullName: AnyPublisher<String?, Never> {
        base.publisher(for: \.fullName).eraseToAnyPublisher()
    }
    
    var email: AnyPublisher<String?, Never> {
        base.publisher(for: \.email).eraseToAnyPublisher()
    }
    
    var thumbnail: AnyPublisher<AGSLoadableImage?, Never> {
        base.publisher(for: \.thumbnail).eraseToAnyPublisher()
    }
    
    func fetchContent() -> Future<(items: [AGSPortalItem], folders: [AGSPortalFolder]), Error> {
        Future<(items: [AGSPortalItem], folders: [AGSPortalFolder]), Error> { promise in
            self.base.fetchContent { (items, folders, error) in
                if let error = error {
                    promise(.failure(error))
                }
                else if let items = items, let folders = folders {
                    promise(.success((items: items, folders: folders)))
                }
                else {
                    promise(.failure(AppError.unknown))
                }
            }
        }
    }
}
