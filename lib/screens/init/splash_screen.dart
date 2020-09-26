import 'package:bapp/helpers/constants.dart';
import 'package:bapp/screens/init/initiating_widget.dart';
import 'package:bapp/stores/auth_store.dart';
import 'package:bapp/stores/location_store.dart';
import 'package:bapp/stores/storage_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return InitWidget(
      initializer: () async {
        await context.read<AuthStore>().init();
        await context.read<StorageStore>().init();
        await context.read<LocationStore>().init(context.read<AuthStore>());
      },
      onInitComplete: (){
        ///after doing things like loading from storage/checking for user go to main screen
        ///show onboarding screens if first time customer
        if(context.read<StorageStore>().isFirstLaunch==FirstLaunch.yes){
          Navigator.of(context).pushReplacementNamed("/onboarding");
          return;
        }
        ///customer is not a first timer
        Navigator.of(context).pushReplacementNamed("/");
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                height: 80,
                child: new SvgPicture.asset(
                  'assets/svg/logo.svg',
                  semanticsLabel: 'Ice Cream',
                ),
              ),
              Column(
                children: <Widget>[
                  new Text(
                    '$kAppName',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Book Appointments',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

