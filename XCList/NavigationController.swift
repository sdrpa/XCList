
import UIKit

class NavigationController: UINavigationController {
   override func viewDidLoad() {
      super.viewDidLoad()
      
      guard let listViewController = children.first as? ListViewController else { fatalError() }
      listViewController.root = A319.root
   }
}
