import SwiftUI

// https://gist.github.com/odonckers/1a444bb10124bcfb6409df0f7b6b3e76
@available(iOS 14.0, *)
public struct MenuButton: UIViewRepresentable {
    public init(image: UIImage? = nil, titleColor: UIColor = .black, menuTitle: String = "", font: UIFont = UIFont.systemFont(ofSize: 17), title: String = "", actions: [MenuButton.Action]) {
        self.image = image
        self.titleColor = titleColor
        self.menuTitle = menuTitle
        self.font = font
        self.title = title
        self.actions = actions
    }
    
    public var image: UIImage?
    public var titleColor: UIColor = .black
    public var menuTitle: String = ""
    public var font = UIFont.systemFont(ofSize: 17)
    public var title: String = ""
    public var actions: [Action]
    public var tintColor: UIColor?
    public var buttonType: UIButton.ButtonType = .system

    public struct Action {
        public init(title: String, image: UIImage? = nil, attributes: MenuButton.Action.Attributes = .default, action: (() -> Void)? = nil, state: UIMenuElement.State = .off, options: MenuButton.Action.Options = .default, children: [MenuButton.Action]? = nil) {
            self.title = title
            self.image = image
            self.attributes = attributes
            self.action = action
            self.options = options
            self.children = children
            self.state = state
        }
        
        public let title: String
        public var image: UIImage?
        public var attributes: Attributes = .default
        public var state: UIMenuElement.State = .off
        public var action: (() -> Void)?
        public var options: Options = .default
        public var children: [Action]?
        
        public enum Attributes {
            case `default`
            case destructive
            
            fileprivate func toUI() -> UIMenuElement.Attributes {
                switch self {
                case .destructive:
                    return .destructive
                default:
                    return .init()
                }
            }
        }
        
        public enum Options {
            case `default`
            case displayInline
            case destructive
            
            fileprivate func toUI() -> UIMenu.Options {
                switch self {
                case .displayInline:
                    return .displayInline
                case .destructive:
                    return .destructive
                default:
                    return .init()
                }
            }
        }
        
        public static func `default`(title: String, image: UIImage? = nil, state: UIMenuElement.State = .off, action: @escaping () -> Void) -> Action {
            Action(title: title, image: image, attributes: .default, action: action, state: state)
        }
        
        public static func destructive(title: String, image: UIImage? = nil, state: UIMenuElement.State = .off, action: @escaping () -> Void) -> Action {
            Action(title: title, image: image, attributes: .destructive, action: action, state: state)
        }
        
        public static func submenu(title: String, image: UIImage? = nil, options: Options = .default, children: [Action]) -> Action {
            Action(title: title, image: image, options: options, children: children)
        }
        
        fileprivate func toUI() -> UIMenuElement {
            if action != nil {
                let uiAction = UIAction(title: title, image: image, attributes: attributes.toUI(), state: state) { _ in self.action?() }
                return uiAction
            } else if children != nil {
                var submenuChildren: [UIMenuElement] = []
                (children ?? []).forEach({ action in
                    submenuChildren.append(action.toUI())
                })
                let uiMenu = UIMenu(title: title, image: image, options: options.toUI(), children: submenuChildren)
                return uiMenu
            } else {
                fatalError("Action requires action or children")
            }
        }
    }
    
    public func makeUIView(context: Context) -> UIButton {
        UIButton(type: buttonType)
    }
    
    public func updateUIView(_ uiButton: UIButton, context: Context) {
        var menuChildren: [UIMenuElement] = []
        actions.forEach({ menuChildren.append($0.toUI()) })
        
        let menu = UIMenu(
            title: menuTitle,
            children: menuChildren
        )
        uiButton.setImage(image, for: .normal)
        uiButton.role = .normal
        uiButton.menu = menu
        uiButton.setTitle(title, for: .normal)
        uiButton.titleLabel?.font = font
        uiButton.setTitleColor(titleColor, for: .normal)
        uiButton.tintColor = tintColor
        uiButton.showsMenuAsPrimaryAction = true
    }
}
