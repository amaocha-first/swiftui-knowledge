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

# ObservedObjectとPublished

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

# StateObject（iOS14.0以降)

上記の`ObservedObservedObject`を使うとViewの表示時に毎回初期化してしまう問題があるので、基本的には`@StateObject`を使うようにします。

```swift
final class Counter: ObservableObject {
    @Published var count: Int = 0
}

//親View
struct StateObjectView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("ContentView")
            Text("\(count)")
            ChildView() 
            //ChildViewは下のself.count += 1を行うと初期化されてしまうので、ChildViewの中のcounterは0に戻ってしまう。
            Button("increment") {
                self.count += 1
            }
        }
        .padding()
        .background(Color.red)
    }
}

//子View
struct ChildView: View {
    @ObservedObject var counter = Counter()
    //iOS14.0以降ではStateObjectが使えるので、そちらを使う。
    
    var body: some View {
        VStack {
            Text("CounterView")
            Text("\(counter.count)")
            Button("increment") {
                self.counter.count += 1
            }
        }
        .padding()
        .background(Color.yellow)
    }
}
```

# Environment

環境変数を操作するもの。
以下のようにすると値をViewで読み込める。
```swift
struct ContentView: View {
    @Environment(\.font) var font: Font
    var body: some View {
        Text("Hello World")
    }
}
```
イニシャライズ時に外から渡してあげる。
```swift
ContentView()
        .environment(\.font, .largeTitle)
```

環境変数は多数あるので、以下記事参照。

参考：https://qiita.com/1amageek/items/59c6bb32a6627b4fb712

# EnvironmentObject

View階層の中で共通のObservableObjectを持てるようにしたもの。
`＠ObservedObject`は子Viewへデータを渡すのにinitを使用してViewの階層を辿っていく必要がありましたが、`＠EnvironmentObject`を使うとその必要なしに値を参照することができます。


```swift
class UserSettings: ObservableObject {
    @Published var score = 0
}

struct EnvironmentObjectView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView {
            VStack {
                //Environmentのスコアに書き込む
                Button(action: {
                    self.settings.score += 1
                }) {
                    Text("Increase Score")
                }

                //DetailView()のイニシャライズ時にUserSettingsの設定がいらない
                NavigationLink(destination: DetailView()) {
                    Text("Show Detail View")
                }
            }
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        //Environmentのスコアを表示
        Text("Score: \(settings.score)")
    }
}
```

一番親のViewを初期化するタイミングでEnvironmentObjectを入れてあげます。
```swift
EnvironmentObjectView().environmentObject(UserSettings())
```
参考：https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views

# FetchRequest

`@FetchRequest`を使うと、CoreDataとSwiftUIのViewを直接結びつけることできます。

宣言時はこんな感じ
```swift
@FetchRequest(
    entity: User.entity(),
    sortDescriptors: []
) var users: FetchedResults<User>
```

詳しくは、以下記事参照
- https://qiita.com/coe/items/0f0585f314ab2624f548
- https://note.com/dngri/n/n26e807c880db

# AppStorage(iOS14以降)
Userdefaultsの値を直接やりとりできる。

```swift
struct ContentView: View {

    @AppStorage(wrappedValue: "Tokyo", "currentCity")
    var currentCity

    var body: some View {
        Text(currentCity).padding()
        TextField("", text: $currentCity)
    }

}
```

https://qiita.com/MaShunzhe/items/40bf67cdd709c17b599f

# SceneStorage(iOS14以降)
iOS14以降では複数のSceneが存在していて、それぞれでそのシーンの状態を保存することができる。

例えば、以下は画面遷移をしてもテキストエディターの内容を保存しておく例です。
```swift
struct ContentView: View {
    @SceneStorage("text") var text = ""

    var body: some View {
        NavigationView {
            TextEditor(text: $text)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
```

画面ごとに一意のデータを保存する場合に使用し、UserDefaultsの代わりに復元に使用できる。
注意点としては、
- 大量のデータを保存しない。状態の復元に必要なものだけ保存する。
- 機密データを保存しない。
- アップスイッチャーでアプリを破棄すると、scence storageの内容も破棄される。

参考：https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-scenestorage-property-wrapper