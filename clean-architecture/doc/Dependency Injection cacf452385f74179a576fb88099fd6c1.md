# Dependency Injection

의존성 역전, 의존성 주입 개발을 하다보면 어디서든 항상 듣게 된다. 사실 대충은 알고 있었지만 이번 기회를 통해서 확실하게 정리해보려고 한다.

- 왜 사용하는가?
- 어떤 상황에 사용하면 좋을까?

정리가 끝났을 때 위의 두 질문에 스스로 대답할 수 있도록 정리해보는게 목표!

---

## DI를 사용하면 무엇이 달라질까?

Dependency, Dependency Injection, Dependency Inversion에 대한 설명은 간단한 예제를 하나 살펴보고 자세하게 알아보자

```swift
import Combine
import Foundation

final class NetworkService {
  let url: URL = URL(string: "https://jsonplaceholder.typicode.com/users/1/todos")!

  func fetchTodos() -> AnyPublisher<Todos, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: Todos.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
```

API Call을 통해 받은 데이터를 뷰에 뿌려주는 예제를 생각해보자. 

위의 NetworkService를 viewModel에서 사용하려면 어떻게 해야할까? 

```swift
final class NetworkService {
  static let shared = NetworkService()
  private init() { }

  let url: URL = URL(string: "https://jsonplaceholder.typicode.com/users/1/todos")!

  func fetchTodos() -> AnyPublisher<Todos, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: Todos.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

final class ContentViewModel: ObservableObject {
  @Published
  var todos: Todos = []

  private var cancellables = Set<AnyCancellable>()

  init() {
    loadTodos()
  }
}

extension ContentViewModel {
  private func loadTodos() {
    NetworkService.shared.fetchTodos()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] in
          guard let self = self else { return }
          self.todos = $0
        }
      )
      .store(in: &cancellables)
  }
}
```

일반적으로(?) 싱글톤 패턴을 사용해서 임의의 viewModel에서 해당 network service에 접근해서 fetchTodos메서드를 사용해왔다

물론 싱글톤을 사용해서 우리가 원하는 동작을 이끌어 낼 수는 있지만 몇 가지 문제점이 있다.

- 싱글톤은 전역적이다

지금처럼 간단한 앱에서는 크게 문제될 상황이 없지만 앱의 규모가 커지고 멀티 쓰레드 환경에서 다른 쓰레드에서 동시에 싱글톤을 통해 생성되는 instance에 접근하면 문제가 발생한다

- 이니셜라이저를 customize 할 수 없다

싱글톤은 하나의 인스턴스만을 만들어야 하기 때문에 이니셜라이저를 private하게 만든다. 

- Service를 바꿀 수 없다(dependency를 바꿀 수 없다) → 테스트 코드를 작성할 수 없다

위의 코드를 DI를 통해서 조금씩 수정해가면서 위의 문제를 해결해보자

```swift
final class NetworkService {
  let url: URL

  init(url: URL) {
    self.url = url
  }

  func fetchTodos() -> AnyPublisher<Todos, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: Todos.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
```

```swift
final class ContentViewModel: ObservableObject {
  @Published
  var todos: Todos = []

  private var cancellables = Set<AnyCancellable>()
  private let networkService: NetworkService

  init(networkService: NetworkService) {
    self.networkService = networkService
    loadTodos()
  }
}

extension ContentViewModel {
  private func loadTodos() {
    networkService.fetchTodos()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] in
          guard let self = self else { return }
          self.todos = $0
        }
      )
      .store(in: &cancellables)
  }
}
```

우선 싱글톤 형태를 제거하고 ViewModel에서 Networkservice 클래스의 인스턴스를 이니셜라이저의 인자로 받아서 해당 인스턴스를 통해서 API Call을 하도록 코드를 수정했다. 

위와 같은 상황이 DIP를 만족하지는 않기 때문에 엄밀하게 완벽한 DI라고는 볼 수 없지만 ViewModel이라는 클래스의 생성과정에 NetworkService라는 의존성을 주입하는 형태이다.

