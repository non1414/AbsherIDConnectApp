//
//  AbsherConnectDemoView.swift
//  AbsherIDConnectApp
//
//  Created by نوف بخيت الغامدي on 09/06/1447 AH.
//
import SwiftUI

struct AbsherConnectDemoView: View {
    enum Step {
        case consent
        case processing
        case success
        case denied
    }
    
    @State private var step: Step = .consent
    @State private var selectedDuration: DurationOption = .sessionOnly
    
    // 🟢 سجل التفويضات
    @State private var consentLog: [ConsentLogEntry] = []
    @State private var showLogSheet = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color.green.opacity(0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            content
                .padding()
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: step)
    }
    
    @ViewBuilder
    private var content: some View {
        switch step {
        case .consent:
            consentView
        case .processing:
            processingView
        case .success:
            successView
        case .denied:
            deniedView
        }
    }
    
    // MARK: - شاشة طلب الموافقة
    
    private var consentView: some View {
        VStack(spacing: 20) {
            // هيدر
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield")
                        .font(.title3)
                        .foregroundColor(.green)
                    Text("Absher ID Connect")
                        .font(.headline)
                }
                Text("مشاركة ذكية لمعلومة حساسة واحدة فقط من بياناتك المالية.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)
            
            // زر فتح سجل التفويضات
            Button {
                showLogSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.caption)
                    Text("عرض سجل التفويضات")
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(999)
            }
            
            // كرت الجهة الطالبة
            requestingAppCard
            
            // كرت المعلومة المطلوبة
            requestedDataCard
            
            // كرت المدة
            durationCard
            
            // كرت يوضح ما لن يتم مشاركته
            notSharedCard
            
            Spacer()
            
            // الأزرار
            VStack(spacing: 12) {
                Button {
                    step = .processing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        step = .success
                        // نضيف للسجل حالة موافقة
                        appendLog(status: .approved)
                    }
                } label: {
                    Text("أوافق على مشاركة بيانات الدخل")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                
                Button {
                    step = .denied
                    // نضيف للسجل حالة رفض
                    appendLog(status: .denied)
                } label: {
                    Text("رفض الطلب")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
            }
        }
        .sheet(isPresented: $showLogSheet) {
            ConsentLogView(entries: consentLog)
        }
    }
    
    // MARK: - كرت الجهة الطالبة
    
    private var requestingAppCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: "building.columns")
                    .foregroundColor(.green)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("بنك تمويل شخصي تجريبي")
                    .font(.headline)
                Text("يحتاج التحقق من دخلك الشهري لتقييم أهلية طلب التمويل.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Text("موثوق")
                .font(.caption2)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.12))
                .foregroundColor(.green)
                .cornerRadius(999)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
    }
    
    // MARK: - كرت البيانات المطلوبة (التحقق من الدخل)
    
    private var requestedDataCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ما الذي سيُشارك؟")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.green)
                VStack(alignment: .leading, spacing: 4) {
                    Text("التحقق من الدخل الشهري فقط")
                        .font(.headline)
                    Text("سيتم التحقق من مبلغ راتبك الشهري من مصدره الرسمي بصيغة مختصرة، دون مشاركة مستندات أو تفاصيل حساباتك البنكية.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
    
    // MARK: - كرت مدة التفويض
    
    private var durationCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("مدة صلاحية التفويض")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(DurationOption.allCases, id: \.self) { option in
                    Button {
                        selectedDuration = option
                    } label: {
                        Text(option.label)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                selectedDuration == option ?
                                Color.green.opacity(0.15) :
                                Color(.secondarySystemBackground)
                            )
                            .foregroundColor(selectedDuration == option ? .green : .primary)
                            .cornerRadius(999)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    // MARK: - كرت ما لن يتم مشاركته (مهم هنا)
    
    private var notSharedCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("لن يتم مشاركة:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                labelWithIcon("كشف الحساب البنكي الكامل")
                labelWithIcon("تفاصيل القروض والأقساط")
                labelWithIcon("جهة عملك وتاريخ الوظائف")
                labelWithIcon("أي مستندات أو ملفات PDF")
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private func labelWithIcon(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "xmark.circle")
                .foregroundColor(.red.opacity(0.7))
            Text(text)
        }
    }
    
    // MARK: - شاشة المعالجة
    
    private var processingView: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .scaleEffect(1.8)
            Text("جاري التحقق من دخلك عبر Absher ID Connect…")
                .font(.body)
            Text("يتم الآن جلب بيانات الدخل من مصدرها الرسمي بصيغة مختصرة وآمنة.")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
    
    // MARK: - شاشة النجاح
    
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)
            
            Text("تمت مشاركة بيانات الدخل بنجاح")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("تم إرسال ملخص الدخل الشهري فقط إلى البنك وفق مدة التفويض التي اخترتها، دون مشاركة أي مستندات أو تفاصيل مالية إضافية.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button("إنهاء") {
                step = .consent
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(14)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - شاشة الرفض
    
    private var deniedView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "xmark.octagon.fill")
                .font(.system(size: 70))
                .foregroundColor(.red)
            
            Text("تم رفض مشاركة بيانات الدخل")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("لن يتم مشاركة أي بيانات مالية مع الجهة، ويمكنك دائمًا إعادة المحاولة أو اختيار جهة أخرى.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button("رجوع") {
                step = .consent
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .foregroundColor(.primary)
            .cornerRadius(14)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - إضافة سجل جديد
    
    private func appendLog(status: ConsentStatus) {
        let entry = ConsentLogEntry(
            serviceName: "بنك تمويل شخصي تجريبي",
            dataShared: "التحقق من الدخل الشهري",
            duration: selectedDuration,
            status: status,
            date: Date()
        )
        consentLog.insert(entry, at: 0) // الأحدث أولاً
    }
}

// MARK: - النماذج المساعدة

enum DurationOption: CaseIterable {
    case sessionOnly, oneHour, day
    
    var label: String {
        switch self {
        case .sessionOnly: return "هذه الجلسة فقط"
        case .oneHour:     return "ساعة واحدة"
        case .day:         return "يوم واحد"
        }
    }
}

enum ConsentStatus {
    case approved
    case denied
    
    var title: String {
        switch self {
        case .approved: return "موافق"
        case .denied:   return "مرفوض"
        }
    }
    
    var color: Color {
        switch self {
        case .approved: return .green
        case .denied:   return .red
        }
    }
}

struct ConsentLogEntry: Identifiable {
    let id = UUID()
    let serviceName: String
    let dataShared: String
    let duration: DurationOption
    let status: ConsentStatus
    let date: Date
}

// MARK: - واجهة سجل التفويضات

struct ConsentLogView: View {
    let entries: [ConsentLogEntry]
    
    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("لا يوجد أي تفويضات حتى الآن")
                            .font(.headline)
                        Text("سيتم عرض كل عملية موافقة أو رفض كعنصر في هذا السجل.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List(entries) { entry in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(entry.status.color.opacity(0.15))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: entry.status == .approved ? "checkmark" : "xmark")
                                        .foregroundColor(entry.status.color)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.serviceName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(entry.dataShared)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(entry.status.title)
                                    .font(.caption)
                                    .foregroundColor(entry.status.color)
                                
                                Text(entry.duration.label)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("سجل التفويضات")
        }
    }
}
