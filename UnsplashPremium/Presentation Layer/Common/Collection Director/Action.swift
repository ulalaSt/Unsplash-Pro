

import UIKit

enum Action: Hashable {
    case didSelect
    case didReachedEnd
    case custom(String)

    var hashValue: Int {
        switch self {
        case .didSelect: return 0
        case .didReachedEnd: return 1
        case .custom(let custom): return custom.hashValue
        }
    }
}

struct ActionEventData {
    let action: Action
    let cell: UIView
}

extension Action {
    static let notificationName = NSNotification.Name("Action")

    func invoke(cell: UIView) {
        NotificationCenter.default.post(name: Action.notificationName, object: nil, userInfo: ["data": ActionEventData(action: self, cell: cell)])
    }
}
