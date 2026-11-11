//
//  MapContainerView.swift
//  FindMyCharity
//

import SwiftUI
import MapKit

struct MapContainerView: View {
    
    @Environment(MapViewModel.self) private var viewModel
    
    @State private var selectedCause: CharityCause? = nil
    @State private var selectedCountry: String = ""
    @State private var isSearchExpanded: Bool = false
    @State private var hasSearched: Bool = false
    @State private var showCharityList: Bool = false
    
    let countries = [
        "", "Afghanistan", "Bangladesh", "Brazil", "Cambodia", "Cameroon", "Canada",
        "China", "Colombia", "Congo", "Ecuador", "Egypt", "Ethiopia", "France",
        "Germany", "Ghana", "Guatemala", "Haiti", "Honduras", "India", "Indonesia",
        "Iraq", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kenya", "Liberia",
        "Malawi", "Malaysia", "Mali", "Mexico", "Morocco", "Mozambique", "Myanmar",
        "Nepal", "Nicaragua", "Niger", "Nigeria", "Pakistan", "Palestine", "Panama",
        "Paraguay", "Peru", "Philippines", "Rwanda", "Senegal", "Sierra Leone",
        "Somalia", "South Africa", "South Sudan", "Spain", "Sri Lanka", "Sudan",
        "Syria", "Tanzania", "Thailand", "Togo", "Turkey", "Uganda", "Ukraine",
        "United Kingdom", "United States", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"
    ].sorted()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack(alignment: .top) {
            CharityMapView()
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 12) {
                VStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            isSearchExpanded.toggle()
                            showCharityList = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            Text(searchBarText)
                                .foregroundColor(hasSearched ? .primary : .gray)
                            
                            Spacer()
                            
                            Image(systemName: isSearchExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(isSearchExpanded ? 12 : 25)
                    }
                    .buttonStyle(.plain)
                    
                    if isSearchExpanded {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Cause")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Menu {
                                        Button("All Causes") { selectedCause = nil }
                                        ForEach(CharityCause.allCases, id: \.self) { cause in
                                            Button(cause.rawValue) { selectedCause = cause }
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedCause?.rawValue ?? "All Causes")
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Country")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Menu {
                                        Button("All Countries") { selectedCountry = "" }
                                        ForEach(countries.filter { !$0.isEmpty }, id: \.self) { country in
                                            Button(country) { selectedCountry = country }
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedCountry.isEmpty ? "All Countries" : selectedCountry)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            Button(action: {
                                search()
                                withAnimation(.spring(response: 0.3)) {
                                    isSearchExpanded = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text("Find Charities")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                if hasSearched && !isSearchExpanded {
                    let count = viewModel.filteredCharities.count
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            showCharityList.toggle()
                        }
                    }) {
                        HStack {
                            Text("\(count) charit\(count == 1 ? "y" : "ies") found")
                                .font(.subheadline.bold())
                            Image(systemName: showCharityList ? "chevron.up" : "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(count > 0 ? Color.green.opacity(0.9) : Color.orange.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                
                if showCharityList && hasSearched {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredCharities) { charity in
                                CharityListCard(charity: charity)
                                    .onTapGesture {
                                        viewModel.selectCharity(charity)
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .frame(maxHeight: 400)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                Spacer()
            }
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading charities...")
                            .font(.headline)
                        Text("This may take a moment")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetail) {
            if let charity = viewModel.selectedCharity {
                CharityDetailView(charity: charity)
                    .presentationDetents([.medium, .large])
            }
        }
        .task {
            await viewModel.loadCharities()
        }
    }
    
    private var searchBarText: String {
        if !hasSearched {
            return "Find charities..."
        }
        var parts: [String] = []
        if let cause = selectedCause {
            parts.append(cause.rawValue)
        }
        if !selectedCountry.isEmpty {
            parts.append(selectedCountry)
        }
        if parts.isEmpty {
            return "All charities"
        }
        return parts.joined(separator: " in ")
    }
    
    private func search() {
        hasSearched = true
        showCharityList = false
        viewModel.filterCharities(cause: selectedCause, country: selectedCountry)
    }
}

struct CharityListCard: View {
    let charity: Charity
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(charity.cause.color)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: charity.cause.iconName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(charity.name)
                    .font(.subheadline.bold())
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(charity.locationString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(charity.cause.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(charity.cause.color.opacity(0.2))
                    .foregroundColor(charity.cause.color)
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MapContainerView()
        .environment(MapViewModel())
}
