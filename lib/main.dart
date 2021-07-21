import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main(){
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationAndroidSettings = AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationAndroidSettings);

  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
    print(payload);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Grouped Notification',
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
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Group Notification Creater'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final formKey = GlobalKey<FormState>();

  String channelID = 'ch101';
  String channelName = 'Channel 1';
  String channelDesc = 'channel Desc';
  
  String groupKey = 'groupkey101';

  int id = 1;

  //input controlers. 
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  Timer? timer;

  NotificationDetails getGroupNotifier(){
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation([], contentTitle: '$id messages', summaryText: 'shv@gmail.com');
    
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channelID, channelName, channelDesc, 
      styleInformation: inboxStyleInformation, 
      groupKey: groupKey, 
      playSound: false, 
      setAsGroupSummary: true
    );

    return NotificationDetails(android: androidNotificationDetails);
  }


/*

1. channelID 
2. GroupKey
3. SetAsGroupSummary // 10 notification, one of them should have setAsGroupSummary true. 

ChannelID -> groupKey -> setAsGroup 

*/


  void showSimpleNotification(String title, String body) async{
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channelID, 
    channelName, 
    channelDesc, 
    importance: Importance.defaultImportance, 
    priority: Priority.defaultPriority,
    groupKey: groupKey, 
    playSound: false);

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);

    id = id + 1;

    NotificationDetails groupNotification = getGroupNotifier();
    await flutterLocalNotificationsPlugin.show(0, 'Attention', '$id messages', groupNotification);

    
  }
  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    controller: title, 
                    decoration: InputDecoration(labelText: 'Notification title'),
                    validator: (value){
                      if(value!.isEmpty){
                        return "please provide a value";
                      }
                    },),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                  controller: content, 
                  decoration: InputDecoration(labelText: 'Notification content'),
                  validator: (value){
                    if(value!.isEmpty){
                      return "please provide a value";
                    }
                  },)
                ),
              ],
            )),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ElevatedButton(
              onPressed: (){
                if(formKey.currentState!.validate()){
                    print('valid form');
                    showSimpleNotification(title.value.text, content.value.text);
                }
              }, 
              child: Text('Create Group notifications')),
            ),
            Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ElevatedButton(
              onPressed: (){
                if(formKey.currentState!.validate()){
                  
                Timer.periodic(Duration(seconds: 5), (timer) {
                  showSimpleNotification(title.value.text, content.value.text);
                 });
                    
                }
              }, 
              child: Text('Create Group notifications every 30 seconds')),
            ),
        ],
      ) 
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
