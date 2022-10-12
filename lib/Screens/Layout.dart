import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_scheduler/constants.dart';

class Layout extends StatelessWidget {
  final Widget child;
  final String pageText;
  const Layout({Key? key, required this.child, required this.pageText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.175),
                  decoration: const BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(25.0), child: child),
                ),
                Padding(
                  padding: const EdgeInsets.all(kMarginTopBottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pageText != "Add user") ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            kleftSvg,
                          ),
                        ),
                        const SizedBox(height: 13),
                      ],
                      Text(
                        pageText,
                        style: const TextStyle(
                            color: kTextColor,
                            fontSize: 25,
                            fontFamily: 'segoe-UI'),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
