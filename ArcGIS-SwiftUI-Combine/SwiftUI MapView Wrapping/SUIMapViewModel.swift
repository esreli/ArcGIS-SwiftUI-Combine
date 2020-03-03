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

class SUIMapViewModel : NSObject, ObservableObject {
    
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
            .store(in: &subscriptions)
        
        // Subscribe to changes to properties that might affect app UI.
        // Other map view properties should be subscribed to on an as-needed basis.
        //
        build(bindings: bindings)
    }
    
    // MARK:- Disposable Subscriptions
    //
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK:- Throttler

    // Calling `throttler.send(self)` sends message through the throttler, limiting the
    // the number of state change messages sent to bound SwiftUI Views, thus reducing the number of
    // times the view hierarchy must be re-constructed.
    //
    let throttler = PassthroughSubject<SUIMapViewModel, Never>()
    
    // MARK:- Publishable AGSMapView
    
    private let mapView = AGSMapView(frame: .zero)
    
    // The Publisher is a tool that configures with an `AGSMapView` and
    // observes all properties of the map view and publishes the changes via a Combine Subject.
    // Additionally, the Publisher wraps all methods, particularly, creating Combine Publishers of all async methods.
    //
    private(set) lazy var publishable: Publishable<AGSMapView> = { self.mapView.publishable }()
}

extension SUIMapViewModel {
    
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
            publishable.adjustedContentInset
                .sink { (inset) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.attributionText) {
            publishable.attributionText
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.isAttributionTextVisible) {
            publishable.isAttributionTextVisible
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.contentInset) {
            publishable.contentInset
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.drawStatus) {
            publishable.drawStatus
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.graphicsOverlays) {
            publishable.graphicsOverlays
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.insetsContentInsetFromSafeArea) {
            publishable.insetsContentInsetFromSafeArea
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        #warning("Is this a good solution for nested bindings?")
        if bindings.contains(.interactionOptions) {
            publishable.interactionOptions
                .sink { (interactionOptions) in
                    interactionOptions.publishable
                        .any()
                        .sink { (_) in self.throttler.send(self) }
                        .store(in: &self.subscriptions)
                    self.throttler.send(self)
                }
                .store(in: &subscriptions)
        }
        
        #warning("Consider building binding to property changes to (optional) locationDispaly itself.")
        if bindings.contains(.locationDisplay) {
            publishable.locationDisplay
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.map) {
            publishable.map
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.mapScale) {
            publishable.mapScale
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.isNavigating) {
            publishable.isNavigating
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.rotation) {
            publishable.rotation
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.selectionProperties) {
            publishable.selectionProperties
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.sketchEditor) {
            publishable.sketchEditor
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.spatialReference) {
            publishable.spatialReference
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.timeExtent) {
            publishable.timeExtent
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.unitsPerPoint) {
            publishable.unitsPerPoint
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
        
        if bindings.contains(.visibleArea) {
            publishable.visibleArea
                .sink { (_) in self.throttler.send(self) }
                .store(in: &subscriptions)
        }
    }
}

// Expose properties of mapView via view model.
extension SUIMapViewModel {
    
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
