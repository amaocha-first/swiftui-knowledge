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

また、`Binding`で参照しているプロパティは子ビュー側から変更することもできます。
```swift
struct CustomText: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.heavy)
                .foregroundColor(.purple)
                .shadow(radius: 1.0)
                .onTapGesture {
                    self.text = "changed in child view."
                    ///子ビューからも参照している親ビューの値を変更することができる
            }
        }
    }
}
```

# ObservedObject

`@State`だけではプロパティが乱立してしまうため、viewModel的な`@State`をまとめるようなことができる。
例えば、以下のようなログインViewがあるとする。

```swift
struct ObservedObjectView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("username", text: self.username)
            TextField("password", text: self.password)
        }
    }
}
```

これを、observedObjectを使って書くとこうなる。


```swift
struct ObservedObjectView: View {
    @ObservedObject private var loginParam = ObservedLoginParam()
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("username", text: self.$loginParam.username)
            TextField("password", text: self.$loginParam.password)
        }
    }
}

final class ObservedLoginParam: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
}
```

