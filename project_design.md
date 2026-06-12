# تصميم هيكل مشروع Larry Soft وقاعدة البيانات

بناءً على تحليل المتطلبات من المحاضرات المرفقة، سيتم تصميم هيكل المشروع وقاعدة البيانات لضمان تطبيق فعال ومنظم.

## 1. هيكل المشروع (Flutter Project Structure)

سيتم تنظيم المشروع باستخدام بنية واضحة لسهولة التطوير والصيانة. الهيكل المقترح هو كالتالي:

```
larry_soft_app/
├── lib/
│   ├── main.dart
│   ├── models/                  # تعريف نماذج البيانات (User, Product, CartItem)
│   │   ├── user.dart
│   │   ├── product.dart
│   │   └── cart_item.dart
│   ├── services/                # الخدمات مثل قاعدة البيانات وإدارة الحالة
│   │   ├── database_helper.dart # إدارة قاعدة بيانات Sqflite
│   │   ├── auth_service.dart    # خدمة تسجيل الدخول والمصادقة
│   │   └── theme_service.dart   # خدمة إدارة الثيم (فاتح/داكن)
│   ├── providers/               # لإدارة الحالة (باستخدام Provider أو Riverpod)
│   │   ├── auth_provider.dart
│   │   ├── product_provider.dart
│   │   └── cart_provider.dart
│   ├── screens/                 # واجهات المستخدم الرئيسية
│   │   ├── auth/                # شاشات تسجيل الدخول والتسجيل
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home_screen.dart     # الشاشة الرئيسية (تحتوي على المنتجات)
│   │   ├── product_detail_screen.dart # شاشة تفاصيل المنتج
│   │   ├── cart_screen.dart     # شاشة سلة التسوق
│   │   └── settings_screen.dart # شاشة الإعدادات
│   ├── widgets/                 # المكونات (Widgets) القابلة لإعادة الاستخدام
│   │   ├── product_card.dart
│   │   └── cart_item_card.dart
│   └── utils/                   # أدوات مساعدة (ثوابت، تنسيقات، إلخ)
│       └── app_constants.dart
├── assets/
│   ├── images/                  # صور المنتجات والأيقونات
│   └── fonts/                   # الخطوط المخصصة (إن وجدت)
├── pubspec.yaml                 # ملف تعريف المشروع والتبعيات
└── README.md
```

## 2. تصميم قاعدة البيانات Sqflite

ستتكون قاعدة البيانات من ثلاثة جداول رئيسية: `users`، `products`، و `cart_items`.

### 2.1. جدول `users` (المستخدمون)

يستخدم لتخزين معلومات تسجيل الدخول للمستخدمين.

| اسم العمود    | نوع البيانات | قيود                                | الوصف                                |
| :------------ | :---------- | :---------------------------------- | :----------------------------------- |
| `id`          | `INTEGER`   | `PRIMARY KEY AUTOINCREMENT`         | معرف المستخدم الفريد                 |
| `username`    | `TEXT`      | `NOT NULL UNIQUE`                   | اسم المستخدم (يجب أن يكون فريداً)   |
| `password`    | `TEXT`      | `NOT NULL`                          | كلمة المرور المشفرة (أو المخزنة)     |
| `email`       | `TEXT`      | `UNIQUE`                            | البريد الإلكتروني (اختياري، فريد)    |
| `isLoggedIn`  | `INTEGER`   | `DEFAULT 0`                         | حالة تسجيل الدخول (0: غير مسجل، 1: مسجل) |
| `themeMode`   | `INTEGER`   | `DEFAULT 0`                         | وضع الثيم (0: نظام، 1: فاتح، 2: داكن) |

### 2.2. جدول `products` (المنتجات)

يستخدم لتخزين معلومات المنتجات المتاحة في المتجر.

| اسم العمود    | نوع البيانات | قيود                                | الوصف                                |
| :------------ | :---------- | :---------------------------------- | :----------------------------------- |\n| `id`          | `INTEGER`   | `PRIMARY KEY AUTOINCREMENT`         | معرف المنتج الفريد                   |
| `name`        | `TEXT`      | `NOT NULL`                          | اسم المنتج                           |
| `description` | `TEXT`      |                                     | وصف المنتج                           |
| `price`       | `REAL`      | `NOT NULL`                          | سعر المنتج                           |
| `imageUrl`    | `TEXT`      | `NOT NULL`                          | المسار المحلي لصورة المنتج          |
| `category`    | `TEXT`      | `DEFAULT 'General'`                 | فئة المنتج                           |

### 2.3. جدول `cart_items` (عناصر السلة)

يستخدم لتخزين المنتجات التي أضافها المستخدم إلى سلة التسوق.

| اسم العمود    | نوع البيانات | قيود                                | الوصف                                |
| :------------ | :---------- | :---------------------------------- | :----------------------------------- |
| `id`          | `INTEGER`   | `PRIMARY KEY AUTOINCREMENT`         | معرف عنصر السلة الفريد               |
| `productId`   | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`           | معرف المنتج المرتبط (من جدول `products`) |
| `userId`      | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`           | معرف المستخدم المرتبط (من جدول `users`) |
| `quantity`    | `INTEGER`   | `NOT NULL`, `DEFAULT 1`             | كمية المنتج في السلة                 |

### 2.4. العلاقات (Relationships)

- **`users` و `cart_items`**: علاقة واحد إلى متعدد (One-to-Many). المستخدم الواحد يمكن أن يكون لديه عدة عناصر في السلة.
- **`products` و `cart_items`**: علاقة واحد إلى متعدد (One-to-Many). المنتج الواحد يمكن أن يظهر في سلة عدة مستخدمين.

## 3. نماذج البيانات (Data Models)

سيتم إنشاء فئات Dart لكل جدول لتمثيل البيانات وتسهيل التعامل معها داخل التطبيق:

- `User` Model: لتمثيل بيانات المستخدم.
- `Product` Model: لتمثيل بيانات المنتج.
- `CartItem` Model: لتمثيل عنصر في سلة التسوق.

ستحتوي هذه الفئات على دوال `fromJson` و `toJson` (أو `toMap` و `fromMap`) لتسهيل التحويل بين كائنات Dart وخرائط البيانات التي تتعامل معها قاعدة البيانات `sqflite`.

## 4. خدمة قاعدة البيانات (Database Service)

سيتم إنشاء فئة `DatabaseHelper` لإدارة جميع عمليات قاعدة البيانات، بما في ذلك:

- تهيئة قاعدة البيانات (`initDatabase`).
- إنشاء الجداول (`_onCreate`).
- إضافة، تحديث، حذف، واستعلام البيانات من الجداول (`insertUser`, `getProduct`, `updateCartItem`, `deleteProduct`, إلخ).

هذا التصميم يضمن فصل الاهتمامات (Separation of Concerns) ويجعل الكود أكثر قابلية للقراءة والصيانة والتوسع.
