import SwiftUI
import Combine

public struct AlertControllerView: UIViewControllerRepresentable {
    public init(showAlert: Binding<Bool>, title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style, dispatchQueue: DispatchQueue = .main, actions: [AlertControllerView.Action]) {
        self._showAlert = showAlert
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.dispatchQueue = dispatchQueue
        self.actions = actions
    }
    
    @Binding var showAlert: Bool
    public var title: String?
    public var message: String?
    public var preferredStyle: UIAlertController.Style = .alert
    public var dispatchQueue: DispatchQueue = .main
    public var actions: [Action]

    public struct Action {
        public init(title: String? = nil, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }
        
        public var title: String?
        public var style: UIAlertAction.Style
        public var handler: ((UIAlertAction) -> Void)?
        
        public static func `default`(title: String?, handler: ((UIAlertAction) -> Void)?) -> Action {
            Action(title: title, style: .default, handler: handler)
        }
        
        public static func destructive(title: String?, handler: ((UIAlertAction) -> Void)?) -> Action {
            Action(title: title, style: .destructive, handler: handler)
        }
        
        public static func cancel(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> Action {
            Action(title: title, style: .cancel, handler: handler)
        }
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControllerView>) -> UIViewController {
        return UIViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard showAlert else { return }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        actions.forEach { action in
            alert.addAction(.init(title: action.title, style: action.style, handler: action.handler))
        }
        dispatchQueue.async {
            uiViewController.present(alert, animated: true, completion: {
                self.showAlert = false
            })
        }
    }
}
