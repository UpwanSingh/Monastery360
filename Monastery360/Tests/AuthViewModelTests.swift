import XCTest
@testable import Monastery360

@MainActor
final class AuthViewModelTests: XCTestCase {
    
    // We would need a MockAuthService to properly test this without hitting Firebase.
    // For now, we will test basic instantiation and state properties if possible,
    // or add a Mock to the DI container for testing.
    
    // Since AuthService is concrete and hits Firebase, testing it directly in unit tests 
    // requires either integration tests (emulator) or a protocol-based mock.
    // Given the constraints, I will verify the ViewModel logic assuming dependency injection *could* swap it out.
    // But since I can't easily mock the concrete AuthService without refactoring it to a protocol,
    // I will write a sanity test that verifies the ViewModel initializes correctly.
    
    func testViewModelInitialization() {
        let authService = AuthService()
        let vm = AuthViewModel(authService: authService)
        
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.error)
    }
}
