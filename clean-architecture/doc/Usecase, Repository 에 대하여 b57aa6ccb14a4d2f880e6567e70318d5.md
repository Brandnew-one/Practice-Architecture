# Usecase, Repository 에 대하여

![Untitled](https://user-images.githubusercontent.com/88618825/211225312-d1d230dd-bbf3-43aa-8e71-8737a6c3b346.png)

- Domain Layer(= Entity, UseCase, Repository interface)
- Presentation Layer(= view, viewmodel)
- Data Layer(=DB, API, Repository Implementation)

클린 아키텍처 예제에서는 위와 같이 각원들을 묶어서 layer를 나누고 있는데 이번 토이 프로젝트에서 해당 구조를 따르긴 하겠지만 

- 왜 ViewModel에서 비즈니스 로직 담당 책임을 Usecase로 나누고 이를 나눔으로서 얻을 수 있는 이점이 무엇인지?
- Usecase와 Repository가 나누어져 있는 이유는 무엇인지?

이런 의문에 좀 더 집중해보려고 한다.

### 1) 비즈니스 로직이 뭘까?

우선 이 의문을 해결하기 전에 `비즈니스 로직`은 무엇인가에 대해 짚고 넘어갈 필요가 있다.

정리된 글들을 보면 비즈니스 로직에 대한 의견들이 분분하고 주관적인 느낌이 많이 드는데 많은 고민끝에 제 나름대로 결론을 내렸다.

> 비즈니스로직은 Entity를 만드는 로직을 의미한다.
> 

지난번에 클린 아키텍처의 각 Layer들을 공부할 때 Entity는 Layer가장 안쪽에 위치하며 데이터의 본질이라고 했는데 대부분의 클린 아키텍처 예제들을 보면 Usecase는 Repository(API, DB)로 부터 Entity들을 얻어내고 있는것을 확인할 수 있다.

### 2) Usecase에서 왜 비즈니스 로직을 담당하고 있을까?

지금까지 프로젝트를 구성할 때 일반적으로 API, DB를 담당하고 있는 싱글톤 클래스들로 구성하고 각각의 Viewmodel에서 위의 클래스들을 통해서 얻을 수 있는 Model이 필요하면 불러서 사용하는 형태로 구성해왔다.

즉, 위의 설명대로 하면 Entity를 불러오는 비즈니스 로직을 ViewModel이 담당하는 형태로 코드를 구성해왔다.

위와 같은 방식으로 ViewModel을 작성하는 방식에서 어떤 ‘필요’ 때문에 Usecase와 Repository로 각각의 책임을 나눠서 사용하는걸까?

> 비즈니스 로직의 재활용이 쉬워진다.
> 

많은 이유가 있겠지만 며칠간 고민후 내린 결론은 Usecase를 사용하면 비즈니스 로직을 재활용하기 쉬워진다.

MVVM 패턴에서 ViewModel은 View를 참조하지 않기 때문에 1:n 관계를 갖는다라고 하지만 ViewModel에 Binding되는 Output을 View에서 보여주기 때문에 사실상 1:1 형태로 코드를 작성했고 view를 잘게 쪼개지 않는 한 ViewModel을 재활용하기는 힘들었다.

(물론 본인의 MVVM에 대한 이해가 부족해 위와 같이 코드를 작성했을 수도 있다)

하지만 비즈니스 로직을 Usecase에서 담당하게 된다면, 만약 다른 ViewModel에서 현재 ViewModel에서 사용하고 있는 비즈니스 로직이 필요한 경우, 동일한 Usecase를 사용하기만 하면 중복되는 코드를 손쉽게 줄일 수 있다.

### 3) 그럼 왜 Usecase와 Repository가 나눠져 있을까?

Usecase에 대한 나름대로의 이해를 마쳤을 때 생긴 의문이다. 그럼 Usecase에서 하는 일이 결국 ‘어딘가’에서 Entity를 얻어오는데 그 ‘어딘가’는 왜 분리가 되어 있는걸까?

실제로 조금 더 자세하게 들여다보면 Domain Layer에는 Repository의 Interface가 구현되어 있고, 구현체는 Data Layer에 존재하고 있는데 이렇게 구현되어 있는 이유는 무엇일까? Domain Layer는 Data Layer의 존재를 모를텐데?

그럼 근본적으로 Repository는 무엇일까? 

> 유즈 케이스가 필요로 하는 데이터의 저장 및 수정 등의 기능을 제공하는 영역으로, 데이터 소스를 인터페이스로 참조하여, 로컬 DB와 네트워크 통신을 자유롭게 할 수 있다.
> 

간단하게 얘기하면 API, DB로 부터 DTO를 받아와서 Entity로 Mapping 시켜주는 역할을 담당하고 있다.

```swift
final class DefaultMoviesRepository {

    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage

    init(dataTransferService: DataTransferService, cache: MoviesResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultMoviesRepository: MoviesRepository {

    public func fetchMoviesList(query: MovieQuery, page: Int,
                                cached: @escaping (MoviesPage) -> Void,
                                completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {

        let requestDTO = MoviesRequestDTO(query: query.query, page: page)
        let task = RepositoryTask()

        cache.getResponse(for: requestDTO) { result in

            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getMovies(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
```

실제 예제 프로젝트에서 Data Layer에 구현되어 있는 Repository 구현체 코드이다.

 간단하게 코드를 설명해보자면 query를 캐시(Coredata)에 저장하고, query를 통해 API call 한 결과를 escaping 클로저를 통해 확인할 수 있는 메서드이다.

여기서 우리가 주목해야 될 부분은 DTO이다.

 API call을 하던 DB로 부터 데이터를 가져오던  그 데이터 Model이 Entity와 동일할까? 아마 Entity와 거의 동일한 형태이거나 동일한 경우가 많은것이다. 근데 왜 DTO라는 transform object를 만들어서 코드를 한 번 더 쓰는 번거로움이 있을까?

Domain Layer에서 사용되는 Entity 그대로 사용한다고 가정해보자.

API Call의 Response가 변경되면 어떤 일이 발생할까? Data Layer에 변화가 일어났을 뿐인데 Domain Layer의 Entity까지 수정해야 하는 일이 발생해버린다. 클린 아키텍처에서 강조하고 있는 바깥쪽 원이 안쪽원에 영향을 주지 않는다에 완전히 위배되는 내용이다.

DTO를 사용하게 되면 API Response가 변경되는 경우 , DTO에 정의한 .toDomain 메서드만 수정하면 된다.

그럼 Repository와 Usecase는 왜 분리되어 있을까?
