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

struct SUIMapView : View {
    
    let mapView: AGSMapView
    
    var body: some View {
        
        WrappedMapView(
        setup: {
            return self.mapView
        },
        update: { (mapView) in
            mapView.touchDelegate = self.touchCoordinator
        })
    }
    
    private let touchCoordinator = ArcGISMapViewTouchDelegateCoordinator()
}

// MARK:- ArcGISMapViewTouchDelegateCoordinator

extension SUIMapView {
    
    typealias ChangeForceTouchAtClosure = (CGPoint, AGSPoint, Double) -> Void

    func didChangeForceTouchAt(_ closure: @escaping ChangeForceTouchAtClosure) -> Self {
        touchCoordinator.changeForceTouchAt = closure
        return self
    }

    typealias DoubleTapAtClosure = (CGPoint, AGSPoint) -> Bool

    func didDoubleTapAt(_ closure: @escaping DoubleTapAtClosure) -> Self {
        touchCoordinator.doubleTap = closure
        return self
    }

    typealias EndForceTouchAtClosure = (CGPoint, AGSPoint, Double) -> Void

    func didEndForceTouchAt(_ closure: @escaping EndForceTouchAtClosure) -> Self {
        touchCoordinator.endForceTouch = closure
        return self
    }

    typealias EndLongPressAtClosure = (CGPoint, AGSPoint) -> Void

    func didEndLongPressAt(_ closure: @escaping EndLongPressAtClosure) -> Self {
        touchCoordinator.endLongPress = closure
        return self
    }

    typealias ForceTouchAtClosure = (CGPoint, AGSPoint, Double) -> Void

    func didForceTouchAt(_ closure: @escaping ForceTouchAtClosure) -> Self {
        touchCoordinator.forceTouch = closure
        return self
    }

    typealias LongPressAtClosure = (CGPoint, AGSPoint) -> Void

    func didLongPressAt(_ closure: @escaping LongPressAtClosure) -> Self {
        touchCoordinator.longPress = closure
        return self
    }

    typealias MoveLongPressAtClosure = (CGPoint, AGSPoint) -> Void

    func didMoveLongPressAt(_ closure: @escaping MoveLongPressAtClosure) -> Self {
        touchCoordinator.moveLongPress = closure
        return self
    }

    typealias TapAtClosure = (CGPoint, AGSPoint) -> Void

    func didTapAt(_ closure: @escaping TapAtClosure) -> Self {
        touchCoordinator.tap = closure
        return self
    }

    typealias TouchDownAtClosure = (CGPoint, AGSPoint) -> Bool

    func didTouchDownAt(_ closure: @escaping TouchDownAtClosure) -> Self {
        touchCoordinator.touchDown = closure
        return self
    }

    typealias TouchDragToClosure = (CGPoint, AGSPoint) -> Void

    func didTouchDragTo(_ closure: @escaping TouchDragToClosure) -> Self {
        touchCoordinator.touchDrag = closure
        return self
    }

    typealias TouchUpAtClosure = (CGPoint, AGSPoint) -> Void

    func didTouchUpAt(_ closure: @escaping TouchUpAtClosure) -> Self {
        touchCoordinator.touchUp = closure
        return self
    }

    typealias CancelForceTouchClosure = () -> Void

    func didCancelForceTouch(_ closure: @escaping CancelForceTouchClosure) -> Self {
        touchCoordinator.cancelForceTouch = closure
        return self
    }

    typealias CancelLongPressClosure = () -> Void

    func didCancelLongPress(_ closure: @escaping CancelLongPressClosure) -> Self {
        touchCoordinator.cancelLongPress = closure
        return self
    }

    typealias CancelTouchDragClosure = () -> Void

    func didCancelTouchDrag(_ closure: @escaping CancelTouchDragClosure) -> Self {
        touchCoordinator.cancelTouchDrag = closure
        return self
    }
}

private final class ArcGISMapViewTouchDelegateCoordinator : NSObject, AGSGeoViewTouchDelegate {
    
