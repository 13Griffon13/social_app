import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:social_app/locales/strings.dart';

@RoutePage()
class TermsAndConditionsScreen extends StatefulWidget {
  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late String termsAndConditions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.termsOfServiceButton),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
            future: rootBundle.loadString('assets/terms_and_conditions.html'),
            builder: (context, future) {
              if (future.hasData) {
                return HtmlWidget(future.data!);
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
