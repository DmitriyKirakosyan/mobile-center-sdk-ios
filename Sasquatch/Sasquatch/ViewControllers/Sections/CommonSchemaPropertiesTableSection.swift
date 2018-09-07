import UIKit

class CommonSchemaPropertiesTableSection : PropertiesTableSection {

  let kTargetSelectorCellRow = 0
  let kDeviceIdRow = 1
  let switchCellIdentifier = "collectdeviceidswitchcell"
  let propertyKeys = ["App Name", "App Version", "App Locale"]
  var propertyValues: [String: [String]]!
  var transmissionTargetSelectorCell: MSAnalyticsTransmissionTargetSelectorViewCell?
  var collectDeviceIdStates: [String: Bool]!

  override init(tableSection: Int, tableView: UITableView) {
    super.init(tableSection: tableSection, tableView: tableView)
    propertyValues = [String: [String]]()
    collectDeviceIdStates = [String: Bool]()
    let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    let parentTargetToken = appName == "SasquatchSwift" ? kMSSwiftRuntimeTargetToken : kMSObjCRuntimeTargetToken
    for token in [parentTargetToken, kMSTargetToken1, kMSTargetToken2] {
      propertyValues[token] = Array(repeating: "", count: propertyKeys.count)
      collectDeviceIdStates[token] = false
    }
    transmissionTargetSelectorCell = loadCellFromNib()
    transmissionTargetSelectorCell?.didSelectTransmissionTarget = reloadSection
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case kTargetSelectorCellRow:
      return transmissionTargetSelectorCell!
    case kDeviceIdRow:
        let cell = tableView.dequeueReusableCell(withIdentifier: switchCellIdentifier)!
        let switcher: UISwitch? = cell.getSubview()
        let selectedTarget = transmissionTargetSelectorCell?.selectedTransmissionTarget()!
        switcher!.isOn = collectDeviceIdStates[selectedTarget!]!
        switcher!.isEnabled = !switcher!.isOn
        switcher!.addTarget(self, action: #selector(collectDeviceIdSwitchCellEnabled(sender:)), for: .valueChanged)
        return cell
    default:
      let cell = super.tableView(tableView, cellForRowAt: indexPath) as! MSAnalyticsPropertyTableViewCell
      cell.valueField.placeholder = "Override value"
      return cell
    }
  }
  
  override func propertyValueChanged(sender: UITextField!) {
    let selectedTarget = transmissionTargetSelectorCell?.selectedTransmissionTarget()
    let propertyIndex = getCellRow(forTextField: sender) - propertyCellOffset()
    let target = MSTransmissionTargets.shared.transmissionTargets[selectedTarget!]!
    propertyValues[selectedTarget!]![propertyIndex] = sender.text!
    switch propertyIndex {
    case 0: // App Name.
      target.propertyConfigurator.setAppName(sender.text!)
      break
    case 1: // App Version.
      target.propertyConfigurator.setAppVersion(sender.text!)
      break
    case 2: // App Locale.
      target.propertyConfigurator.setAppLocale(sender.text!)
      break
    default:
      break
    }
  }

  override func propertyAtRow(row: Int) -> (String, String) {
    let selectedTarget = transmissionTargetSelectorCell?.selectedTransmissionTarget()
    let propertyIndex = row - propertyCellOffset()
    let value = propertyValues[selectedTarget!]![propertyIndex]
    return (propertyKeys[row - numberOfCustomHeaderCells()], value)
  }

  override func numberOfCustomHeaderCells() -> Int {
    return 2
  }

  override func getPropertyCount() -> Int {
    return propertyKeys.count
  }

  // Since properties are static, there is no "insert" row.
  override func hasInsertRow() -> Bool {
    return false
  }

  func collectDeviceIdSwitchCellEnabled(sender: UISwitch?) {

    // Disable the switch.
    sender!.isEnabled = false

    // Update the transmission target.
    let selectedTarget = transmissionTargetSelectorCell?.selectedTransmissionTarget()
    let target = MSTransmissionTargets.shared.transmissionTargets[selectedTarget!]!
    target.propertyConfigurator.collectDeviceId()

    // Update in memory state for display.
    collectDeviceIdStates[selectedTarget!] = true
  }
}
