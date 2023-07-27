
# Workouter
![](https://github.com/JongHyunLee84/Workouter/assets/112399028/82bc0c6a-45c0-403e-be6e-b3959059f5bc)
Main Feature : Workout Traker, Gym Log 

iOS Project implemented with MVVM Architecture and RxSwift

App Store Link: [Workouter - Workout Traker Log](https://apps.apple.com/kr/app/workouter-workout-tracker-log/id6447367318)

## Layers
-  Presentation Layer = View + ViewController ( Separated )
- Domain Layer = ViewModel ( Business Logic )
-  Data Repository Layer = Repositories Implementations + Network + Persistence DB

**Dependency Direction**
```mermaid
graph LR
A[View] --> B[ViewController] --> C[ViewModel]
D[DataRepository] --> C
E[Network] --> D
F[Persistence DB] --> D
```
## Includes
- Reactive Functional Programming with RxSwift
- Code Base UI with Snapkit (Refactored from storyboard)
- Separated View and View Controller
- Expandable ( Collapsible ) Table View
- GIF Image
- Dark Mode
- SwiftUI Preview
- UI Factory Pattern [(Workouter.UIFactory)](https://github.com/JongHyunLee84/Workouter/blob/main/Workouter/Utilities/UI/UIFactory.swift)
- Repository Pattern [(Reference)](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
- Base View Pattern [(ex. BaseViewController)](https://github.com/JongHyunLee84/Workouter/blob/main/Workouter/Utilities/UI/BaseUI/BaseViewController.swift)
## Framework and Library
- UIKit
- Snapkit : Layout
- RxSwift / RxCocoa : Reactive Functional Programming
- GIFLibrary : [Reference](https://github.com/kiritmodi2702/GIF-Swift/blob/master/GIF-Swift/iOSDevCenters+GIF.swift)
- CoreData : Persistence DB

**Network(Data) API**  :  [ExerciseDB](https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb/)
## Build
1. git clone
2. pod install (update)
3. open .xcworkspace project
