import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/app/services/marker_service.dart';
import 'package:bikynav/features/nav/app/services/services.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/app/helpers/real_time_provider.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:bikynav/shared/services/socket_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bikynav/shared/router/app_router.dart';
import 'package:bikynav/shared/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar Firestore
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    host: 'firestore.googleapis.com',
    sslEnabled: true,
  );
  
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc() ),
      BlocProvider(create: (context) => LocationBloc() ), 
      BlocProvider(create: (context) => MapBloc( locationBloc: BlocProvider.of<LocationBloc>( context ) ) ),
      BlocProvider(create: (context) => SearchBloc( trafficService: TrafficService() ) )
      ], 
    child: const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => UserServices()),
        ChangeNotifierProvider(create: (_) => BikeServices()),
        ChangeNotifierProvider(create: (_) => RouteServices()),
        ChangeNotifierProvider(create: (_) => StopwatchProvider()),
        ChangeNotifierProvider(create: (_) => MarkerServices()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
