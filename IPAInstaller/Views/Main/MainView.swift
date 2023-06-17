//
//  MainView.swift
//  IPAInstaller
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
    var body: some View {
        NavigationView {
            ZStack {
                if applications.count > 0 {
                    List {
                        ForEach(applications, id: \.self) { app in
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
            .toolbar {
                ToolbarItem {
                    FilePicker(types: [UTType(filenameExtension: "ipa")!, UTType(filenameExtension: "app")!], allowMultiple: false) { urls in
                        print("Selected \(urls.count) files")
                        do {
                            let newApp = try handleApplicationImport(urls[0])
                            withAnimation(.easeIn) {
                                applications.append(newApp)
                                
                            }
                        } catch let e {
                            print("ERROR: \(e.localizedDescription)")
                        }
                    } label: {
                        Label("Install app", systemImage: "plus.circle")
                            .foregroundColor(.mainColor)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
