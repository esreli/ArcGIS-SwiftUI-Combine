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
import UIKit

extension AGSMapView: PublishableBase { }

extension Publishable where Base == AGSMapView {
    
    // MARK: Methods
    
    func exportImage() -> Future<UIImage?, Error> {
        Future<UIImage?, Error> { promise in
            self.base.exportImage { (image, error) in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(image))
                }
            }
        }
    }
    
    func identify(_ graphicsOverlay: AGSGraphicsOverlay, screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool) -> Future<AGSIdentifyGraphicsOverlayResult, Never> {
        Future<AGSIdentifyGraphicsOverlayResult, Never> { promise in
            self.base.identify(graphicsOverlay, screenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly) { (result) in
                promise(.success(result))
            }
        }
    }
    
    func identify(_ graphicsOverlay: AGSGraphicsOverlay, screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool, maximumResults: Int) -> Future<AGSIdentifyGraphicsOverlayResult, Never> {
        Future<AGSIdentifyGraphicsOverlayResult, Never> { promise in
            self.base.identify(graphicsOverlay, screenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly, maximumResults: maximumResults) { (result) in
                promise(.success(result))
            }
        }
    }
    
    func identifyGraphicsOverlays(at screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool) -> Future<[AGSIdentifyGraphicsOverlayResult], Error> {
        Future<[AGSIdentifyGraphicsOverlayResult], Error> { promise in
            self.base.identifyGraphicsOverlays(atScreenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    assert(result != nil, "If the operation does not produce an error, it should always produce results.")
                    promise(.success(result!))
                }
            }
        }
    }
    
    func identifyGraphicsOverlays(at screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool, maximumResultsPerOverlay: Int) -> Future<[AGSIdentifyGraphicsOverlayResult], Error> {
        Future<[AGSIdentifyGraphicsOverlayResult], Error> { promise in
            self.base.identifyGraphicsOverlays(atScreenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly, maximumResultsPerOverlay: maximumResultsPerOverlay) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    assert(result != nil, "If the operation does not produce an error, it should always produce results.")
                    promise(.success(result!))
                }
            }
        }
    }
    
    func identifyLayer(_ layer: AGSLayer, screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool) -> Future<AGSIdentifyLayerResult, Never> {
        Future<AGSIdentifyLayerResult, Never> { promise in
            self.base.identifyLayer(layer, screenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly) { (result) in
                promise(.success(result))
            }
        }
    }
    
    func identifyLayer(_ layer: AGSLayer, screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool, maximumResults: Int) -> Future<AGSIdentifyLayerResult, Never> {
        Future<AGSIdentifyLayerResult, Never> { promise in
            self.base.identifyLayer(layer, screenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly, maximumResults: maximumResults) { (result) in
                promise(.success(result))
            }
        }
    }
    
    func identifyLayersAt(_ screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool) -> Future<[AGSIdentifyLayerResult], Error> {
        Future<[AGSIdentifyLayerResult], Error> { promise in
            self.base.identifyLayers(atScreenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    assert(result != nil, "If the operation does not produce an error, it should always produce results.")
                    promise(.success(result!))
                }
            }
        }
    }
    
    func identifyLayersAt(_ screenPoint: CGPoint, tolerance: Double, returnPopupsOnly: Bool, maximumResultsPerLayer: Int) -> Future<[AGSIdentifyLayerResult], Error> {
        Future<[AGSIdentifyLayerResult], Error> { promise in
            self.base.identifyLayers(atScreenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: returnPopupsOnly, maximumResultsPerLayer: maximumResultsPerLayer) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    assert(result != nil, "If the operation does not produce an error, it should always produce results.")
                    promise(.success(result!))
                }
            }
        }
    }
    
    func setBookmark(_ bookmark: AGSBookmark) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setBookmark(bookmark) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpoint(_ viewpoint: AGSViewpoint) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpoint(viewpoint) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpoint(_ viewpoint: AGSViewpoint, duration: Double) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpoint(viewpoint, duration: duration) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpoint(_ viewpoint: AGSViewpoint, duration: Double, curve: AGSAnimationCurve) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpoint(viewpoint, duration: duration, curve: curve) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpointCenter(_ center: AGSPoint) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpointCenter(center) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpointCenter(_ center: AGSPoint, scale: Double) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpointCenter(center, scale: scale) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpointGeometry(_ geometry: AGSGeometry) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpointGeometry(geometry) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpointGeometry(_ geometry: AGSGeometry, padding: Double) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpointGeometry(geometry, padding: padding) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpointRotation(_ angle: Double) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpointRotation(angle) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    func setViewpointScale(_ scale: Double) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            self.base.setViewpointScale(scale) { (finished) in
                promise(.success(finished))
            }
        }
    }
    
    // MARK: Properties
    
    var adjustedContentInset: AnyPublisher<UIEdgeInsets, Never> {
        base.publisher(for: \.adjustedContentInset).eraseToAnyPublisher()
    }
    
    var attributionText: AnyPublisher<String, Never> {
        base.publisher(for: \.attributionText).eraseToAnyPublisher()
    }
    
    var isAttributionTextVisible: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isAttributionTextVisible).eraseToAnyPublisher()
    }
    
    var attributionTopAnchor: AnyPublisher<NSLayoutYAxisAnchor, Never> {
        base.publisher(for: \.attributionTopAnchor).eraseToAnyPublisher()
    }
    
    var backgroundGrid: AnyPublisher<AGSBackgroundGrid?, Never> {
        base.publisher(for: \.backgroundGrid).eraseToAnyPublisher()
    }
    
    var callout: AnyPublisher<AGSCallout, Never> {
        base.publisher(for: \.callout).eraseToAnyPublisher()
    }
    
    var contentInset: AnyPublisher<UIEdgeInsets, Never> {
        base.publisher(for: \.contentInset).eraseToAnyPublisher()
    }
    
    var drawStatus: AnyPublisher<AGSDrawStatus, Never> {
        base.publisher(for: \.drawStatus).eraseToAnyPublisher()
    }
    
    var graphicsOverlays: AnyPublisher<NSMutableArray, Never> {
        base.publisher(for: \.graphicsOverlays).eraseToAnyPublisher()
    }
    
    var grid: AnyPublisher<AGSGrid?, Never> {
        base.publisher(for: \.grid).eraseToAnyPublisher()
    }
    
    var insetsContentInsetFromSafeArea: AnyPublisher<Bool, Never> {
        base.publisher(for: \.insetsContentInsetFromSafeArea).eraseToAnyPublisher()
    }
    
    var interactionOptions: AnyPublisher<AGSMapViewInteractionOptions, Never> {
        base.publisher(for: \.interactionOptions).eraseToAnyPublisher()
    }
    
    var labeling: AnyPublisher<AGSViewLabelProperties?, Never> {
        base.publisher(for: \.labeling).eraseToAnyPublisher()
    }
    
    var layerViewStateChangedHandler: AnyPublisher<((AGSLayer, AGSLayerViewState) -> Void)?, Never> {
        base.publisher(for: \.layerViewStateChangedHandler).eraseToAnyPublisher()
    }
    
    var locationDisplay: AnyPublisher<AGSLocationDisplay, Never> {
        base.publisher(for: \.locationDisplay).eraseToAnyPublisher()
    }
    
    var map: AnyPublisher<AGSMap?, Never> {
        base.publisher(for: \.map).eraseToAnyPublisher()
    }
    
    var mapScale: AnyPublisher<Double, Never> {
        base.publisher(for: \.mapScale).eraseToAnyPublisher()
    }
    
    var isNavigating: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isNavigating).eraseToAnyPublisher()
    }
    
    var releaseHardwareResourcesWhenBackgrounded: AnyPublisher<Bool, Never> {
        base.publisher(for: \.releaseHardwareResourcesWhenBackgrounded).eraseToAnyPublisher()
    }
    
    var rotation: AnyPublisher<Double, Never> {
        base.publisher(for: \.rotation).eraseToAnyPublisher()
    }
    
    var selectionProperties: AnyPublisher<AGSSelectionProperties, Never> {
        base.publisher(for: \.selectionProperties).eraseToAnyPublisher()
    }
    
    var sketchEditor: AnyPublisher<AGSSketchEditor?, Never> {
        base.publisher(for: \.sketchEditor).eraseToAnyPublisher()
    }
    
    var spatialReference: AnyPublisher<AGSSpatialReference?, Never> {
        base.publisher(for: \.spatialReference).eraseToAnyPublisher()
    }
    
    var timeExtent: AnyPublisher<AGSTimeExtent?, Never> {
        base.publisher(for: \.timeExtent).eraseToAnyPublisher()
    }
    
    var touchDelegate: AnyPublisher<AGSGeoViewTouchDelegate?, Never> {
        base.publisher(for: \.touchDelegate).eraseToAnyPublisher()
    }
    
    var unitsPerPoint: AnyPublisher<Double, Never> {
        base.publisher(for: \.unitsPerPoint).eraseToAnyPublisher()
    }
    
    var viewpointChangedHandler: AnyPublisher<(()->Void)?, Never> {
        base.publisher(for: \.viewpointChangedHandler).eraseToAnyPublisher()
    }
    
    var visibleArea: AnyPublisher<AGSPolygon?, Never> {
        base.publisher(for: \.visibleArea).eraseToAnyPublisher()
    }
    
    var isWrapAroundEnabled: AnyPublisher<Bool, Never> {
        base.publisher(for: \.isWrapAroundEnabled).eraseToAnyPublisher()
    }
    
    var wrapAroundMode: AnyPublisher<AGSWrapAroundMode, Never> {
        base.publisher(for: \.wrapAroundMode).eraseToAnyPublisher()
    }
}
