import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoive_generator/pdf_page.dart';

Future main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Invoice';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primaryColor: Colors.blue , fontFamily: 'Roboto'),
    home: PdfPage(),
  );
}
