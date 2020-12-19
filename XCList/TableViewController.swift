
import UIKit

class ListViewController: UITableViewController {
   var items = ["Link", "Zelda", "Ganondorf", "Midna"]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
   }
}

extension ListViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return items.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
      cell.textLabel?.text = items[indexPath.row]
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let item = items[indexPath.row]
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let nextViewController = storyboard.instantiateViewController(withIdentifier: "TableViewController")
      navigationController?.pushViewController(nextViewController, animated: true)
   }
}
