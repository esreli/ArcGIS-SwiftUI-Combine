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
import SwiftUI
import Combine

class MapViewModel: SUIMapViewModel {
    
    let scalebarHeight: CGFloat = 22.0
    
    init(map: AGSMap) {
        // 1. Ask for only some state changes.
        super.init(bindings: [.map, .adjustedContentInset])
        
        // 2. Set map.
        self.map = map
        
        // 3. Build map view identify stream.
        mapViewIdentify
            .throttle(for: 1.0, scheduler: RunLoop.main, latest: true)
            .flatMap { (point) in
                self.publishable
                    .identifyLayersAt(point, tolerance: 8, returnPopupsOnly: true)
                    .map { (results) in return results.first?.popups.first }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.popup = nil
                    self.errorMessage = error.localizedDescription
                    break
                case .finished:
                    break
                }
            }) { (popup) in self.popup = popup }
            .store(in: &subscriptions)
        
        // 4. Inset the content giving space for the Scalebar.
        self.contentInset = AGSEdgeInsets(top: 0.0, left: 0.0, bottom: scalebarHeight, right: 0.0)
    }
    
    // MARK:- Compass
    
    private(set) lazy var compassViewModel: CompassViewModel = { CompassViewModel(mapView: publishable.base) }()

    // MARK:- Identify Pop-up

    @Published var popup: AGSPopup?
    
    private let mapViewIdentify = PassthroughSubject<CGPoint, Error>()
    
    func identifyFeatures(for point: CGPoint) {
        mapViewIdentify.send(point)
    }
    
    func clearPopup() {
        popup = nil
    }
    
    // MARK: - Error
    
    #warning("TODO. Currently unused")
    @Published var errorMessage: String?
    
    // MARK: - Disposable
    
    private var subscriptions = Set<AnyCancellable>()
}

struct MapView : View {
    
    @ObservedObject var model: MapViewModel

    @State var popup: AGSPopup? = nil {
        willSet {
            popup?.deselect()
        }
        didSet {
            popup?.select()
        }
    }
    
    @State var popupTitle: String = "Pop-up"
    
    @State var position : BottomSheetViewPosition = .off
    
    init(map: AGSMap) {
        self.model = MapViewModel(map: map)
    }
    
    var body: some View {
        ZStack {
            MapView
            Compass
            Scalebar
            BottomSheet
        }
        .navigationBarTitle(Text(model.map?.item?.title ?? "Map"), displayMode: .inline)
        .navigationBarItems(trailing: legendButton)
        .onReceive(model.$popup) { (popup) in
            self.popup = popup
            self.popupTitle = popup?.title ?? "Pop-up"
            self.position = popup != nil ? .partial : .off
        }
        .sheet(isPresented: $showLegend) {
            self.Legend
        }
    }
    
    var MapView : some View {
        SUIMapView(viewModel: model)
            .didTapAt { (screenPoint, _) in
                self.model.identifyFeatures(for: screenPoint)
            }
            .edgesIgnoringSafeArea([.all])
    }
    
    var Compass : some View {
        VStack {
            HStack {
                Spacer()
                CompassView(model: model.compassViewModel)
                    .frame(width: 38, height: 38, alignment: .center)
                    .padding()
            }
            .frame(alignment: .topTrailing)
            Spacer()
        }
        .frame(alignment: .topTrailing)
    }
    
    var Scalebar : some View {
        VStack {
            Spacer()
            SUIScalebar(mapView: self.model.publishable.base, units: .imperial, style: .alternatingBar, alignment: .left)
                .padding()
                .frame(height: model.scalebarHeight)
        }
        .frame(alignment: .bottom)
    }
    
    var BottomSheet : some View {
        BottomSheetView(position: $position, title: $popupTitle, partialMultiplier: 0.35, tapClose: { self.model.clearPopup() }) {
            if self.popup != nil {
                PopupView(popup: self.popup!)
            }
        }
        .edgesIgnoringSafeArea([.bottom])
    }
    
    // MARK: - Legend
    
    @State var showLegend = false
    
    var legendButton : some View {
        Button(action: toggleLegend) {
            Image(systemName: "list.bullet")
        }
    }
    
    private func toggleLegend() {
        showLegend.toggle()
    }
    
    var Legend : some View {
        NavigationView {
            SUILegendView(geoView: self.model.publishable.base)
                .navigationBarTitle("Legend")
                .navigationBarItems(trailing: Button(action: toggleLegend, label: { Text("Dismiss") }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color("Accent"))
    }
}
