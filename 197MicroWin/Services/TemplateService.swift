import Foundation

final class TemplateService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func getTemplates() -> [WinTemplate] {
        var templates: [WinTemplate] = storageService.load(forKey: StorageKeys.templates)
        if templates.isEmpty {
            templates = WinTemplate.defaults
            storageService.save(templates, forKey: StorageKeys.templates)
        }
        return templates
    }

    func addTemplate(title: String, category: Category) {
        var templates = getTemplates()
        templates.append(WinTemplate(id: UUID(), title: title, category: category, isCustom: true))
        storageService.save(templates, forKey: StorageKeys.templates)
    }

    func deleteTemplate(_ template: WinTemplate) {
        var templates = getTemplates()
        templates.removeAll { $0.id == template.id }
        storageService.save(templates, forKey: StorageKeys.templates)
    }
}
