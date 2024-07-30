# Eisen Matrix

# 1. 소개 및 기간

### 1.1 소개

- 아이젠하워의 매트릭스는 할일에 우선순위를 분류할 수 있는 표를 말합니다.  
  해당 서비스는 기존의 ToDo 앱에 우선순위를 분류할 수 있는 기능을 추가하여,  사용자 스스로가 할일의 우선순위를 분류/확인할수 있도록 하여 업무를 좀 더 빨리 처리할 수 있도록 도와줍니다.

### 1.2 개발 기간

- 2024.04.09 - 2024.04.25 (16일)

## 2. 목표와 기능

### 2.1 목표

- 위젯을 이용하여 할일을 관리할 수 있도록 하기
- 알림 기능을 사용하여, 앱 종료한 상황에서도 알림이 오도록 하기

### 2.2 기능

- 할일 작성/조회/편집/삭제 기능
- 할일 통계 기능
- 설정 기능

## 3. 개발 환경

### 3.1 개발 환경 및 배포 URL

- 버전 정보
  - iOS 16.0 이상
- 라이브러리 및 프레임워크
  - `SwiftUI`
  - `Combine`
  - `SwiftData`


## 4. UI

### 4.1 페이지별 UI

<table>
    <tbody>
        <tr>
            <td>할일 조회 페이지</td>
            <td>할일 작성 페이지</td>
        </tr>
        <tr>
            <td>
		<img src="https://velog.velcdn.com/images/jakkujakku98/post/a0e2a610-bc7f-4a02-a960-5eecbce3d10c/image.gif" width="100%">
            </td>
            <td>
                <img src="https://velog.velcdn.com/images/jakkujakku98/post/6524a218-7704-41fa-bb9b-9c2c0cb0e037/image.gif" width="100%">
            </td>
        </tr>
        <tr>
            <td>할일 편집 페이지</td>
            <td>할일 통계 페이지</td>
        </tr>
        <tr>
            <td>
                <img src="https://velog.velcdn.com/images/jakkujakku98/post/5f1a97f7-c430-4625-89cc-39bcd1c60fdd/image.gif" width="100%">
            </td>
            <td>
                <img src="https://velog.velcdn.com/images/jakkujakku98/post/fe35b45b-905d-4e55-9971-72509ebfe115/image.gif" width="100%">
            </td>
        </tr>
        <tr>
            <td>설정 페이지</td>
          </tr>
      <tr>
          <td>
              <img src="https://velog.velcdn.com/images/jakkujakku98/post/cac62fa3-a64f-4314-a995-c68ff2e574e6/image.gif" width="100%">
          </td>
      </tr>
  </tbody>
</table>

## 5. 에러와 에러 해결

- 지정한 시간에 알림이 안 오는 문제

## 상황

`Appdelegate`에 `Foreground`, `Background` 알림을 받을 수 있도록 설정한 후, 지정한 시간에 앱의 알림이 오도록 설정했지만,  알림이 오지 않는 문제가 발생했다.

## 목표

지정한 시간에 앱의 알림을 오도록 해야한다.

## **1차 행동(시도)**

1. 앱의 알림 기능을 담당할 `NotificationService`를 싱글톤 객체로 생성했다.(이유는 `NotificationCenter` 에 알림을 보내거나 삭제하는 기능만 전담하기 때문)

```swift
func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
   // 1️⃣ 알림 내용, 설정
   let notificationContent = UNMutableNotificationContent()
   notificationContent.title = title
   notificationContent.body = body

   // 2️⃣ 조건(시간, 반복)
   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

   // 3️⃣ 요청
   let request = UNNotificationRequest(identifier: identifier,
                                       content: notificationContent,
                                       trigger: trigger)

   // 4️⃣ 알림 등록
   UNUserNotificationCenter.current().add(request) { error in
       if let error = error {
           print("Notification Error: ", error)
       }
   }
}
```

1. `OnAppear` 과 `OnChange` 에서 `task` 의 알림여부와 `task` 의 현재시간과 현재 날짜가 같은지 검사하고, 같다면 알림을 전송하게 했다.

```swift
.onAppear(perform: {
     if task.isAlert.wrappedValue == true, task.creationDate.wrappedValue.format("YYYY-MM-dd hh:mm") == Date.now.format("YYYY-MM-dd hh:mm") {
         NotificationService.shared.pushNotification(title: task.taskTitle.wrappedValue, body: task.taskMemo.wrappedValue ?? "n/a", seconds: 1, identifier: task.id.uuidString)
         task.isAlert.wrappedValue?.toggle()
     }
 })

 .onChange(of: task.isAlert.wrappedValue) { oldValue, newValue in
     if task.isAlert.wrappedValue == true, task.creationDate.wrappedValue.format("YYYY-MM-dd hh:mm") == Date.now.format("YYYY-MM-dd hh:mm") {
         NotificationService.shared.pushNotification(title: task.taskTitle.wrappedValue, body: task.taskMemo.wrappedValue ?? "n/a", seconds: 1, identifier: task.id.uuidString)
         task.isAlert.wrappedValue?.toggle()
     }
 }
```

1. 당연히, 실패였다. 현재시간과 같을 때만 알림을 발생시켰다.

------

## 2차 행동(시도)

1. `Timer` 를 만들어, `Timer` 가 지속적으로 현재 시간을 발행하게 했다.

```swift
extension DateModel {
   func timeStart() {
       timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
           .autoconnect()
           .sink { [weak self] _ in
               self?.now = Date.now // 매초마다 현재 시간으로 업데이트
           }
   }

   func timeStop() {
       timerCancellable?.cancel()
   }
}
```

