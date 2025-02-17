import UIKit

protocol ISettingsTableManager {
    func setup(table: UITableView)
    func reloadTable(_ sections: [SettingsSection])
}

final class SettingsTableManager: NSObject {
    private weak var tableView: UITableView?
    private var sections = [SettingsSection]()
}

extension SettingsTableManager: @preconcurrency ISettingsTableManager {
    @MainActor func setup(table: UITableView) {
        tableView = table
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.register(
            SelectionTitleTableViewCell.self,
            forCellReuseIdentifier: SelectionTitleTableViewCell.reuseIdentifier
        )
        
        tableView?.register(
            ToggleSettingsTableViewCell.self,
            forCellReuseIdentifier: ToggleSettingsTableViewCell.reuseIdentifier
        )
        
        tableView?.register(
            DisclosureSettingsTableViewCell.self,
            forCellReuseIdentifier: DisclosureSettingsTableViewCell.reuseIdentifier
        )
    }
    
    @MainActor func reloadTable(_ sections: [SettingsSection]) {
        self.sections = sections
        tableView?.reloadData()
    }
}

extension SettingsTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = sections[safe: indexPath.section] else { return .zero }
        switch section {
        case .titleSelection:
            return 183
        case .disclosureSection:
            return 235
        case .toggleSection:
            return 151
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return .init()
    }
}

extension SettingsTableManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sections[safe: indexPath.section] else { return .init() }
        switch section {
        case .titleSelection(_, let viewModels):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SelectionTitleTableViewCell.reuseIdentifier
                  ) as? SelectionTitleTableViewCell else { return .init() }
            cell.fill(viewModels)
            return cell
        case .disclosureSection(let viewModels):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DisclosureSettingsTableViewCell.reuseIdentifier
                  ) as? DisclosureSettingsTableViewCell else { return .init() }
            cell.fill(viewModels)
            return cell
        case .toggleSection(let viewModels):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ToggleSettingsTableViewCell.reuseIdentifier
                  ) as? ToggleSettingsTableViewCell else { return .init() }
            cell.fill(viewModels)
            return cell
        }
    }
}
