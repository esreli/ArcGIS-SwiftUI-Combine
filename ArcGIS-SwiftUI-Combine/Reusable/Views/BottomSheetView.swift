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

//
//  BottomSheetView.swift
//
//  With initial inspiration derived from Majid Jabrayilov (@mecid)
//  https://gist.github.com/mecid/78eab34d05498d6c60ae0f162bfd81ee
//

import SwiftUI
import ArcGIS

// https://github.com/guillermomuntaner/Burritos/blob/master/Sources/Clamping/Clamping.swift
@propertyWrapper
private struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>
    
    public init(wrappedValue: Value, range: ClosedRange<Value>) {
        self.range = range
        self.value = range.clamp(wrappedValue)
    }
    
    public var wrappedValue: Value {
        get { value }
        set { value = range.clamp(newValue) }
    }
}

fileprivate extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}

private struct Constants {
    static let topBuffer: CGFloat = 4
    static let indicatorCornerRadius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let titleBarEdgeInsets: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16)
}

enum BottomSheetViewPosition {
    
    case full
    case partial
    case off

    var tap: BottomSheetViewPosition {
        switch self {
        case .full: return .partial
        case .partial: return .full
        case .off: return .off
        }
    }
}

struct BottomSheetView<Content: View>: View {
    
    @Binding var title: String
    
    typealias ContentView = () -> Content
    private let content: ContentView
    private var tapClose : (() -> Void)?
    
    init(position: Binding<BottomSheetViewPosition>, title: Binding<String>, partialMultiplier: CGFloat = 0.5, tapClose: (() -> Void)? = nil, @ViewBuilder content: @escaping ContentView) {
        self._position = position
        self._title = title
        self.content = content
        self.tapClose = tapClose
        self.partialMultiplier = partialMultiplier
    }
    
    // MARK:- Position
    
    @Binding var position : BottomSheetViewPosition
    
    @Clamping(range: 0.0...1.0) private var partialMultiplier: CGFloat = 0.5

    private func currentPositionOffset(height: CGFloat) -> CGFloat {
        positionOffset(position: position, height: height)
    }
    
    private func positionOffset(position: BottomSheetViewPosition, height: CGFloat) -> CGFloat {
        switch position {
        case .full: return Constants.topBuffer
        case .partial: return height * (1.0 - partialMultiplier)
        case .off: return height + 20.0
        }
    }
    
    // MARK:- Translation
    
    @GestureState private var translation: CGFloat = 0
    
    private func currentTranslatedOffset(height: CGFloat) -> CGFloat {
        max(currentPositionOffset(height: height) + translation, Constants.topBuffer)
    }
    
    // MARK:- View

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.topMatter
                self.content()
                    .disabled(self.position != .full)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .background(
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: self.currentTranslatedOffset(height: geometry.size.height))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture()
                    .updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        DispatchQueue.main.async {
                            self.dragGestureEnded(translation: value.predictedEndTranslation.height, height: geometry.size.height)
                        }
                    }
            )
        }
    }
    
    private var topMatter : some View {
        VStack {
            self.indicator
            self.titleBar
        }
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.indicatorCornerRadius)
            .fill(Color.secondary)
            .frame(width: Constants.indicatorWidth, height: Constants.indicatorHeight)
            .onTapGesture { self.position = self.position.tap }
            .padding(Constants.indicatorHeight)
    }
    
    private var titleBar: some View {
        HStack(alignment: .center, spacing: 8){
            Text(title)
                .font(.headline)
            Spacer()
            Button(action: { self.tapClose?(); self.position = .off }) {
                Image(systemName: "xmark.circle.fill")
            }
        }
        .padding(Constants.titleBarEdgeInsets)
    }
    
    // MARK:- Drag Gesture
    
    private func dragGestureEnded(translation: CGFloat, height: CGFloat) {
        let startingTranslation = currentPositionOffset(height: height)
        let delta = startingTranslation + translation
        let partialDelta = abs(delta - positionOffset(position: .partial, height: height))
        let fullDelta = abs(delta - positionOffset(position: .full, height: height))
        if partialDelta < fullDelta {
            self.position = .partial
        }
        else if fullDelta <= partialDelta {
            self.position = .full
        }
    }
}
