import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
    @required this.size,
    @required this.title,
    @required this.asset,
    @required this.onPress,
    this.enabled = true,
  }) : super(key: key);

  final Size size;
  final String asset;
  final String title;
  final bool enabled;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
      child: InkWell(
        onTap: onPress,
        child: Container(
          height: size.width * 0.37,
          width: size.width * 0.37,
          padding: EdgeInsets.all(cDefaultPadding),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black45),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 3), blurRadius: 24)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: size.width * 0.37 / 2,
                child: ColorFiltered(
                  child: Image.asset(
                    asset,
                    fit: BoxFit.fitWidth,
                  ),
                  colorFilter: ColorFilter.mode(
                      enabled ? Colors.lightBlueAccent : Colors.white,
                      BlendMode.modulate),
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: enabled ? Colors.lightBlueAccent : Colors.white,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
