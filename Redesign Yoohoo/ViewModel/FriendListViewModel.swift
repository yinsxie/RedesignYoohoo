import SwiftUI
import Combine
import SwiftData

class FriendListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedSort: SortOption = .az
    @Published var showSortMenu: Bool = false
    @Published var friends: [Buddy] = []

    var context: ModelContext?
    private var cancellables = Set<AnyCancellable>()

    init(context: ModelContext? = nil) {
        self.context = context
//        fetchFriends()

        // Auto update saat search / sort berubah
        Publishers.CombineLatest($searchText, $selectedSort)
            .sink { [weak self] _, _ in
                self?.fetchFriends()
            }
            .store(in: &cancellables)
    }
    
    func setContext(_ context: ModelContext) {
        self.context = context
        fetchFriends()
    }

    func fetchFriends() {
        guard let context = context else { return }
        let descriptor = FetchDescriptor<Buddy>() // ambil semua data dari SwiftData
        do {
            var results = try context.fetch(descriptor)

            // Filter berdasarkan search text
            if !searchText.isEmpty {
                results = results.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }

            // Sorting
            switch selectedSort {
            case .az:
                results.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            case .za:
                results.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
            case .latest:
                results.sort { $0.createdAt > $1.createdAt }
            case .earliest:
                results.sort { $0.createdAt < $1.createdAt }
            }

            // Simpan ke @Published agar UI update
            friends = results
        } catch {
            print("Gagal fetch data Buddy: \(error)")
            friends = []
        }
    }
    
    func loadImage(for friend: Buddy) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(friend.image)
        return UIImage(contentsOfFile: url.path)
    }
}
