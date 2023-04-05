//
//  RootView.swift
//  DI-Test
//
//  Created by Bran on 2023/04/05.
//

import Combine
import SwiftUI

struct RootView: View {
  @StateObject
  var viewModel = RootViewModel()

  @EnvironmentObject
  var appState: AppState

  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(
          destination: { TestView() },
          label: {
            Text("Navigation Push")
          }
        )

        Button(
          action: { viewModel.action(.rootViewChanged) },
          label: {
            Text("RootView Change")
          }
        )
      }
    }
  }
}

final class RootViewModel: ObservableObject {
  struct Input {
    fileprivate let rootViewChangeSub = PassthroughSubject<Void, Never>()
  }

  enum Action {
    case rootViewChanged
  }

  func action(_ action: Action) {
    switch action {
    case .rootViewChanged:
      input.rootViewChangeSub.send()
    }
  }

  var input: Input = Input()
  var cancellables = Set<AnyCancellable>()

  init() {
    transform()
  }

  func transform() {
    input.rootViewChangeSub
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.rootViewChange()
      })
      .store(in: &cancellables)
  }
}

extension RootViewModel {
  private func rootViewChange() {
    let window = UIApplication
      .shared
      .connectedScenes
      .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .first { $0.isKeyWindow }

    window?.rootViewController = UIHostingController(rootView: ContentView())
    window?.makeKeyAndVisible()
  }
}
