import 'package:flutter/services.dart';
import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final cases = <(ConverterOption, String, String)>[
    (S2T(), '头发发展', '頭髮發展'),
    (T2S(), '頭髮發展', '头发发展'),
    (S2HK(), '里面的电脑', '裏面的電腦'),
    (HK2S(), '裏面的電腦', '里面的电脑'),
    (S2TW(), '里面的电脑', '裡面的電腦'),
    (TW2S(), '裡面的電腦', '里面的电脑'),
    (S2TWp(), '鼠标', '滑鼠'),
    (TW2Sp(), '滑鼠', '鼠标'),
  ];

  testWidgets(
      'all configurations use packaged dictionaries in both execution modes',
      (tester) async {
    await tester.runAsync(() async {
      for (final background in [false, true]) {
        for (final (option, source, expected) in cases) {
          expect(
              await ChineseConverter.convert(source, option,
                  inBackground: background),
              expected,
              reason: '${option.id}, background=$background');
          expect(
              await ChineseConverter.convert('', option,
                  inBackground: background),
              '');
          const unicode = 'English 12:34 😀 𠀀';
          expect(
              await ChineseConverter.convert(unicode, option,
                  inBackground: background),
              unicode);
        }
      }
      final concurrent = await Future.wait([
        for (final (option, source, _) in cases)
          ChineseConverter.convert(source, option, inBackground: true),
      ]);
      expect(concurrent, cases.map((entry) => entry.$3).toList());
    });
  });

  testWidgets('invalid calls return errors without breaking later conversion',
      (tester) async {
    await tester.runAsync(() async {
      const channel = MethodChannel('flutter_open_chinese_convert');
      await expectLater(
          channel.invokeMethod<String>('convert', []),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'MISSING_PARAMETER')));
      await expectLater(
          channel.invokeMethod<String>('convert', ['text', 'unknown', true]),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'INVALID_OPTION')));
      await expectLater(channel.invokeMethod<String>('unknown'),
          throwsA(isA<MissingPluginException>()));
      expect(await ChineseConverter.convert('广东话', S2HK(), inBackground: true),
          '廣東話');
    });
  });
}
