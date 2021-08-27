import SwiftUI
import SwiftUIUtil

struct ContentView: View {
    @State var showAlert: Bool = false
    var body: some View {
        Text("Hello, world!")
            .padding()
        if #available(iOS 14.0, *) {
            MenuButton(
                image: UIImage(systemName: "ellipsis.circle"),
                menuTitle: "", title: "Test",
                actions: [
                    .default(title: "Add", image: UIImage(systemName: "plus")) {
                        print("Add something random")
                    },
                    .submenu(title: "Edit...", options: .displayInline, children: [
                        .default(title: "Rename", image: UIImage(systemName: "pencil")) {
                            print("Your name is no longer proper!")
                        },
                        .destructive(title: "Delete", image: UIImage(systemName: "trash")) {
                            print("Don't delete me, I beg you")
                        }
                    ])
                ]
            )
        } else {
            Button(action: {
                self.showAlert = true
            }, label: {
                HStack {
                    Image(systemName: "ellipsis.circle")
                    Text("Test")
                }
            })
            .background(AlertControllerView(showAlert: $showAlert,
                                            title: "Test",
                                            message: "Message",
                                            preferredStyle: .alert,
                                            actions: [
                                                .default(title: "OK", handler: { _ in
                                                    
                                                }),
                                                .cancel(title: "Cancel")
                                            ]))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
