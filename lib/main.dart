import 'package:flutter/material.dart';
import 'Constants/size_config.dart';
import 'Screens/TemperatureScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}
// void main (){
//   runApp(
//     MaterialApp(
//       home: MyApp(),
//     )
//   );
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return TemperatureScreen();

          },
        );
      },
    );
  }
}