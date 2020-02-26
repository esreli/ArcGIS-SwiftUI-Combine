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

import SwiftUI

struct RoundedCornerImageView: View {
    
    var image: Image
    var width: CGFloat
    var height: CGFloat
    var radius: CGFloat
    
    init(image: Image, width: CGFloat, height: CGFloat, radius: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
        self.radius = radius
    }
    
    var body: some View {
        return image
            .resizable()
            .frame(width: width-1, height: height-1, alignment: .center)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(Overlay)
            .shadow(radius: 2)
    }
    
    var Overlay: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(Color.white, lineWidth: 1)
            .frame(width: width, height: height, alignment: .center)
    }
}