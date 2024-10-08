import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/event_screen.dart';
import 'package:todo/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => TodoProvider(),child: const MainScreens(),);
  }
}

class MainScreens extends StatelessWidget {
  const MainScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings){
        switch (settings.name){
          case HomeScreen.routeName:
            return MaterialPageRoute(builder: (context){
              return const HomeScreen();
            },
              settings:const RouteSettings(
                name: HomeScreen.routeName,
              )
            );
          case EventScreen.routeName:
            return MaterialPageRoute(builder: (context){
              return EventScreen(todo: settings.arguments as Todo?);
            },
                settings:const RouteSettings(
                  name: EventScreen.routeName,
                )
            );
          default:
            return null;
        }
      },
    );
  }
}