    var changeForceTouchAt: SUIMapView.ChangeForceTouchAtClosure?

    func geoView(_ geoView: AGSGeoView, didChangeForceTouchAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, force: Double) {
        changeForceTouchAt?(screenPoint, mapPoint, force)
    }

    var doubleTap: SUIMapView.DoubleTapAtClosure?

    func geoView(_ geoView: AGSGeoView, didDoubleTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, completion: @escaping (Bool) -> Void) {
        if let closure = doubleTap {
            let willHandle = closure(screenPoint, mapPoint)
            completion(willHandle)
        }
        else {
            completion(false)
        }
    }

    var endForceTouch: SUIMapView.EndForceTouchAtClosure?

    func geoView(_ geoView: AGSGeoView, didEndForceTouchAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, force: Double) {
        endForceTouch?(screenPoint, mapPoint, force)
    }

    var endLongPress: SUIMapView.EndLongPressAtClosure?

    func geoView(_ geoView: AGSGeoView, didEndLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        endLongPress?(screenPoint, mapPoint)
    }

    var forceTouch: SUIMapView.ForceTouchAtClosure?

    func geoView(_ geoView: AGSGeoView, didForceTouchAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, force: Double) {
        forceTouch?(screenPoint, mapPoint, force)
    }

    var longPress: SUIMapView.LongPressAtClosure?

    func geoView(_ geoView: AGSGeoView, didLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        longPress?(screenPoint, mapPoint)
    }

    var moveLongPress: SUIMapView.MoveLongPressAtClosure?

    func geoView(_ geoView: AGSGeoView, didMoveLongPressToScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        moveLongPress?(screenPoint, mapPoint)
    }
    
    var tap: SUIMapView.TapAtClosure?
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        tap?(screenPoint, mapPoint)
    }
    
    var touchDown: SUIMapView.TouchDownAtClosure?

    func geoView(_ geoView: AGSGeoView, didTouchDownAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, completion: @escaping (Bool) -> Void) {
        if let closure = touchDown {
            let willHandle = closure(screenPoint, mapPoint)
            completion(willHandle)
        }
        else {
            completion(false)
        }
    }

    var touchDrag: SUIMapView.TouchDragToClosure?

    func geoView(_ geoView: AGSGeoView, didTouchDragToScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        touchDrag?(screenPoint, mapPoint)
    }

    var touchUp: SUIMapView.TouchUpAtClosure?

    func geoView(_ geoView: AGSGeoView, didTouchUpAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        touchUp?(screenPoint, mapPoint)
    }

    var cancelForceTouch: SUIMapView.CancelForceTouchClosure?

    func geoViewDidCancelForceTouch(_ geoView: AGSGeoView) {
        cancelForceTouch?()
    }

    var cancelLongPress: SUIMapView.CancelLongPressClosure?

    func geoViewDidCancelLongPress(_ geoView: AGSGeoView) {
        cancelLongPress?()
    }

    var cancelTouchDrag: SUIMapView.CancelTouchDragClosure?

    func geoViewDidCancelTouchDrag(_ geoView: AGSGeoView) {
        cancelTouchDrag?()
    }
}

private final class WrappedMapView : UIViewRepresentable {
    
    typealias SetupClosure = () -> AGSMapView
    typealias UpdateClosure = (AGSMapView) -> Void
    
    private let setup : SetupClosure
    private let update : UpdateClosure
    
    init(setup: @escaping SetupClosure, update: @escaping UpdateClosure) {
        self.setup = setup
        self.update = update
    }
    
    // MARK: UIViewRepresentable
    
    // As an optimization technique, SwiftUI calls this function only once per `WrappedMapView`.
    func makeUIView(context: UIViewRepresentableContext<WrappedMapView>) -> AGSMapView {
        return setup()
    }
    
    // This function is called every time `WrappedMapView` is initialized,
    // i.e. every time the View hierarchy is (re)constructed.
    func updateUIView(_ uiView: AGSMapView, context: Context) {
        update(uiView)
    }
}


