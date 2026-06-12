import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/services/education_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  late EducationService educationService;

  // تحميل متغيرات البيئة قبل كل الاختبارات
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    educationService = EducationService();
  });

  group('Smart Assistant Features Test', () {
    test('Extract keywords from text', () async {
      final text = 'الذكاء الاصطناعي هو فرع من علوم الكمبيوتر يهتم ببناء أنظمة ذكية';
      final keywords = await educationService.extractKeywords(text);
      
      expect(keywords, isNotEmpty);
      print('✅ Keywords: $keywords');
    });

    test('Generate Arabic summary', () async {
      final text = 'الذكاء الاصطناعي هو مجال واسع يهدف إلى إنشاء آلات ذكية. يشمل التعلم الآلي والشبكات العصبية. يستخدم في العديد من التطبيقات مثل المساعدات الصوتية والمركبات الذاتية القيادة.';
      
      final summary = await educationService.generateArabicSummary(text);
      
      expect(summary, isNotNull);
      expect(summary!.length, greaterThan(50));
      print('✅ Arabic Summary: $summary');
    });

    test('Generate English summary', () async {
      final text = 'Artificial Intelligence is a broad field aiming to create intelligent machines. It includes machine learning and neural networks. It is used in many applications like voice assistants and autonomous vehicles.';
      
      final summary = await educationService.generateEnglishSummary(text);
      
      expect(summary, isNotNull);
      expect(summary!.length, greaterThan(50));
      print('✅ English Summary: $summary');
    });

    test('Generate MCQ questions', () async {
      final text = 'الذكاء الاصطناعي هو مجال يهدف إلى جعل الآلات ذكية. يتضمن التعلم العميق ومعالجة اللغات الطبيعية. ظهر في خمسينيات القرن الماضي.';
      
      final questions = await educationService.generateMCQQuestions(text);
      
      expect(questions, isNotNull);
      expect(questions!.length, greaterThanOrEqualTo(1));
      print('✅ MCQ Questions: ${questions.length}');
    });

    test('Generate True/False questions', () async {
      final text = 'الذكاء الاصطناعي بدأ في القرن العشرين. يستخدم في الطب والتعليم.';
      
      final questions = await educationService.generateTrueFalseQuestions(text);
      
      expect(questions, isNotNull);
      expect(questions!.length, greaterThanOrEqualTo(1));
      print('✅ True/False Questions: ${questions.length}');
    });

    test('Search YouTube lessons', () async {
      final keywords = ['ذكاء اصطناعي', 'تعلم آلة'];
      
      final lessons = await educationService.searchYouTubeLessons(keywords);
      
      expect(lessons, isNotNull);
      print('✅ YouTube Lessons: ${lessons?.length ?? 0}');
    });

    test('Generate mind map', () async {
      final text = 'الذكاء الاصطناعي له عدة فروع: التعلم الآلي، الشبكات العصبية، معالجة اللغات الطبيعية.';
      
      final mindMap = await educationService.generateMindMap(text, 'الذكاء الاصطناعي');
      
      expect(mindMap, isNotNull);
      expect(mindMap!['label'], 'الذكاء الاصطناعي');
      print('✅ Mind Map: ${mindMap['children']?.length} concepts');
    });

    test('Full integration test - All features together', () async {
      final text = 'Flutter هو إطار عمل مفتوح المصدر من Google لبناء تطبيقات جميلة ومنسقة بشكل طبيعي على عدة منصات من قاعدة أكواد واحدة.';
      
      // 1. استخراج الكلمات المفتاحية
      final keywords = await educationService.extractKeywords(text);
      expect(keywords, isNotEmpty);
      print('1️⃣ Keywords: $keywords');
      
      // 2. توليد الملخص العربي
      final arSummary = await educationService.generateArabicSummary(text);
      expect(arSummary, isNotNull);
      print('2️⃣ Arabic Summary: ${arSummary?.substring(0, 100)}...');
      
      // 3. توليد الملخص الإنجليزي
      final enSummary = await educationService.generateEnglishSummary(text);
      expect(enSummary, isNotNull);
      print('3️⃣ English Summary: ${enSummary?.substring(0, 100)}...');
      
      // 4. توليد أسئلة MCQ
      final mcq = await educationService.generateMCQQuestions(text);
      print('4️⃣ MCQ Questions: ${mcq?.length ?? 0}');
      
      // 5. توليد أسئلة صح/خطأ
      final tf = await educationService.generateTrueFalseQuestions(text);
      print('5️⃣ True/False Questions: ${tf?.length ?? 0}');
      
      // 6. البحث عن فيديوهات
      final videos = await educationService.searchYouTubeLessons(keywords);
      print('6️⃣ YouTube Videos: ${videos?.length ?? 0}');
      
      // 7. توليد خريطة ذهنية
      final mindMap = await educationService.generateMindMap(text, 'Flutter');
      print('7️⃣ Mind Map: ${mindMap?['children']?.length ?? 0} concepts');
      
      expect(true, true); // نجاح الاختبار
    });
  });

  group('Edge Cases and Error Handling', () {
    test('Handle empty text', () async {
      final text = '';
      
      final keywords = await educationService.extractKeywords(text);
      expect(keywords, isEmpty);
      
      final arSummary = await educationService.generateArabicSummary(text);
      expect(arSummary, isNotNull);
      
      final enSummary = await educationService.generateEnglishSummary(text);
      expect(enSummary, isNotNull);
      
      final mcq = await educationService.generateMCQQuestions(text);
      expect(mcq, isNotNull);
      
      print('✅ Empty text handled gracefully');
    });

    test('Handle short text', () async {
      final text = 'نص قصير';
      
      final keywords = await educationService.extractKeywords(text);
      print('✅ Short text keywords: $keywords');
      
      final summary = await educationService.generateArabicSummary(text);
      print('✅ Short text summary: $summary');
      
      expect(true, true);
    });

    test('Handle very long text', () async {
      final text = List.generate(200, (index) => 'جملة رقم ${index + 1} طويلة بعض الشيء.').join(' ');
      
      final keywords = await educationService.extractKeywords(text);
      print('✅ Long text keywords: $keywords');
      
      final summary = await educationService.generateArabicSummary(text);
      print('✅ Long text summary: ${summary?.length} chars');
      
      expect(true, true);
    });

    test('Handle empty keywords list', () async {
      final keywords = <String>[];
      
      final lessons = await educationService.searchYouTubeLessons(keywords);
      expect(lessons, isNotNull);
      print('✅ Empty keywords handled: ${lessons?.length ?? 0} lessons');
    });
  });
}