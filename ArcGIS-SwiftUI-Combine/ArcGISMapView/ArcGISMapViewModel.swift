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
import SwiftUI
import Combine

class ArcGISMapViewModel : NSObject, ObservableObject {
    
    // By allowing the user to specify which properties to bind
    // we can reduce the number of state change notifications sent to
    // SwiftUI Views who bind to this view model. This is important because
    // SwiftUI recreates the view hierachy with every change to state.
    //
    init(bindings: PropertyBindings) {
        super.init()

        // Build a throttler that throttles all BindableObject send messages,
        // sending only the latest message once within a fixed increment of time.
        //
        throttler
            .throttle(for: 0.01, scheduler: DispatchQueue.main, latest: true)
            .receive(on: RunLoop.main)
            .sink { (_) in self.objectWillChange.send() }
            .store(in: &disposable)
        
        // Subscribe to changes to properties that might affect app UI.
        // Other map view properties should be subscribed to on an as-needed basis.
        //
        build(bindings: bindings)
    }
    
    // MARK:- Disposable Subscriptions
    //
    private var disposable = Set<AnyCancellable>()
    
    // MARK:- Throttler

    // Calling `throttler.send(self)` sends message through the throttler, limiting the
    // the number of state change messages sent to bound SwiftUI Views, thus reducing the number of
    // times the view hierarchy must be re-constructed.
    //
    let throttler = PassthroughSubject<ArcGISMapViewModel, Never>()
    
    // MARK:- Publishable AGSMapView
    
    private let mapView = AGSMapView(frame: .zero)
    
    // The Publisher is a tool that configures with an `AGSMapView` and
    // observes all properties of the map view and publishes the changes via a Combine Subject.
    // Additionally, the Publisher wraps all methods, particularly, creating Combine Publishers of all async methods.
    //
    private(set) lazy var publisher: ArcGISPublisher<AGSMapView> = { self.mapView.publisher }()
    
    deinit {
        // Cancel bound property subscriptions
        //
        disposable.forEach { $0.cancel() }
    }
}

extension ArcGISMapViewModel {
    
    struct PropertyBindings: OptionSet {
        let rawValue: Int32
        
        static let adjustedContentInset = PropertyBindings(rawValue: 1 << 0)
        static let attributionText = PropertyBindings(rawValue: 1 << 1)
        static let isAttributionTextVisible = PropertyBindings(rawValue: 1 << 2)
        static let contentInset = PropertyBindings(rawValue: 1 << 3)
        static let drawStatus = PropertyBindings(rawValue: 1 << 4)
        static let graphicsOverlays = PropertyBindings(rawValue: 1 << 5)
        static let insetsContentInsetFromSafeArea = PropertyBindings(rawValue: 1 << 6)
        static let interactionOptions = PropertyBindings(rawValue: 1 << 7)
        static let locationDisplay = PropertyBindings(rawValue: 1 << 8)
        static let map = PropertyBindings(rawValue: 1 << 9)
        static let mapScale = PropertyBindings(rawValue: 1 << 10)
        static let isNavigating = PropertyBindings(rawValue: 1 << 11)
        static let rotation = PropertyBindings(rawValue: 1 << 12)
        static let selectionProperties = PropertyBindings(rawValue: 1 << 13)
        static let sketchEditor = PropertyBindings(rawValue: 1 << 14)
        static let spatialReference = PropertyBindings(rawValue: 1 << 15)
        static let timeExtent = PropertyBindings(rawValue: 1 << 16)
        static let unitsPerPoint = PropertyBindings(rawValue: 1 << 17)
        static let visibleArea = PropertyBindings(rawValue: 1 << 17)
    }
    
    private func build(bindings: PropertyBindings) {

        if bindings.contains(.adjustedContentInset) {
            publisher.adjustedContentInset
                .sink { (inset) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.attributionText) {
            publisher.attributionText
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.isAttributionTextVisible) {
            publisher.isAttributionTextVisible
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.contentInset) {
            publisher.contentInset
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.drawStatus) {
            publisher.drawStatus
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.graphicsOverlays) {
            publisher.graphicsOverlays
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.insetsContentInsetFromSafeArea) {
            publisher.insetsContentInsetFromSafeArea
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        #warning("Is this a good solution for nested bindings?")
        if bindings.contains(.interactionOptions) {
            publisher.interactionOptions
                .sink { (interactionOptions) in
                    interactionOptions.publisher.any()
                        .sink { (_) in self.throttler.send(self) }
                        .store(in: &self.disposable)
                    self.throttler.send(self)
                }
                .store(in: &disposable)
        }
        
        #warning("Consider building binding to property changes to (optional) locationDispaly itself.")
        if bindings.contains(.locationDisplay) {
            publisher.locationDisplay
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.map) {
            publisher.map
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.mapScale) {
            publisher.mapScale
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.isNavigating) {
            publisher.isNavigating
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.rotation) {
            publisher.rotation
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.selectionProperties) {
            publisher.selectionProperties
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.sketchEditor) {
            publisher.sketchEditor
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.spatialReference) {
            publisher.spatialReference
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.timeExtent) {
            publisher.timeExtent
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.unitsPerPoint) {
            publisher.unitsPerPoint
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
        
        if bindings.contains(.visibleArea) {
            publisher.visibleArea
                .sink { (_) in self.throttler.send(self) }
                .store(in: &disposable)
        }
    }
}

// Expose properties of mapView via view model.
extension ArcGISMapViewModel {
    
    var adjustedContentInset : AGSEdgeInsets {
        get { mapView.adjustedContentInset }
    }
    
    var attributionText : String {
        get { mapView.attributionText }
    }
    
    var isAttributionTextVisible : Bool {
        get { mapView.isAttributionTextVisible }
        set { mapView.isAttributionTextVisible = newValue }
    }
    
    var contentInset : AGSEdgeInsets {
        get { mapView.contentInset }
        set { mapView.contentInset = newValue }
    }
    
    var drawStatus : AGSDrawStatus {
        get { mapView.drawStatus }
    }

    var graphicsOverlays : NSMutableArray {
        get { mapView.graphicsOverlays }
    }
    
    var insetsContentInsetFromSafeArea : Bool {
        get { mapView.insetsContentInsetFromSafeArea }
        set { mapView.insetsContentInsetFromSafeArea = newValue }
    }
    
    var interactionOptions : AGSMapViewInteractionOptions {
        get { mapView.interactionOptions }
        set { mapView.interactionOptions = newValue }
    }
    
    var locationDisplay : AGSLocationDisplay {
        get { mapView.locationDisplay }
        set { mapView.locationDisplay = newValue }
    }
    
    var map : AGSMap? {
        get { mapView.map }
        set { mapView.map = newValue }
    }
    
    var mapScale : Double {
        get { mapView.mapScale }
    }
    
    var isNavigating : Bool {
        get { mapView.isNavigating }
    }
    
    var rotation : Double {
        get { mapView.rotation }
    }
    
    var selectionProperties : AGSSelectionProperties {
        get { mapView.selectionProperties }
        set { mapView.selectionProperties = newValue }
    }
    
    var sketchEditor : AGSSketchEditor? {
        get { mapView.sketchEditor }
        set { mapView.sketchEditor = newValue }
    }
    
    var spatialReference : AGSSpatialReference? {
        get { mapView.spatialReference }
    }
    
    var timeExtent : AGSTimeExtent? {
        get { mapView.timeExtent }
        set { mapView.timeExtent = newValue }
    }
    
    var unitsPerPoint : Double {
        get { mapView.unitsPerPoint }
    }
    
    var visibleArea : AGSPolygon? {
        get { mapView.visibleArea }
    }
}