1. `View` 에서 `Timer` 를 `.onReceive` 를 사용해 계속 이벤트를 전달 받도록 했다.

```swift
.onReceive(dateContainer.model.$now, perform: { v in
     print("#### \\(v)")
     if task.isAlert.wrappedValue == true, task.creationDate.wrappedValue.format("YYYY-MM-dd hh:mm") == Date.now.format("YYYY-MM-dd hh:mm") {
         NotificationService.shared.pushNotification(title: task.taskTitle.wrappedValue, body: task.taskMemo.wrappedValue ?? "n/a", seconds: 1, identifier: task.id.uuidString)
         task.isAlert.wrappedValue?.toggle()
     }
 })
```

1. 앱의 `Timer`가 `Foreground`, `Background` 상황에서 정상적으로 돌아가는 것을 확인했고, 앱의 알림도 정상적으로 오는 것을 확인 했다.

------

## 3차 행동(시도)

- 원했던 ****결과를 얻었으나, **반쪽짜리**라는 것을 확인했다. 앱이 종료되면, `Timer` 역시, 종료되어 알림을 발생시키지 않는 것이다.

1. 코딩하던 것을 멈추고, 지금의 방법이 잘못된 것은 아닐까?? 하는 생각에 공식문서를 찾아봤다. 계속 공식문서를 읽어보던 중 `UNCalendarNotificationTrigger` 라는 것을 알게 되었고, 천천히 읽어본 결과, `UNUserNotificationCenter` 에 알림을 등록하기 전에, **지정해 놓은 시간에 알림을 발생시킨다**는 것을 확인하였다. 그래서 기존의 `UNTimeIntervalNotificationTrigger` → `UNCalendarNotificationTrigger` 변경 시켰다.

- 변경 전 코드

```swift
func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
   let notificationContent = UNMutableNotificationContent()
   notificationContent.title = title
   notificationContent.body = body

   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false) // 이 부분 변경

   let request = UNNotificationRequest(identifier: identifier,
                                       content: notificationContent,
                                       trigger: trigger)

   UNUserNotificationCenter.current().add(request) { error in
       if let error = error {
           print("Notification Error: ", error)
       }
   }
}
```

- 변경 후 코드

```swift
func pushNotification(date: Date, task: Task) {
    let content = UNMutableNotificationContent()
    content.title = "\\(switchNotificationSymbol(for: task.taskType)): " + task.taskTitle
    content.body = task.taskMemo ?? "N/A"
    content.badge = NSNumber(value: NotificationService.count + 1)
    content.sound = UNNotificationSound.default

    NotificationService.count += 1
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // 이 부분 변경
    let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("알림을 스케줄링하는 중 에러가 발생했습니다: \\(error)")
        } else {
            print("알림이 성공적으로 설정되었습니다.")
        }
    }
}
```

1. `View` 에서 `.OnAppear` 과 `.OnChange` 그리고 `.OnReceive` 부분을 삭제하였다. 더 이상 필요가 없기 때문이다.

## 결과

[Eisen_matrix Alert.mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/4a852067-92a5-4e08-bd8e-febf1e351430/f415efbd-eb7e-44fb-aefc-efb4cf02e832/Eisen_matrix_Alert.mp4)

정상적으로 원하는 시간에 `Foreground`, `Background`, `앱이 종료된 상황`에서도 알림을 받을 수 있게 되었다.

- 앱 알림 뱃지 처리 문제

## 상황

앱의 알림이 온 후, 앱의 알림을 확인하기 위해 앱을 실행 후, 들어가면 **앱 알림 뱃지 숫자가 초기화 되지 않는 문제**가 발생했다.

1. 앱의 알림이 도착, 앱 알림 뱃지가 1이 되었다.
2. 앱을 실행한 후, 다시 나왔다.
3. 앱 알림 뱃지가 1이 유지되고 있다. 0이 되어야 한다.

## 목표

증가한 숫자를 0으로 초기화 시키고, 앱 알림 뱃지를 없애야 한다.

## 1차 행동

1. `AppDelegate` 의 `applicationDidBecomeActive` 에 뱃지가 초기화 되도록 설정했다.

```swift
func applicationDidBecomeActive(_ application: UIApplication) {
    notificationBadgeReset()
}

private func notificationBadgeReset() {
    UNUserNotificationCenter.current().setBadgeCount(0) // 앱 알림 뱃지 초기화
    NotificationService.count = 0 // 알림 싱글톤 객체에 존해하는 Count 변수
}
```

1. 결과는 당연히, 실패였다. 시뮬레이터를 재실행하면, 그 때만 `applicationDidBecomeActive` 가 실행될 뿐, 앱을 종료후 다시 실행하였을 때는 작동하지 않았다.

------

## 2차 행동

1. `SwiftUI` 에는 `scenePhase` 라는 현재 `Scene`의 상태(=lifecycle)를 관리하는 값이 존재한다는 것을 공식문서와 구글링을 통해 알게 되었다. 그러면, 앱의 현재 상태를 간접적으로 알 수 있다는 것을 확인했다.
2. `scenePhase` 을 사용하는 변수를 만들어 `scenePhase` 의 변화를 수신하기로 했다.

```swift
@Environment(\\.scenePhase) private var phase

.onChange(of: phase) { _, _ in
    UNUserNotificationCenter.current().setBadgeCount(0)
    NotificationService.count = 0
}
```

## 결과

<img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/4a852067-92a5-4e08-bd8e-febf1e351430/1677ef2d-9dc3-49d2-9a19-83d643ddcb24/Eisen_matrix_ScenePhase.gif">

앱 알림 뱃지가 정상적으로 초기화 되는 것을 확인되었다.
