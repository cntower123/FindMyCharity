//
//  CharityMapView.swift
//  FindMyCharity
//

import SwiftUI
import MapKit

struct CharityMapView: View {
    
    @Environment(MapViewModel.self) private var viewModel
    @Namespace private var mapScope
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Map(position: $viewModel.cameraPosition, scope: mapScope) {
            ForEach(viewModel.filteredCharities) { charity in
                Annotation(charity.name, coordinate: charity.coordinate) {
                    Circle()
                        .fill(charity.cause.color)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                        .shadow(radius: 2)
                        .onTapGesture {
                            viewModel.selectCharity(charity)
                        }
                }
            }
        }
        .mapStyle(.standard)
        .mapScope(mapScope)
        .onAppear {
            print("🗺️ Map appeared. Charities count: \(viewModel.filteredCharities.count)")
        }
    }
}

#Preview {
    CharityMapView()
        .environment(MapViewModel())
}
