import 'package:ev_hour/business/mine/widget/border_next_item.dart';
import 'package:ev_hour/business/remind/remind_history_page.dart';
import 'package:ev_hour/ui/app_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MineState();
}

class _MineState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/avatar.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.quotesAndSayings,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                child: Column(
                  children: [
                    BorderNextItem(
                      title: AppLocalizations.of(context)!.historyReminders,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      onTap: () {
                        RemindHistoryPage.router(context);
                      },
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).disabledColor,
                    ),
                    BorderNextItem(
                      title: AppLocalizations.of(context)!.privacyPolicy,
                      onTap: () {
                        AppWebView.router(
                            context,
                            AppLocalizations.of(context)!.privacyPolicy,
                            "https://eixxoi22ahh.feishu.cn/docx/QtpodGc5DovRsfxcuMiczc7cnAe");
                      },
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).disabledColor,
                    ),
                    BorderNextItem(
                      title: AppLocalizations.of(context)!.aboutUs,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      onTap: () {
                        AppWebView.router(
                            context,
                            AppLocalizations.of(context)!.aboutUs,
                            "https://eixxoi22ahh.feishu.cn/docx/Ixg1dwHkZoKHihxOHe3c8lQknVc");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
