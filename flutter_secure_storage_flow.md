# Flutter Secure Storage - Flow Logic

## 📦 Instalasi

```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.2.4
```

> [!IMPORTANT]
> Untuk Android, pastikan `minSdk = 23` di `android/app/build.gradle.kts`

---

## 🔄 Flow Diagram

```mermaid
flowchart TD
    A[App Start] --> B{Check Token}
    B -->|Token Exists| C[Go to Profile Screen]
    B -->|No Token| D[Go to Login Screen]

    D --> E[User Input Email & Password]
    E --> F[Call Login API]
    F --> G{Login Success?}
    G -->|Yes| H[Save Token to Secure Storage]
    H --> I[Save User Data to Secure Storage]
    I --> C
    G -->|No| J[Show Error Message]
    J --> E

    C --> K[Load Profile from API]
    K --> L[Update User in Secure Storage]

    C --> M[Logout Button]
    M --> N[Clear Secure Storage]
    N --> D
```

---

## 🔐 API Service Methods

### 1. Inisialisasi Storage

```dart
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
```

### 2. Save Token

```dart
Future<void> saveToken(String token) async {
  await _secureStorage.write(key: 'token', value: token);
}
```

### 3. Get Token

```dart
Future<String?> getToken() async {
  return await _secureStorage.read(key: 'token');
}
```

### 4. Save User Data

```dart
Future<void> saveUser(User user) async {
  await _secureStorage.write(
    key: 'user',
    value: jsonEncode(user.toJson())
  );
}
```

### 5. Get User Data

```dart
Future<User?> getStoredUser() async {
  final userJson = await _secureStorage.read(key: 'user');
  if (userJson != null) {
    return User.fromJson(jsonDecode(userJson));
  }
  return null;
}
```

### 6. Clear Storage (Logout)

```dart
Future<void> clearStorage() async {
  await _secureStorage.delete(key: 'token');
  await _secureStorage.delete(key: 'user');
}
```

---

## 📱 Flow per Screen

### Login Flow

```mermaid
sequenceDiagram
    participant U as User
    participant L as LoginScreen
    participant A as ApiService
    participant S as SecureStorage
    participant API as Backend API

    U->>L: Input email & password
    L->>A: login(email, password)
    A->>API: POST /auth/user/login
    API-->>A: Response (token + user)
    A->>S: write('token', token)
    A->>S: write('user', userJson)
    A-->>L: Success
    L->>U: Navigate to ProfileScreen
```

### Auth Check Flow (App Start)

```mermaid
sequenceDiagram
    participant M as MainApp
    participant A as ApiService
    participant S as SecureStorage

    M->>A: isLoggedIn()
    A->>S: read('token')
    S-->>A: token / null
    A-->>M: true / false
    M->>M: Show ProfileScreen or LoginScreen
```

### Logout Flow

```mermaid
sequenceDiagram
    participant U as User
    participant P as ProfileScreen
    participant A as ApiService
    participant S as SecureStorage

    U->>P: Tap Logout
    P->>A: clearStorage()
    A->>S: delete('token')
    A->>S: delete('user')
    A-->>P: Done
    P->>U: Navigate to LoginScreen
```

---

## 🔒 Keamanan

| Platform    | Encryption Method                              |
| ----------- | ---------------------------------------------- |
| **Android** | EncryptedSharedPreferences (AES-256)           |
| **iOS**     | Keychain Services                              |
| **Web**     | sessionStorage / localStorage (⚠️ less secure) |
| **Windows** | Windows Credential Manager                     |
| **macOS**   | Keychain                                       |
| **Linux**   | libsecret                                      |

---

## ⚠️ Common Issues

### 1. Stuck di Loading (Android)

**Penyebab:** minSdk terlalu rendah  
**Solusi:** Set `minSdk = 23` di `build.gradle.kts`

### 2. Data Lama Masih Ada

**Penyebab:** Cache dari shared_preferences sebelumnya  
**Solusi:** Uninstall app lama, install ulang

### 3. Error "PlatformException"

**Penyebab:** Emulator tidak support secure storage  
**Solusi:** Gunakan device fisik atau emulator dengan API 23+
