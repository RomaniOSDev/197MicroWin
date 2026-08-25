import SwiftUI

/// Color tokens used by Loading UI — mapped to this app's existing asset catalog / AppColor.
extension Color {
    static var appBackground: Color { AppColor.background }
    static var appSurface: Color { AppColor.card }
    static var appPrimary: Color { AppColor.accent }
    static var appAccent: Color { AppColor.accent }
    static var appTextPrimary: Color { AppColor.textPrimary }
    static var appTextSecondary: Color { AppColor.textSecondary }
}

enum AppColors {
    /// Text/icons on solid accent buttons (Loading gate)
    static let onAccent = Color.white
}
