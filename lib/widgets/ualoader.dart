import 'package:flutter/cupertino.dart';

class UALoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: CupertinoActivityIndicator(),
    );
  }
}
