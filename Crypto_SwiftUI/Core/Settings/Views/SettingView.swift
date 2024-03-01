////
////  SettingView.swift
////  Crypto_SwiftUI
////
////  Created by Vishal on 10/02/24.
////
//
//import SwiftUI
//
//struct SettingView: View {
//
//    @Binding var isPresented: Bool
//    let linkedinURL = URL(string: "https://www.linkedin.com/in/raees-shaikh-407954215/")
//    let portfolioURL = URL(string: "https://raees-shaikh-porfolio.netlify.app/#")
//    let companyURL = URL(string: "https://reapmind.com")
//    let coingeckoURL = URL(string: "https://www.coingecko.com")
//    let githubURL = URL(string: "https://github.com/RaeesShaikh4")
//    let defaultURL = URL(string: "https://www.google.com")
//
//      @State private var isProfilePresented = false
//
//    var body: some View {
//        NavigationView {
//            List {
//                mainSection
//                coingeckoSection
//                developerSection
//                applicationSection
//            }
//            .font(.headline)
//            .accentColor(.blue)
//            .listStyle(GroupedListStyle())
//            .navigationTitle("Settings")
//
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    XMarkButton(isPresented: $isPresented)
//                }
//
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    ProfileButton(isProfilePresented: $isProfilePresented)
//                }
//            }
//        }
//    }
//}
//
//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView(isPresented: .constant(false))
//    }
//}
//
//extension SettingView {
//
//    private var mainSection: some View {
//        Section(header: Text("Crypto Khan")) {
//            VStack(alignment: .leading) {
//                Image("logo")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                Text("This app is made to fetch real-time data of crypto currency.used swiftUI for app creation.It uses MVVM architecture, Combine and Alamofire.")
//                    .font(.callout)
//                    .fontWeight(.medium)
//                    .foregroundColor(Color.theme.accent)
//            }
//            .padding(.vertical)
//            Link("Reach my Github 🥳", destination: githubURL!)
//            Link("About my Work Space 🏢", destination: companyURL!)
//        }
//    }
//
//    private var coingeckoSection: some View {
//        Section(header: Text("CoinGecko")) {
//            VStack(alignment: .leading) {
//                Image("coingecko")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                Text("The cryptocurrency data that is used in this app fetched from a public API by CoinGecko! CoinGecko provides a fundamental analysis of the crypto market. In addition to tracking price, volume and market capitalisation, CoinGecko tracks community growth, major events and on-chain metrics.")
//                    .font(.callout)
//                    .fontWeight(.medium)
//                    .foregroundColor(Color.theme.accent)
//            }
//            .padding(.vertical)
//            Link("Reach CoinGecko 🦎", destination: coingeckoURL!)
//        }
//    }
//
//    private var developerSection: some View {
//        Section(header: Text("Developer")) {
//            VStack(alignment: .leading) {
//                Image("logo") // put personal photo here
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                Text("This app is developed by Raees Shaikh an ios developer intern at Reapmind innovations. this projects from multi-threading, publishers/subscribers and data persistance.")
//                    .font(.callout)
//                    .fontWeight(.medium)
//                    .foregroundColor(Color.theme.accent)
//            }
//            .padding(.vertical)
//            Link("Reach my Portfolio 👨🏻‍💻", destination: portfolioURL!)
//            Link("Connect to Linkedin 👨🏻‍💼", destination: linkedinURL!)
//        }
//    }
//
//    private var applicationSection: some View {
//        Section(header: Text("Application")) {
//            Link("Terms of Service", destination: defaultURL!)
//            Link("Privacy Policy", destination: defaultURL!)
//            Link("Learn More", destination: defaultURL!)
//        }
//    }
//}


import SwiftUI

struct SettingView: View {
    
    @Binding var isPresented: Bool
    let linkedinURL = URL(string: "https://www.linkedin.com/in/raees-shaikh-407954215/")
    let portfolioURL = URL(string: "https://raees-shaikh-porfolio.netlify.app/#")
    let companyURL = URL(string: "https://reapmind.com")
    let coingeckoURL = URL(string: "https://www.coingecko.com")
    let githubURL = URL(string: "https://github.com/RaeesShaikh4")
    let defaultURL = URL(string: "https://www.google.com")
    
    @State private var isProfilePresented = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            List {
                mainSection
                coingeckoSection
                developerSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Home")
                    }
                    .foregroundColor(Color.theme.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ProfileButton(isProfilePresented: $isProfilePresented)
                }
            }
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(isPresented: .constant(false))
    }
}

extension SettingView {
    
    private var mainSection: some View {
        Section(header: Text("Crypto Khan")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is made to fetch real-time data of crypto currency.used swiftUI for app creation.It uses MVVM architecture, Combine and Alamofire.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Reach my Github 🥳", destination: githubURL!)
            Link("About my Work Space 🏢", destination: companyURL!)
        }
    }
    
    private var coingeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app fetched from a public API by CoinGecko! CoinGecko provides a fundamental analysis of the crypto market. In addition to tracking price, volume and market capitalisation, CoinGecko tracks community growth, major events and on-chain metrics.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Reach CoinGecko 🦎", destination: coingeckoURL!)
        }
    }
    
    private var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("logo") // put personal photo here
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is developed by Raees Shaikh an ios developer intern at Reapmind innovations. this projects from multi-threading, publishers/subscribers and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Reach my Portfolio 👨🏻‍💻", destination: portfolioURL!)
            Link("Connect to Linkedin 👨🏻‍💼", destination: linkedinURL!)
        }
    }
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: defaultURL!)
            Link("Privacy Policy", destination: defaultURL!)
            Link("Learn More", destination: defaultURL!)
        }
    }
}
