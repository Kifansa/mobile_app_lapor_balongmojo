import 'package:flutter/material.dart';
import 'package:lapor_balongmojo/providers/auth_provider.dart';
import 'package:lapor_balongmojo/providers/laporan_provider.dart';
import 'package:lapor_balongmojo/screens/auth/login_screen.dart';
import 'package:lapor_balongmojo/screens/auth/register_masyarakat_screen.dart';
import 'package:lapor_balongmojo/screens/masyarakat/home_screen_masyarakat.dart';
import 'package:lapor_balongmojo/screens/perangkat/dashboard_screen_perangkat.dart';
import 'package:lapor_balongmojo/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, LaporanProvider>(
          create: (_) => LaporanProvider(),
          update: (ctx, auth, previousLaporan) {
            return LaporanProvider(); 
          },
        ),
      ],
      child: MaterialApp(
        title: 'Lapor Balongmojo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.status == AuthStatus.uninitialized) {
              return SplashScreen(); 
            }
            if (auth.status == AuthStatus.authenticated) {
              if (auth.userRole == 'perangkat') {
                return DashboardScreenPerangkat();
              }
              return HomeScreenMasyarakat();
            }
            return LoginScreen();
          },
        ),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegisterMasyarakatScreen.routeName: (ctx) => RegisterMasyarakatScreen(),
          HomeScreenMasyarakat.routeName: (ctx) => HomeScreenMasyarakat(),
          DashboardScreenPerangkat.routeName: (ctx) => DashboardScreenPerangkat(),
        },
      ),
    );
  }
}