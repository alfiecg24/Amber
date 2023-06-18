//
//  MainView.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI
import FilePicker
import UniformTypeIdentifiers
import ApplicationsWrapper


let manager = ApplicationsManager.shared

struct MainView: View {
    @State private var image = UIImage(systemName: "gear")
    @State private var applications = manager.allApps
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var searchTerm = ""
    var body: some View {
        NavigationView {
            ZStack {
                if applications.count > 0 {
                    List {
                        ForEach(searchTerms, id: \.self) { app in
                            NavigationLink(destination: {
                                ApplicationDetailView(app: app)
                            }, label: {
                                HStack {
                                    Image(uiImage: manager.icon(forApplication: app))
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .cornerRadius(12)
                                        .padding(.trailing)
                                    VStack(alignment: .leading) {
                                        Text(app.localizedName())
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                        Text(app.applicationIdentifier())
                                            .font(.callout)
                                            .fontWeight(.regular)
                                            .fontDesign(.rounded)
                                    }
                                }
                            })
                        }
                    }
                    // Cannot have because it causes large gap at top of detail view
                    .searchable(text: $searchTerm, prompt: "Search by name or bundle ID")
                } else {
                    VStack {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 125, height: 125)
                            .foregroundColor(.mainColor)
                            .padding(.bottom)
                        Text("You have no installed apps!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .multilineTextAlignment(.center)
                        Text("Press the button in the toolbar\nto select an app to install.")
                            .font(.body)
                            .fontWeight(.regular)
                            .fontDesign(.rounded)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationTitle("All apps")
            .navigationBarTitleDisplayMode((idiom == .pad) ? .large : .inline)
            // TODO: Figure out how to force .columns on iPad
            .navigationViewStyle(.automatic)
            .toolbar {
                ToolbarItem {
                    FilePicker(types: [UTType(filenameExtension: "ipa")!, UTType(filenameExtension: "app")!], allowMultiple: false) { urls in
                        print("Selected \(urls.count) files")
//                        do {
////                            let newApp = try handleApplicationImport(urls[0])
////                            withAnimation(.easeIn) {
////                                applications.append(newApp)
////
////                            }
//                            let _ = try! getAppsInstalledWithAmber()
//                        } catch let e {
//                            print("ERROR: \(e.localizedDescription)")
//                        }
                    } label: {
                        Label("Install app", systemImage: "plus.circle")
                            .foregroundColor(.mainColor)
                    }
                }
            }
            .onAppear {
                applications.sort(by: { $0.localizedName().lowercased() < $1.localizedName().lowercased() })
            }
        }
    }
    var searchTerms: [LSApplicationProxy] {
        if searchTerm.isEmpty {
            return applications
        } else {
            return applications.filter { $0.localizedName().lowercased().contains(searchTerm.lowercased()) || $0.applicationIdentifier().lowercased().contains(searchTerm.lowercased()) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
