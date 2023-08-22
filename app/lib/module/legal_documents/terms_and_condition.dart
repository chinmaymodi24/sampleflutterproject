import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      extendBody: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Color(0xFFD1E2FF),
        ],
      ),
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 70.0),
        child: CustomAppBarWithBack(
          title: "Terms & Condition", actions: [],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum mollis nunc a molestie dictum. Mauris venenatis, felis scelerisque aliquet lacinia, nulla nisi venenatis odio, id blandit mauris ipsum id sapien. Vestibulum malesuada orci sit amet pretium facilisis. In lobortis congue augue, a commodo libero tincidunt scelerisque. Donec tempus congue lacinia. Phasellus lacinia felis est, placerat commodo odio tincidunt iaculis. Sed felis magna, iaculis a metus id, ullamcorper suscipit nulla. Fusce facilisis, nunc ultricies posuere porttitor, nisl lacus tincidunt diam, vel feugiat nisi elit id massa. Proin nulla augue, dapibus non justo in, laoreet commodo nunc. Maecenas faucibus neque in nulla mollis interdum. Quisque quis pellentesque enim, vitae pulvinar purus. Quisque vitae suscipit risus. Curabitur scelerisque magna a interdum pretium. Integer sodales metus ut placerat viverra. Curabitur accumsan, odio quis vehicula imperdiet, tellus ex venenatis nisl, a dignissim lectus augue tincidunt arcu. \n\nFusce aliquam libero non venenatis lobortis. Vivamus euismod sollicitudin congue. Proin orci est, euismod nec nisi ut, faucibus dapibus diam. Suspendisse sodales volutpat posuere. Ut neque velit, placerat id commodo congue, aliquam quis risus. Praesent nibh ante, aliquet et viverra ut, luctus a felis. Vivamus efficitur orci erat, sed scelerisque diam accumsan sed. Aenean tincidunt erat lectus, venenatis condimentum magna interdum et. Nullam euismod orci eget tristique eleifend. Suspendisse eleifend felis vitae libero ultricies, non tempus lacus ornare. Mauris nibh dolor, vehicula at justo quis, egestas bibendum purus. Donec varius lorem at tincidunt aliquam. Nulla facilisi. Praesent condimentum, mi quis cursus sollicitudin, erat lacus ornare magna, quis cursus est erat in diam. In rutrum vel purus eget fermentum. Donec nec eros felis.     ",
                textAlign: TextAlign.justify,
                style: themes.light.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF595959),
                  height: 1.3,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
