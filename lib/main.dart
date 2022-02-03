import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String data = "hello world!";

  void updateData(newValue) {
    setState(() {
      data = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: MyText(data),
          ),
          body: Level1(),
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String data;

  MyText(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      // listen to changes in the Data model
      child: Text(Provider.of<Data>(context).data),
    );
  }
}

class Level1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Level2(),
    );
  }
}

class Level2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MyTextField(),
          Level3(),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(onChanged: (value) {
      // don't listen to changes made in Data Model since we
      // are performing a write operation
      Provider.of<Data>(context, listen: false).updateData(value);
    });
  }
}

class Level3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // listen to changes in the Data model
    return Text(Provider.of<Data>(context).data);
  }
}

class Data extends ChangeNotifier {
  String data = "hello world!";

  void updateData(newValue) {
    data = newValue;
    // notify widgets listening to this model to rebuild
    notifyListeners();
  }
}

/* 
Consider the following widget tree: 

            MyApp
           /     \
      MyText    Level1
                  |
                Level2
                /     \
               /       \
        MyTextField    Level3
        
Problem: Let's say we want to update content in Level3 widget & MyText widget
based on user input in MyTextField. For this to happen, we have to pass properties
& callbacks down from MyApp to Level3, making the app unnecessarily complicated
since Level1 & Level2 don't really need access to those properties. They 
are simply passing it down to level 3. 

Solution: To avoid this "prop drilling" problem, we will rely on the Provider
Package, which allows individual widgets to listen to changes made in the
state. Once change is made, they can re-build themselves based on the new values. 
*/

/* 
Problem: Updating state without Provider Package

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String data = "hello world!";

  void updateData(newValue) {
    setState(() {
      data = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: MyText(data),
        ),
        body: Level1(data, updateData),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String data;

  MyText(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.data),
    );
  }
}

class Level1 extends StatelessWidget {
  final String data;
  final Function updateDataCB;

  Level1(this.data, this.updateDataCB);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Level2(this.data, this.updateDataCB),
    );
  }
}

class Level2 extends StatelessWidget {
  final Function updateDataCB;
  final String data;

  Level2(this.data, this.updateDataCB);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MyTextField(this.updateDataCB),
          Level3(data),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final Function updateDataCB;
  MyTextField(this.updateDataCB);

  @override
  Widget build(BuildContext context) {
    return TextField(onChanged: (value) {
      updateDataCB(value);
    });
  }
}

class Level3 extends StatelessWidget {
  final String data;
  Level3(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(this.data);
  }
}
*/
