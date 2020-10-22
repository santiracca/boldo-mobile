import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../constant.dart';
import './tabs/HomeTab.dart';
import './tabs/DoctorsTab.dart';
import 'tabs/SettingTab.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    Key key,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Logger logger = Logger();
  FlutterAppAuth appAuth = FlutterAppAuth();
  int _selectedIndex = 0;

  GlobalKey scaffoldKey = GlobalKey();

  Future<void> authenticate() async {
    String keycloakRealmAddress = DotEnv().env['KEYCLOAK_REALM_ADDRESS'];
    String serverAddress = DotEnv().env['SERVER_ADDRESS'];

    FlutterAppAuth appAuth = FlutterAppAuth();

    final storage = FlutterSecureStorage();
    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest('boldo-doctor', 'com.penguin.boldo:/login',
            discoveryUrl:
                '$keycloakRealmAddress/.well-known/openid-configuration',
            scopes: ['openid'],
            allowInsecureConnections: true),
      );
      logger.i(result.idToken);
      logger.i(result.refreshToken);
      await storage.write(key: "accessToken", value: result.accessToken);
      await storage.write(key: "refreshToken", value: result.refreshToken);

      Provider.of<AuthProvider>(context, listen: false)
          .setAuthenticated(isAuthenticated: true);
      // Response response = await Dio().get(
      //     "$serverAddress/appauth?session_state=${result.authorizationAdditionalParameters["session_state"]}&code=${result.authorizationCode}&auth_callback=1&scope=openid&redirect_uri=com.penguin.boldo:/login");

      // final AuthorizationResponse result = await appAuth.authorize(
      //   AuthorizationRequest('boldo-doctor', "com.penguin.boldo:/login",
      //       discoveryUrl:
      //           '$keycloakRealmAddress/.well-known/openid-configuration',
      //       scopes: [
      //         'openid',
      //       ],
      //       allowInsecureConnections: true),
      // );
      //logger.i(result.authorizationCode);

      // Response response = await Dio().get(
      //     "$serverAddress/appauth?session_state=${result.authorizationAdditionalParameters["session_state"]}&code=${result.authorizationCode}&auth_callback=1&scope=openid&redirect_uri=com.penguin.boldo:/login");
      // Response response = await Dio().get(
      //     "$serverAddress/appauth?session_state=${result.authorizationAdditionalParameters["session_state"]}&code=${result.authorizationCode}&auth_callback=1&scope=openid&redirect_uri=com.penguin.boldo:/login");
      // await storage.write(
      //     key: "session", value: response.headers["set-session"] as String);

      // logger.i(response.data);
      // logger.i(response.statusCode);
      // logger.i(response.headers);

      // if (response.statusCode != 200) {
      //   setState(() {
      //     _selectedIndex = 0;
      //   });
      //   logger.e("ERROR");
      //   // final snackBar = SnackBar(
      //   //     content: Text('Authentication failed! No cookie availible'));
      //   // Scaffold.of(context).showSnackBar(snackBar);
      //   return;
      // }

      // var reduceResponse = response.headers["set-cookie"].fold({}, (prev, e) {
      //   var firstEl = e.split("; ")[0];

      //   var anotherArr = firstEl.split("=");

      //   prev[anotherArr[0]] = anotherArr[1];

      //   return prev;
      // });

      // if (reduceResponse == null || reduceResponse["connect.sid"] == null) {
      //   setState(() {
      //     _selectedIndex = 0;
      //   });
      //   logger.e("ERROR");
      //   // final snackBar = SnackBar(
      //   //     content: Text('Authentication failed! No cookie availible'));
      //   // Scaffold.of(context).showSnackBar(snackBar);
      //   return;
      // }

      // storage.write(key: "session", value: reduceResponse["connect.sid"]);
    } catch (err) {
      // final snackBar = SnackBar(content: Text('Authenticaton Failed!'));
      // Scaffold.of(context).showSnackBar(snackBar);
      logger.e(err);
    }
    setState(() {
      _selectedIndex = 0;
    });
  }

  Widget getPage(int index) {
    if (index == 0) {
      return HomeTab();
    }
    if (index == 1) {
      return DoctorsTab();
    }
    if (index == 2) {
      bool isAuthenticated =
          Provider.of<AuthProvider>(context, listen: false).getAuthenticated;
      if (!isAuthenticated) {
        authenticate();
        return Center(child: CircularProgressIndicator());
      }

      return SettingsTab();
    }
    return HomeTab();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: getPage(_selectedIndex),
        bottomNavigationBar:
            Consumer<AuthProvider>(builder: (context, myInstance, child) {
          bool isAuthenticated = myInstance.getAuthenticated;
          return BottomNavigationBar(
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icon/homeIcon.svg',
                  semanticsLabel: 'Doctor Icon',
                  color: _selectedIndex == 0
                      ? boldoDarkPrimaryColor
                      : boldoMainGrayColor,
                ),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icon/doctorIcon.svg',
                  semanticsLabel: 'Doctor Icon',
                  color: _selectedIndex == 1
                      ? boldoDarkPrimaryColor
                      : boldoMainGrayColor,
                ),
                label: 'Médicos',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  !isAuthenticated
                      ? 'assets/icon/profileIcon.svg'
                      : 'assets/icon/settingsIcon.svg',
                  semanticsLabel: 'Doctor Icon',
                  color: _selectedIndex == 2
                      ? boldoDarkPrimaryColor
                      : boldoMainGrayColor,
                ),
                label: !isAuthenticated ? 'Cuenta' : "Config",
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: boldoDarkPrimaryColor,
            onTap: (index) => setState(() {
              _selectedIndex = index;
            }),
          );
        }),
      ),
    );
  }
}