위와 같이 코드를 변경하는 것만으로도 싱글톤에서 발생할 수 있는 1,2번 문제가 해결된 것을 알 수 있다.

아직 3번 문제가 해결되지 않았는데 우선 문제에 대한 정의를 확실하게 해보자.

위와 같은 코드 형태에서 실제 API Call을 통해서 데이터를 받아오는게 아닌 임의의 Mock 데이터를 보여주려면 어떻게 해야할까?

- NetworkService에 Mock 데이터를 추가하고, 해당 데이터를 넘겨주는 코드 작성 → `반성하세요`
- MockNetworkService 클래스를 만들어서 NetworkService를 MockNetworkService로 변경 → `옆에 같이 서세요`

부끄럽지만 나도 위와 같은 방법을 통해 문제를 해결한 경험이 많다. 하지만 위의 방법을 선택하게 되는 순간 수정해야 될 코드들이 많아진다. 더 좋은 방법이 없을까?

```swift
// MARK: - Protocol
protocol NetworkServiceProtocol {
  func fetchTodos() -> AnyPublisher<Todos, Error>
}

// MARK: - NetworkService
final class NetworkService: NetworkServiceProtocol {
  let url: URL

  init(url: URL) {
    self.url = url
  }

  func fetchTodos() -> AnyPublisher<Todos, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: Todos.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

// MARK: - VM
final class ContentViewModel: ObservableObject {
  @Published
  var todos: Todos = []

  private var cancellables = Set<AnyCancellable>()
  private let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
    loadTodos()
  }
}

extension ContentViewModel {
  private func loadTodos() {
    networkService.fetchTodos()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] in
          guard let self = self else { return }
          self.todos = $0
        }
      )
      .store(in: &cancellables)
  }
}
```

이전의 코드와 달라진점은 ViewModel이 NetworkService라는 클래스의 인스턴스를 주입받는게 아니라 NetworkServiceProtocol 프로토콜을 주입받는다.

그럼 3번 문제를 여기서는 어떻게 해결할 수 있을까? ❗️❗️❗️❗️❗️

```swift
final class MockNetworkService: NetworkServiceProtocol {
  private let mockData: Todos = [
    TodoModel(userId: 1, id: 1, title: "TEST1", completed: false),
    TodoModel(userId: 2, id: 2, title: "TEST2", completed: true),
    TodoModel(userId: 3, id: 3, title: "TEST3", completed: false)
  ]

  func fetchTodos() -> AnyPublisher<Todos, Error> {
    Just(mockData)
      .tryMap { $0 } // Never -> Error 잡기술
      .eraseToAnyPublisher()
  }
}
```

```swift
import SwiftUI

@main
struct DI_ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      let networkSerivce = NetworkService(
        url: URL(string: "https://jsonplaceholder.typicode.com/users/1/todos")!
      )
      let mockService = MockNetworkService()

//      ContentView(viewModel: ContentViewModel(networkService: networkSerivce))
      ContentView(viewModel: ContentViewModel(networkService: mockService))
    }
  }
}
```

NetworkServiceProtocol을 채택하고 있는 Mock 클래스의 인스턴스를 ViewModel을 만들 때 주입해주면 된다. 앞선 방법들에 비해서 정말 깔끔하고 간단하게 해결할 수 있을 뿐만 아니라 코드를 통해 확인 할 수 있듯이 테스트 하기가 정말 쉬워진다.

사실 위의 내용이 DIP 원칙으로 상위 모듈이 하위 모듈에 의존해서는 안되고 모두 추상화에 의존해야 한다는 내용이다.

- NetworkService → ContentViewModel
- NetworkService <- NetworkServiceProtocol → ContentViewModel

의존성 관계가 위와 같이 변경된 것이다!

왜 단순히 DI만 적용하는 것보다, DIP 원칙을 적용하고 DI를 적용하라고 하는지 확실히 깨달았다.

이제 이유를 알고 용도를 알았으니 애매하던 DI, DIP에 대한 개념만 확실히 하고 넘어가자

---