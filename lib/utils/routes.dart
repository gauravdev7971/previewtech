
import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../screens/history.dart';


class Routes{
  static const String dashboard = '/dashboard';
  static const String history = '/history';


  static Route<dynamic> generateRoute(RouteSettings settings){
    if(settings.name == dashboard){
      Map<String, dynamic>? data;
      if(settings.arguments!=null){
        data = settings.arguments as Map<String, dynamic>;
      }
      debugPrint('debugData002 ${data==null}, ${settings.arguments==null}');
      return _customPageRoute(Dashboard(prevData: data!=null ? data['item'] : null));
    }
    else if(settings.name == history){
      return _customPageRoute(History());
    }
    else{
      return _customPageRoute(Dashboard());
    }
  }
}

PageRouteBuilder _customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.decelerate;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}