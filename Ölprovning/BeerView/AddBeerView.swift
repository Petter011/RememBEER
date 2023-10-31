




import SwiftUI
import PhotosUI
import Foundation

struct AddBeerView: View {
    @State private var beerNote: String = ""
    @State private var beerType: String = ""
    @State private var beerWho: String = ""
    @State private var beerName: String = ""
    @State private var beerPoints: Int16 = 0
    @State private var beerPointsOptions: [Int16] = Array(0...100)
    @State private var beerImageData: Data?
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var globalParticipantNames: [String] = UserDefaults.standard.stringArray(forKey: "participantNames") ?? []
    
    let onSave: (BeerWithImage, String) -> Void
    
    @Binding var selectedBeerType: String?
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    
                    
                    TextField("Which type of beer", text: $beerType)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .onSubmit {
                            
                            beerType = beerType.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    
                    TextField("Name of the beer", text: $beerName)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                    
                    TextField("Add a Note", text: $beerNote, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .lineLimit(3, reservesSpace: true)
                    
                    
                    /*VStack{
                        VStack(alignment: .center) {
                            Text("Vems öl")
                                .bold()
                                .foregroundColor(Color.black)
                                .underline()
                            
                            
                            Picker("Vems öl", selection: $beerWho) {
                                ForEach(globalParticipantNames, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.wheel)
                            
                        }
                    }*/
                    
                    
                    VStack{
                        VStack(alignment: .center) {
                            Text("Points (0-100)")
                                .bold()
                                .foregroundColor(Color.black)
                                .underline()
                            Picker("Points (0-100)", selection: $beerPoints) {
                                ForEach(beerPointsOptions, id: \.self) {
                                    
                                        Text("\($0)")
                                    
                                }
                            }
                            
                            .pickerStyle(.wheel) 
                            .onAppear {
                                // Set the initial value to 51
                                beerPoints = 50
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                if !selectedImages.isEmpty {
                    VStack(spacing: 100) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                }
                
                Button("Take a picture") {
                    showingImagePicker.toggle()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: 140)
                .padding()
                .background(Color.orange)
                .cornerRadius(20)
                .shadow(radius: 40)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImages: $selectedImages, sourceType: .camera) // Pass the array binding
                }
                
                Button("Save") {
                    if let firstImage = selectedImages.first,
                       let imageData = firstImage.jpegData(compressionQuality: 1.0) {
                        let newBeer = BeerWithImage(beerType: beerType, beerWho: beerWho, beerPoints: beerPoints, beerName: beerName, beerImageData: imageData, beerNote: beerNote)
                        
                        onSave(newBeer, beerType) // Call the onSave closure to save the new beer
                        isPresented = false
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: 140)
                .padding()
                .background(Color.orange)
                .cornerRadius(20)
                .shadow(radius: 40)
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitle("Add new beer", displayMode: .inline)
        }
        
    }
    
}


                               
                    
                    
  
