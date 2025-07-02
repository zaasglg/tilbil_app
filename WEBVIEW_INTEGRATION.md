# WebView Integration для Til Bil App

## Обзор

В приложении Til Bil App интегрированы WebView экраны для трех основных секций обучения:

1. **Сөздікқор (Словарь)** - `VocabularyWebViewScreen`
2. **Тренажер** - `TrainerWebViewScreen`  
3. **Видео сабақтар (Уроки)** - `LessonWebViewScreen`

## Структура файлов

```
lib/
├── screens/
│   └── lesson_detail/
│       ├── lesson_detail_screen.dart          # Главный экран урока
│       ├── vocabulary_webview_screen.dart     # WebView словаря
│       ├── trainer_webview_screen.dart        # WebView тренажера
│       ├── lesson_webview_screen.dart         # WebView видео уроков
│       └── vocabulary_screen.dart             # Офлайн словарь
└── models/
    └── lesson_topic.dart                      # Модели данных
```

## Функциональность WebView экранов

### Общие возможности:
- ✅ Загрузка веб-контента с индикатором прогресса
- ✅ Обработка ошибок загрузки
- ✅ Навигация (вперед/назад)
- ✅ Обновление страницы
- ✅ Возврат на главную страницу
- ✅ Нижняя панель навигации
- ✅ Меню с дополнительными опциями

### VocabularyWebViewScreen
- 🔍 Поиск слов на странице
- 📚 Загружает словарь конкретной темы
- 🎨 Цветовая схема: #4ECDC4 (бирюзовый)

### TrainerWebViewScreen  
- 💪 Интерактивные упражнения
- 🎯 Тренировочные задания
- 🎨 Цветовая схема: #FF6B6B (красный)

### LessonWebViewScreen
- 🎥 Видео уроки
- 🖥️ Полноэкранный режим для видео
- 🎨 Цветовая схема: #4DABF7 (голубой)

## URL Mapping

Каждая тема урока сопоставлена с соответствующими URL:

```dart
final topicMap = {
  'Сәлем, танысайық': 'https://tilqural.kz/lesson/1/[section]',
  'Менің отбасым': 'https://tilqural.kz/lesson/2/[section]',
  'Жасың нешеде': 'https://tilqural.kz/lesson/3/[section]',
  // ... и т.д.
};
```

Где `[section]` может быть:
- `vocabulary` - для словаря
- `trainer` - для тренажера  
- `video` - для видео уроков

## Навигация между экранами

### Из LessonDetailScreen:

1. **Сөздікқор** - показывает Bottom Sheet с выбором:
   - Офлайн сөздікқор (VocabularyScreen)
   - Онлайн сөздікқор (VocabularyWebViewScreen)

2. **Тренажер** - прямой переход к TrainerWebViewScreen

3. **Сабақ** - прямой переход к LessonWebViewScreen

## Требования

### Зависимости:
```yaml
dependencies:
  webview_flutter: ^4.4.2
```

### Android разрешения:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Дополнительные настройки Android:
```xml
android:usesCleartextTraffic="true"
android:hardwareAccelerated="true"
```

## Обработка ошибок

Все WebView экраны включают:

- ⚠️ Экран ошибки с описанием проблемы
- 🔄 Кнопка "Қайта жүктеу" для повторной попытки
- 📶 Проверка интернет-соединения
- 🎨 Красивый UI для ошибок с соответствующими иконками

## Особенности реализации

### Состояния загрузки:
```dart
bool _isLoading = true;        // Показать индикатор загрузки
String? _errorMessage;         // Сообщение об ошибке
```

### WebView контроллер:
```dart
late final WebViewController _controller;

_controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(NavigationDelegate(...))
  ..loadRequest(Uri.parse(url));
```

### Нижняя панель навигации:
- 🔙 Артқа (Назад)
- 🔜 Алға (Вперед)  
- 🔄 Жаңарту (Обновить)
- 🏠 Басты (Главная)
- 🔍 Іздеу (Поиск) - только для словаря
- 🖥️ Толық экран (Полный экран) - только для видео

## Локализация

Весь интерфейс переведен на казахский язык:
- Заголовки и кнопки
- Сообщения об ошибках
- Подсказки и описания
- Элементы меню

## Производительность

- ⚡ Lazy loading WebView контроллеров
- 🎯 Оптимизированные изображения и индикаторы
- 💾 Кэширование веб-контента
- 🔧 Аппаратное ускорение

## Тестирование

Для тестирования WebView экранов:

1. Убедитесь в наличии интернет-соединения
2. Проверьте доступность URL tilqural.kz
3. Протестируйте на разных размерах экранов
4. Проверьте поворот экрана
5. Тестируйте навигацию и обновление страниц

## Troubleshooting

### Проблема: WebView не загружается
**Решение:** Проверьте интернет-соединение и URL

### Проблема: JavaScript не работает
**Решение:** Убедитесь что `setJavaScriptMode(JavaScriptMode.unrestricted)`

### Проблема: Видео не воспроизводится
**Решение:** Проверьте `android:hardwareAccelerated="true"`

### Проблема: HTTPS mixed content
**Решение:** Используйте `android:usesCleartextTraffic="true"`

## Дальнейшее развитие

Планируемые улучшения:
- 📱 Поддержка офлайн режима
- 🔐 Аутентификация пользователей
- 📈 Отслеживание прогресса обучения
- 🔔 Push-уведомления о новых материалах
- 🎵 Аудио произношение слов
- 📊 Аналитика использования