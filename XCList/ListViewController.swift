
import UIKit

final class ListViewController: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var progressView: UIProgressView!
   
   var root: ListItem? {
      didSet {
         title = root?.title
         addRightBarButtonItem()
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      // A click on parent item pushes children's view controller onto the navigation stack, once we pop the children's view controller (go back) we need to refresh the parent table view since some of the children might have changed its state
      updateProgress()
      tableView.reloadData()
   }
}

extension ListViewController {
   private func updateProgress() {
      guard let root = root else { fatalError() }
      let doneCount = root.children.filter { $0.state == .done }.count
      progressView.progress = Float(doneCount) / Float(root.children.count)
   }
   
   @objc private func reset(_ sender: UIBarButtonItem) {
      root?.state = .pending
      updateProgress()
      tableView.reloadData()
   }
   
   private func addRightBarButtonItem() {
      if root?.parent == nil {
         let rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset(_:)))
         navigationItem.rightBarButtonItem = rightBarButtonItem
         return
      }
      // Don't allow Select All for roots containing parent children. Select All is allowed only when all children are leafs
      if let children = root?.children {
         let parentCount = children.filter { !$0.isLeaf }.count
         if parentCount > 0 {
            return
         }
      }
      let barButtonMenu = UIMenu(title: "", children: [
         UIAction(title: NSLocalizedString("Select All", comment: ""), image: nil) { [weak self] _ in
            guard let children = self?.root?.children else { fatalError() }
            for child in children {
               child.state = .done
            }
            self?.updateProgress()
            self?.tableView.reloadData()
         },
         UIAction(title: NSLocalizedString("Deselect All", comment: ""), image: nil) { [weak self] _ in
            guard let children = self?.root?.children else { fatalError() }
            for child in children {
               child.state = .pending
            }
            self?.updateProgress()
            self?.tableView.reloadData()
         }
      ])
      let rightBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: nil, menu: barButtonMenu)
      navigationItem.rightBarButtonItem = rightBarButtonItem
   }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return root?.children.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      func attributedString(_ string: String, struckthrough: Bool) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(string: string)
         let attributedRange = NSMakeRange(0, attributedString.length)
         if struckthrough {
            //attributedString.addAttribute(.strikethroughStyle, value: 2, range: attributedRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: attributedRange)
         }
         return attributedString
      }
      
      func parentCell(item: ListItem) -> ListViewParentCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListViewParentCell.self)", for: indexPath) as? ListViewParentCell else { fatalError() }
         
         //cell.stateImageView.isHidden = true
         cell.stateImageView.image = (item.state == .pending)
            ? UIImage(systemName: "circle")
            : UIImage(systemName: "checkmark.circle")
         cell.titleLabel.attributedText = attributedString(item.title, struckthrough: item.state == .done)
         cell.commentLabel.text = item.comment
         let doneCount = item.children.filter { $0.state == .done }.count
         cell.summaryLabel.attributedText = attributedString("\(doneCount)/\(item.children.count)", struckthrough: item.state == .done)
         return cell
      }
      
      func leafCell(item: ListItem) -> ListViewLeafCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListViewLeafCell.self)", for: indexPath) as? ListViewLeafCell else { fatalError() }
         
         cell.stateImageView.isHidden = true
         cell.stateImageView.image = (item.state == .pending)
            ? UIImage(systemName: "circle")
            : UIImage(systemName: "checkmark.circle")
         cell.titleLabel.attributedText = attributedString(item.title, struckthrough: item.state == .done)
         cell.commentLabel.text = item.comment
         cell.summaryLabel.attributedText = attributedString(item.summary ?? "", struckthrough: item.state == .done)
         return cell
      }
      
      guard let item = root?.children[indexPath.row] else { fatalError() }
      return item.isLeaf
         ? leafCell(item: item)
         : parentCell(item: item)
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let item = root?.children[indexPath.row] else { fatalError() }
      if item.isLeaf {
         item.toggleState()
         updateProgress()
         tableView.reloadRows(at: [indexPath], with: .automatic)
      } else {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         guard let nextViewController = storyboard.instantiateViewController(withIdentifier: "\(ListViewController.self)") as? ListViewController else { fatalError() }
         
         nextViewController.root = item
         navigationController?.pushViewController(nextViewController, animated: true)
      }
   }
}
