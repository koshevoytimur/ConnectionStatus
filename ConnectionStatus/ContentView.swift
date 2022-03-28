//
//  ContentView.swift
//  ConnectionStatus
//
//  Created by Essence K on 28.03.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Arrow up = working!\n\nArrow down = not working!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
