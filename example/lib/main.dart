import 'dart:math';

import 'package:draft_widget/draft_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _lockRatio = ValueNotifier<bool>(true);
  final _rotate = ValueNotifier<bool>(false);
  var _sketch = {
    2: {
      Component.position: const Rect.fromLTWH(100, 100, 100, 100),
      Component.widget: const ColoredBox(color: Colors.red),
      Component.angle: pi / 2,
    },
    1: {
      Component.position: const Rect.fromLTWH(150, 150, 200, 200),
      Component.widget: Image.asset('images/ending_dash.png'),
      Component.angle: pi / 4,
    },
    3: {
      Component.position: const Rect.fromLTWH(200, 200, 50, 50),
      Component.widget: const ColoredBox(color: Colors.blue),
      Component.lock: true,
    },
    4: {
      Component.position: const Rect.fromLTWH(250, 250, 50, 50),
      Component.widget: const ColoredBox(color: Colors.yellow),
      Component.visibility: false,
    },
  };

  final _focus = ValueNotifier<int>(noPosition);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => _lockRatio.value ^= true,
            icon: ValueListenableBuilder<bool>(
              valueListenable: _lockRatio,
              builder: (_, lockRatio, __) {
                return Icon(
                  Icons.aspect_ratio,
                  color: lockRatio ? Colors.black : Colors.grey,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () => _rotate.value ^= true,
            icon: ValueListenableBuilder<bool>(
              valueListenable: _rotate,
              builder: (_, rotate, __) {
                return Icon(
                  Icons.rotate_left,
                  color: rotate ? Colors.black : Colors.grey,
                );
              },
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Flexible(
            flex: 9,
            child: DraftWidget(
              focusState: _focus,
              lockRatio: _lockRatio,
              sketch: _sketch,
              rotate: _rotate,
              onTransform: (id, rect, angle) {
                setState(() {
                  _sketch = _sketch.map((key, value) => MapEntry(
                      key,
                      key == id
                          ? Map.fromEntries({
                              ...value.entries,
                              MapEntry(Component.position, rect),
                              MapEntry(Component.angle, angle),
                            })
                          : value));
                });
              },
            ),
          ),
          Container(
            width: 160,
            color: Colors.white,
            child: ListView.builder(
              itemBuilder: (_, index) {
                final entry = _sketch.entries.elementAt(index);
                final visibility =
                    entry.value[Component.visibility] as bool? ?? true;
                final lock = entry.value[Component.lock] as bool? ?? false;
                return ListTile(
                  leading: IconButton(
                    icon: Icon(lock ? Icons.lock : Icons.lock_open),
                    onPressed: () {
                      setState(() {
                        _sketch = _sketch.map((id, widget) => MapEntry(
                            id,
                            id == entry.key
                                ? Map.fromEntries({
                                    ...widget.entries,
                                    MapEntry(Component.lock, !lock)
                                  })
                                : widget));
                      });
                    },
                  ),
                  title: Text('${entry.key}'),
                  trailing: IconButton(
                    icon: Icon(
                        visibility ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _sketch = _sketch.map((id, widget) => MapEntry(
                            id,
                            id == entry.key
                                ? Map.fromEntries({
                                    ...widget.entries,
                                    MapEntry(Component.visibility, !visibility)
                                  })
                                : widget));
                      });
                    },
                  ),
                );
              },
              itemCount: _sketch.length,
            ),
          )
        ],
      ),
    );
  }
}
