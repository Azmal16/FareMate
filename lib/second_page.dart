import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

class SecondPage extends StatelessWidget {
  final String payload;

  const SecondPage({
    @required this.payload,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You travelled $payload meters.',
                style: Theme.of(context).textTheme.title,
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              RaisedButton(
                  child: Text('Back'),
                  onPressed: () {
                    notifications.cancelAll();
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      );
}
