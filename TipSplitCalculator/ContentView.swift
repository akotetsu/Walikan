import SwiftUI

struct ContentView: View {
    // 合計金額（文字列）
    @State private var billAmount: String = ""
    // 人数（デフォルト2人）
    @State private var numberOfPeople: Int = 2
    // アニメーション用フラグ
    @State private var animateResult: Bool = false

    // 一人あたりの支払額を計算
    private var amountPerPerson: Double {
        let amount = Double(billAmount) ?? 0
        return amount / Double(numberOfPeople)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // 背景のグラデーション
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // 合計金額カード
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.accentColor)
                                Text("合計金額")
                                    .font(.headline)
                            }
                            TextField("¥0", text: $billAmount)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)

                        // 人数カード
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.accentColor)
                                Text("人数")
                                    .font(.headline)
                            }
                            Stepper(value: $numberOfPeople, in: 1...20) {
                                Text("\(numberOfPeople) 人")
                                    .font(.body)
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)

                        // 結果カード
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(.accentColor)
                                Text("一人あたり")
                                    .font(.headline)
                            }
                            Text("¥\(amountPerPerson, specifier: "%.0f")")
                                .font(.system(size: 48, weight: .bold))
                                .scaleEffect(animateResult ? 1.1 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animateResult)
                                .onChange(of: amountPerPerson) { _ in
                                    animateResult.toggle()
                                }
                        }
                        .padding()
                        .background(BlurView(style: .systemThinMaterial))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .padding()
                }
                .toolbar {
                    // キーボードを閉じるDoneボタン
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }
            }
            .navigationTitle("割り勘電卓")
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

// UIKitのUIVisualEffectViewをSwiftUIで使うためのラッパー
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
#endif

#Preview {
    ContentView()
}

