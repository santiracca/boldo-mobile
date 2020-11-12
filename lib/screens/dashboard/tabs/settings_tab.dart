import 'package:boldo/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../widgets/wrapper.dart';
import '../dashboard_screen.dart';
import '../../../provider/auth_provider.dart';
import '../../../constants.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return CustomWrapper(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Configuraciones',
                  textAlign: TextAlign.start,
                  style: boldoHeadingTextStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                leading: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/profile.svg',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Mi perfil', style: boldoSubTextStyle)
                    ],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {},
                leading: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/termsAndConditions.svg',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Términos de servicio',
                          style: boldoSubTextStyle)
                    ],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {},
                leading: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/privacyPolicy.svg',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Política de privacidad',
                          style: boldoSubTextStyle)
                    ],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {},
                leading: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/information.svg',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Acerca de nosotros', style: boldoSubTextStyle)
                    ],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {},
                leading: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/headphones.svg',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Centro de Ayuda', style: boldoSubTextStyle)
                    ],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              const SizedBox(
                height: 24,
              ),
              ListTile(
                onTap: () async {
                  Provider.of<AuthProvider>(context, listen: false)
                      .setAuthenticated(isAuthenticated: false);
                  const storage = FlutterSecureStorage();
                  await storage.deleteAll();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                },
                leading: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/powersettings.svg',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Cerrar sesión', style: boldoSubTextStyle)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
