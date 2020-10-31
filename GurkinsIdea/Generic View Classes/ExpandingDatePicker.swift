//
//  ExpandingDatePicker.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/28/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct ExpandingDatePicker: View {
    @State var expanded = false
    
    @Binding var date: Date
    
    
    var formatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        
        VStack
        {
            Button(action: {self.expanded.toggle()})
            {
                HStack
                {
                    if (expanded)
                    {
                        Image(systemName: "arrowtriangle.up.circle.fill")
                            .padding(.leading)
                        Text(formatter.string(from: date))
                            .foregroundColor(.secondary)
                    }
                    else
                    {
                        Image(systemName: "arrowtriangle.down.circle.fill")
                        .padding(.leading)
                        Text(formatter.string(from: date))
                            .foregroundColor(.primary)
                    }
                    
                    
                    Spacer()
                }
            }
            if (expanded)
            {
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(width: 250, height: 120)
                .padding(20)
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        
    }
}

struct ExpandingDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ExpandingDatePicker(date: .constant(Date()))
    }
}
