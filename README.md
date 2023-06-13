# 계산기 ➕➖✖️➗
연산자 우선순위와 상관없이 입력 순서대로 계산해 주는 계산기 앱

> 프로젝트 기간: 2023-05-29 ~ 2023-06-09

## 🕺 팀원
|EtialMoon|
|:-:|
|<img src="https://i.imgur.com/hSdYobS.jpg" width="200"/>|
|[Github Profile](https://github.com/hojun-jo)|

</br>

## 📝 목차
1. [타임라인](#📆-타임라인)
2. [실행화면](#🖥️-실행-화면)
3. [다이어그램](#💎-다이어그램)
4. [트러블 슈팅](#🚀-트러블-슈팅)
5. [참고 링크](#📚-참고-링크)

</br>

# 📆 타임라인  
|**날짜**|**진행 사항**|
|:-:|-|
|2023-05-30|- CalculatorItemQueue 생성 및 단위 테스트 타깃 추가<br>- CalculatorItemQueue의 init 테스트 및 구현<br>- CalculatorItemQueue의 enqueue 테스트 및 구현<br>- CalculatorItemQueue의 dequeue 테스트 및 구현<br>- CalculatorItemQueue에서 제네릭 대신 any CalculateItem 사용|
|2023-05-31|- enqueue, dequeue 테스트에 문자열 테스트 케이스 추가<br>- dequeue 테스트 조건을 명확하게 수정|
|2023-06-02|- CalculatorItemQueue에서 any CalculateItem 대신 제네릭 사용<br>- Operator enum 생성<br>- Double에서 CalculateItem 채택 및 String에서 CalculateItem 해제|
|2023-06-03|- CalculatorItemQueue의 테스트 케이스 String에서 Double로 수정|
|2023-06-04|- CalculatorItemQueue의 count 테스트 및 구현<br>- Formula의 result 테스트 및 구현<br>- ExpressionParser의 componentsByOperators 테스트 및 구현<br>- ExpressionParser의 parse 테스트 및 구현<br>- ExpressionParser의 componentsByOperators 수정|
|2023-06-06|- String extension의 split에서 forEach를 map으로 변경<br>- 음수 계산을 위해 "-"연산자를 이모지(minus sign)로 변경<br>- ExpressionParser의 componentsByOperators내의 for문을 forEach로 변경<br>- ExpressionParser의 parse내의 for문을 forEach로 변경<br>- Formula의 result에 0으로 나눌 경우 에러를 던지도록 조건문 추가|
|2023-06-07|- Formula의 result 수행 로직 수정|
|2023-06-08|- ExpressionParser의 parse에서 operatorsQueue를 만드는 로직 수정<br>- Formula의 result에서 0으로 나눈 경우의 조건 수정|
|2023-06-09|- resetInputNumberLabel 메서드 추가<br>- resetInputOperatorLabel 메서드 추가<br>- resetAllInputStackView 메서드 추가<br>- resetFormulaString 메서드 추가<br>- tapNumpad 메서드 추가<br>- tapOperator 메서드 추가<br>- tapChangeSign 메서드 추가<br>- tapClearEntry 메서드 추가<br>- tapAllClear 메서드 추가<br>- tapZero 메서드 추가<br>- tapPoint 메서드 추가<br>- tapEqual 메서드 추가<br>- scrollToBottom 메서드 추가|
|2023-06-10|- makeNumberFormat 메서드 추가<br>- tapNumpad 수정<br>- tapOperator 수정|


</br>

# 🖥️ 실행 화면
![run1](https://github.com/hojun-jo/ios-calculator-app/assets/86751964/f9072eae-34db-4fd6-b6ed-c0286ef864ad)
![run2](https://github.com/hojun-jo/ios-calculator-app/assets/86751964/528408ef-2641-4e05-8c41-cd2b0d673d71)
![run3](https://github.com/hojun-jo/ios-calculator-app/assets/86751964/0da77300-1014-4442-bcb2-8bbc8a158669)


</br>

# 💎 다이어그램
![classdiagram](https://github.com/hojun-jo/ios-calculator-app/assets/86751964/17adf85d-20e8-48d6-a707-70880f2a70ce)




</br>

# 🚀 트러블 슈팅
## 1️⃣ CalculatorItemQueue의 자료구조

### 🔍 문제점

처음에는 배열만 이용해 큐를 만들려 시도했습니다. 이 경우 `dequeue`를 `removeFirst`를 이용해 구현하게 되는데 시간 복잡도가 `O(n)`이기 때문에 비효율적이라 생각했습니다. 그래서 `dequeue`를 하면 일단 배열의 값을 `nil`로 만들고 `nil`이 많이 쌓이게 되면 그때 지우려고 했습니다. 보통 계산기를 사용할 때 몇 십 번의 연산을 한 번에 하게 되는 일이 없을 것이라 생각해 이렇게 구현했습니다. 하지만 이 방법도 기준을 명확하게 정할 수 없다고 생각했습니다.
```swift
// 수정 전
struct CalculatorItemQueue {
    private(set) var queue: [String?] = []
    private var head: Int = 0
    
    mutating func enqueue(_ element: String) {
        queue.append(element)
    }
    
    mutating func dequeue() -> String? {
        guard head <= queue.count,
              !queue.isEmpty,
              let element = queue[head] else {
            return nil
        }
        
        queue[head] = nil
        head += 1
        
        if head > 50 {
            queue.removeFirst(head)
            head = 0
        }
        
        return element
    }
}
```

### ⚒️ 해결방안
`DoubleStack`이라는 자료구조를 발견했습니다. 이렇게 구현하면 `dequeue`를 할 때 처음 배열을 뒤집을 때는 `O(n)`이지만 그 뒤로는 `O(1)`이기 때문에 더 효율적인 것 같다고 생각했습니다.
```swift
// 수정 후
struct CalculatorItemQueue<Element: CalculateItem> {
    private(set) var enqueuedCalculatorItems: [Element] = []
    private(set) var dequeueCalculatorItems: [Element] = []
    
    init() {}
    
    init(_ enqueuedCalculatorItems: [Element]) {
        self.enqueuedCalculatorItems = enqueuedCalculatorItems
    }
    
    mutating func enqueue(_ element: Element) {
        enqueuedCalculatorItems.append(element)
    }
    
    @discardableResult
    mutating func dequeue() -> Element? {
        if dequeueCalculatorItems.isEmpty {
            dequeueCalculatorItems = enqueuedCalculatorItems.reversed()
            enqueuedCalculatorItems.removeAll()
        }
        
        return dequeueCalculatorItems.popLast()
    }
}
```

## 2️⃣ 제네릭 타입 사용 시 발생했던 오류

### 🔍 문제점
처음에는 `String`만 사용해 테스트를 진행하다가 제네릭을 사용하면 한 배열 안에 `Int`, `String` 모두 넣을 수 있을 것 같아 제네릭을 시도했습니다. 하지만 `Type 'any CalculateItem' cannot conform to 'CalculateItem'`이라는 오류를 만나 고민하게 되었습니다.
```swift
// 수정 전(CalculatorItemQueue는 위의 수정 후와 같습니다.)
final class CalculatorItemQueueTests: XCTestCase {
    var sut: CalculatorItemQueue<CalculateItem>! // 오류 발생

    override func setUpWithError() throws {
        sut = CalculatorItemQueue()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_init에1_2_3을넣으면_enqueuedCalculatorItems에1_2_3이있다() {
        let input = ["1", "2", "3"]
        
        sut = CalculatorItemQueue(input)
        let result = sut.enqueuedCalculatorItems
        
        XCTAssertEqual(input, result)
    }
    ...
}
```

### ⚒️ 해결방안
제네릭 대신 프로퍼티와 파라미터의 타입을 `any CalculateItem`로 바꾸는 것으로 수정하게 되었습니다. 하지만 `Any`는 모든 타입을 나타낼 수 있지만 타입 캐스팅이 필요하고 타입 캐스팅은 런타임에서 발생하기 때문에 오류를 찾기 힘들게 됩니다. 제네릭은 컴파일 타임에 타입이 지정되기 때문에 오류를 발견하기도 상대적으로 쉽습니다. 이러한 이유로 다시 제네릭을 사용하기로 결정했습니다.

```swift
// Any를 사용한 경우
struct CalculatorItemQueue {
    private(set) var enqueuedCalculatorItems: [any CalculateItem] = []
    ...
}

final class CalculatorItemQueueTests: XCTestCase {
    var sut: CalculatorItemQueue!

    override func setUpWithError() throws {
        sut = CalculatorItemQueue()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_init에1_2_3을넣으면_enqueuedCalculatorItems에1_2_3이있다() {
        let input = [1, 2, 3]
        
        sut = CalculatorItemQueue(input)
        let result = sut.enqueuedCalculatorItems as? [Int]
        
        XCTAssertEqual(input, result)
    }
    ...
}
```

```swift
// 제네릭을 사용한 경우
struct CalculatorItemQueue<Element: CalculateItem> {
    private(set) var enqueuedCalculatorItems: [Element] = []
    ...
}

final class CalculatorItemQueueTests: XCTestCase {
    var sut: CalculatorItemQueue<Double>!

    override func setUpWithError() throws {
        sut = CalculatorItemQueue()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_enqueuedCalculatorItems에1_2_3을넣으면_enqueuedCalculatorItems에1_2_3이있다() {
        for input in 1...3 {
            sut.enqueue(Double(input))
        }
        let expectation = [1.0, 2.0, 3.0]
        
        let result = sut.enqueuedCalculatorItems
        
        XCTAssertEqual(expectation, result)
    }
    ...
}
```


## 3️⃣ ExpressionParser의 parse내의 불필요한 변수들

### 🔍 문제점
불필요한 변수가 많아 코드의 가독성이 떨어지고 로직을 이해하기 힘들어지는 문제가 있었습니다.
```swift
static func parse(from input: String) throws -> Formula {
    let operands = componentsByOperators(from: input)
    var operators = [input]
    var formula = Formula()

    operands.forEach { operand in
        var splitOperators: [String] = []

        operators.forEach { element in
            let separatedElement = element.split(separator: operand).map{ String($0) }
            splitOperators.append(contentsOf: separatedElement)
        }

        operators = splitOperators
    }

    try operands.forEach { operand in
        guard let operand = Double(operand) else {
            throw ExpressionParserError.operandConvertError
        }

        formula.operands.enqueue(operand)
    }

    try operators.forEach { `operator` in
        guard let `operator` = Operator(rawValue: Character(`operator`)) else {
            throw ExpressionParserError.operatorConvertError
        }

        formula.operators.enqueue(`operator`)
    }

    return formula
}
```

### ⚒️ 해결방안
변수로 `operands`, `operator`의 큐를 만들어 두고 `return`에서 `Formula`를 초기화하며 `operands`, `operator`를 주입해 주는 등 수정을 거쳐 불필요한 변수를 지우고 가독성이 좋아지게 되었습니다.
```swift
static func parse(from input: String) throws -> Formula {
    var operandsQueue = CalculatorItemQueue<Double>()
    var operatorsQueue = CalculatorItemQueue<Operator>()

    try componentsByOperators(from: input).forEach { operand in
        guard let doubleOperand = Double(operand) else {
            throw ExpressionParserError.invalidOperand
        }

        operandsQueue.enqueue(doubleOperand)
    }

    input.map { $0 }.forEach {
        if let `operator` = Operator(rawValue: $0) {
            operatorsQueue.enqueue(`operator`)
        }
    }

    return Formula(operands: operandsQueue, operators: operatorsQueue)
}
```

## 4️⃣ 레이아웃 업데이트

### 🔍 문제점
계산기에 새로운 숫자를 입력하면 스크롤이 맨 아래로 내려가야 하는데 한 칸 위까지만 내려가는 문제가 있었습니다.

```swift
extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        
        setContentOffset(bottomOffset, animated: true)
    }
}

```

### ⚒️ 해결방안
레이아웃을 업데이트하기 위한 방법을 모르고 있었습니다. 다음 업데이트 사이클에 업데이트하려면 `setNeedsLayout()`을 사용할 수 있고, 즉시 업데이트하려면 `layoutIfNeeded()`를 사용할 수 있습니다. 이 경우에서는 즉이 업데이트가 필요하기 때문에 `layoutIfNeeded()`를 사용했습니다.
```swift
extension UIScrollView {
    func scrollToBottom() {
        self.layoutIfNeeded()
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        
        setContentOffset(bottomOffset, animated: true)
    }
}

```


</br>

# 📚 참고 링크

* [🍎 Apple Docs - Any Type](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types/#Any-Type)
* [🍎 Apple Docs - Generics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/)
* [🍎 Apple Docs - layoutSubviews()](https://developer.apple.com/documentation/uikit/uiview/1622482-layoutsubviews)
* [🍎 Apple Docs - setNeedsLayout()](https://developer.apple.com/documentation/uikit/uiview/1622601-setneedslayout)
* [🍎 Apple Docs - layoutIfNeeded()](https://developer.apple.com/documentation/uikit/uiview/1622507-layoutifneeded)
* [🌐 stackoverflow - Type any Protocol cannot conform to Protocol](https://stackoverflow.com/questions/75062360/type-any-protocol-cannot-conform-to-protocol)

</br>
