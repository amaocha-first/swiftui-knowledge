# Property Wrappersまとめ
- State
- Binding
- ObservedObject
- Published
- Environment
- EnvironmentObject
- FetchRequest

# Beta Property Wrappers(9/1)
- StateObject
- FocusedValue
- AppStorage
- SceneStorage

# State
Viewファイルで値の読み書きをする時に、Stateを使うと値の変更と同時にViewが自動的に再計算されるので、Viewの更新をしなくてよくなります。
Viewのbody内もしくは、View内のメソッドからのみアクセスできるように、基本的には`private`で宣言するようにしておきます。

```swift
struct ContentView: View {
    @State private var text = "before"

    var body: some View {
        VStack {
            Text(text)
            
            Button(action: {
                self.text = "after"
            }) {
                Text("change label")
            }
        }
        
    }
}

```
https://developer.apple.com/documentation/swiftui/state