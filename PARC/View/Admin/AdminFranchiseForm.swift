//
//  AdminFranchiseForm.swift
//  PARC
//
//  Created by Ayman Ali on 06/11/2023.
//

import SwiftUI

struct AdminFranchiseForm: View {
    @State var name = ""
    @State var logo = ""
    @State var description = ""
    @State var noOfFranchises = ""
    @State var MoMRevenue = ""
    @State var startupCapital = ""
    @State var monthRev18 = ""
    @State var ebitdaEstimate = ""
    @State var isDescriptionValid = false
    @State var showLogoImagePicker = false
    @State var showDisplayImagePicker = false
    @State var logo_image: UIImage?
    @State var display_image: UIImage?
    @Binding var franchise_form_shown: Bool
    @Binding var franchise_data: [DropdownMenuOption]
    
    var body: some View {
        
            GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            HStack {
                                Text("Create Franchise")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                    .padding(.bottom, -5).padding(.top, 10)
                                Spacer()
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                                .padding(.bottom, 5)
                            
                            HStack {
                                Text("Name").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.bottom, -5).padding(.leading,2.5)
                                
                                Spacer()
                            }
                            
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: max(0, geometry.size.width - 45), height: 50)
                                    
                                    TextField("", text: $name, prompt: Text("McDonald's").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                        .foregroundColor(.black)
                                        .cornerRadius(5)
                                        .font(Font.custom("Nunito-SemiBold", size: 16))
                                }
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Logo")
                                        
                                        if let image = self.logo_image {
                                            Text("✅")
//                                                .onAppear {
//                                                     CreateDB().upload_logo_image(image: image)
//                                                    print(text)
//                                                }
                                        }
                                        Spacer()
                                    }
                                    .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                                    .font(Font.custom("Nunito-Bold", size: 18))
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 1.25)
                                            )
                                            .frame(width: max(0, geometry.size.width - 250), height: 50)
                                        
                                        Button(action: { showLogoImagePicker.toggle() }) {
                                            HStack {
                                                Text("Upload")
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                            }
                                            .frame(width: max(0, geometry.size.width - 250), height: 50)
                                            .cornerRadius(5)
                                        }
                                    }
                                    .padding(.leading, 2.5)
                                }
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Display Image")
                                        
                                        if let image = self.display_image {
                                            Text("✅")
//                                                .onAppear {
//                                                    CreateDB().uploadFranchiseLogoImage(image: image)
//                                                }
                                        }
                                        Spacer()
                                    }
                                    .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                                    .font(Font.custom("Nunito-Bold", size: 18))
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 1.25)
                                            )
                                            .frame(width: max(0, geometry.size.width - 250), height: 50)
                                        
                                        Button(action: { showDisplayImagePicker.toggle() }) {
                                            HStack {
                                                Text("Upload")
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                            }
                                            .frame(width: max(0, geometry.size.width - 250), height: 50)
                                            .cornerRadius(5)
                                        }
                                    }
                                }
                                
                            }
                            HStack {
                                Text("Description").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                                Spacer()
                            }
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width-45), height: 100)
                                
                                TextEditor(text: $description)
                                    .padding([.horizontal, .bottom], 12).padding(.top, 5).padding(.bottom, 25)
                                    .frame(width: max(0, geometry.size.width-45), height: 100)
                                    .scrollContentBackground(.hidden)
                                    .cornerRadius(5)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                                    .onChange(of: self.description, perform: { value in
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            validateDescriptionCount(value: value)
                                        }
                                        
                                        if value.count > 180 {
                                            self.description = String(value.prefix(180))
                                        }
                                    })
                                
                                if description.count == 0 {
                                    Text("This is a great franchise")
                                        .foregroundColor(.gray)
                                        .font(Font.custom("Nunito-Medium", size: 16))
                                        .padding([.top, .leading], 15)
                                }
                                
                                if isDescriptionValid {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                
                                                if description.count >= 150 {
                                                    Text("\(180 - description.count)")
                                                        .foregroundColor(.red)
                                                        .font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                                } else {
                                                    Text("\(180 - description.count)")
                                                        .foregroundColor(.black)
                                                        .font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                                }
                                            }
                                            .padding(.trailing, 10)
                                        }
                                        .frame(width: max(0, geometry.size.width-45), height: 130)
                                }
                             
                            }
                            
                            // Insert Dropdown
//                            HStack {
//                                Text("Industry").font(Font.custom("Nunito-Bold", size: 18))
//                                    .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
//                                Spacer()
//                            }
//                            
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 5)
//                                    .fill(Color.white)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 5)
//                                            .stroke(Color.black, lineWidth: 1.25)
//                                    )
//                                    .frame(width: max(0, geometry.size.width - 45), height: 50)
//                                
//                                HStack {
//                                    Text("Restaurant").padding()
//                                        .foregroundColor(.black)
//                                        .autocorrectionDisabled(true)
//                                        .autocapitalization(.none)
//                                        .font(Font.custom("Nunito-Bold", size: 16))
//                                    
//                                    Spacer()
//                                }
//                                .cornerRadius(5)
//                                .opacity(0.5)
//                            }
                            
                            HStack {
                                Text("Total No of Franchises").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width - 45), height: 50)
                                
                                TextField("", text: $noOfFranchises, prompt: Text("150").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                    .foregroundColor(.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                            }
                            
                            // All these stats are per location
                            HStack {
                                Text("Avg Franchise MoM Revenue (£)").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width - 45), height: 50)
                                
                                TextField("", text: $MoMRevenue, prompt: Text("25000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                    .foregroundColor(.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                            }
                            
                            HStack {
                                Text("Avg Startup Capital (£)").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width - 45), height: 50)
                                
                                TextField("", text: $startupCapital, prompt: Text("15000000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                    .foregroundColor(.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                            }
                            
                            HStack {
                                Text("Avg Revenue after 18 months (£)").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width - 45), height: 50)
                                
                                TextField("", text: $monthRev18, prompt: Text("450000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                    .foregroundColor(.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                            }
                            
                            HStack {
                                Text("EBITDA Estimate (%)").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width - 45), height: 50)
                                
                                TextField("", text: $ebitdaEstimate, prompt: Text("28").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                    .foregroundColor(.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    self.franchise_data.append(DropdownMenuOption(option: self.name))
                                    
                                    CreateDB().createFranchise(name: self.name, logo: "null for now", description: self.description, no_of_franchises: self.noOfFranchises, avg_franchise_mom_revenues: self.MoMRevenue, avg_startup_capital: self.startupCapital, avg_revenue_18_months: self.monthRev18, ebitda_estimate: self.ebitdaEstimate) { response in
                                        
                                        if response == "Franchise Created" {
                                            franchise_form_shown.toggle()
                                        }
                                    }
                                }
                            }) {
                                HStack {
                                    Text("Submit")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                }
                                .frame(width: max(0, geometry.size.width-45), height: 55)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom)
                            }
                            
                            
                        }
                        .foregroundColor(.black)
                }
                .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height))

            }
            .sheet(isPresented: $showLogoImagePicker) {
                ImagePicker(image: $logo_image)
            }
            .sheet(isPresented: $showDisplayImagePicker) {
                ImagePicker(image: $display_image)
            }
            .padding(.top, 30)
        }
    }
    
    func validateDescriptionCount(value: String) {
        if value.count > 0 {
            isDescriptionValid = true
        } else {
            isDescriptionValid = false
        }
    }
}

#Preview {
    AdminFranchiseForm(franchise_form_shown: .constant(true), franchise_data: .constant([]))
}
