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
struct StateView: View {
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

# Binding
親のViewファイルの値を子のViewファイルに渡す時に、子Viewファイル側でBindingを使用して値を宣言しておきます。こうすることで、親Viewファイルの値の参照が子Viewファイルに渡ります。
子ViewのBindingの初期値は空にしておき、親Viewで子ビューをイニシャライズする時に`$`をつけて、`@State`プロパティを渡します。これを使えばViewファイルをいくらでも分割することができ、コンポーネント化できます。

```swift
struct BindingView: View {
    @State private var text = "before"

    var body: some View {
        VStack {
            CustomText(text: $text)
            
            Button(action: {
                self.text = "after"
            }) {
                Text("change label")
            }
        }
    }
}

struct CustomText: View {
    @Binding var text: String
    
    var body: some View {
        Text(text)
            .fontWeight(.heavy)
            .foregroundColor(.purple)
            .shadow(radius: 1.0)
    }
}
```
