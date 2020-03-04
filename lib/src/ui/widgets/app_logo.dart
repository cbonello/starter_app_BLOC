import 'package:flutter/material.dart';
import 'package:starter_app/src/utils/constants.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key key, this.scaleFactor = 1.0}) : super(key: key);

  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: APP_ASSET_LOGO,
          child: Image(
            height: 120.0 * scaleFactor,
            fit: BoxFit.fill,
            image: const AssetImage(APP_ASSET_LOGO),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            APP_NAME,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ],
    );
  }
}