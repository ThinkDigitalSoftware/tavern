import 'package:bloc/bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/home/home.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/screens/publisher_package/publisher_page_repository.dart';
import 'package:tavern/screens/settings/settings_screen.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/src/pub_colors.dart';
import 'package:tavern/widgets/material_search.dart';

import 'screens/publisher_package/publisher_bloc.dart';
import 'screens/publisher_package/publisher_package.dart';
import 'screens/publisher_package/publisher_state.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();

  final libraryDir = await getApplicationDocumentsDirectory();
  Hive.init("${libraryDir.path}/hive");

  PubHtmlParsingClient _htmlParsingClient;
  final getIt = GetIt.instance;
  _htmlParsingClient = PubHtmlParsingClient();
  getIt
    ..registerSingleton<PubHtmlParsingClient>(_htmlParsingClient)
    ..registerSingleton<FullPackageRepository>(
      FullPackageRepository(client: _htmlParsingClient),
    )
    ..registerSingleton(PublisherPageCache.instance);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) =>
              HomeBloc(client: _htmlParsingClient),
        ),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => SettingsBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (BuildContext context) =>
              SearchBloc(client: _htmlParsingClient),
        ),
        BlocProvider<SubscriptionBloc>(
          create: (BuildContext context) =>
              SubscriptionBloc(client: _htmlParsingClient),
        ),
        BlocProvider<PublisherBloc>(
          create: (BuildContext context) =>
              PublisherBloc(client: _htmlParsingClient),
        ),
      ],
      child: PubDevClientApp(),
    ),
  );
}

class PubDevClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) =>
          PubColors.theme(brightness: brightness, context: context),
      themedWidgetBuilder: (context, theme) {
        bool isLight = theme.brightness == Brightness.light;

        final systemUiOverlayStyle =
            isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
        return MaterialApp(
          theme: theme,
          title: "Tavern",
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.root,
          onGenerateRoute: (RouteSettings routeSettings) {
            switch (routeSettings.name) {
              case Routes.root:
                {
                  return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocBuilder<HomeBloc, HomeState>(
                      builder: (BuildContext context, HomeState state) =>
                          Home(homeState: state),
                    ),
                  );
                }

              case Routes.searchScreen:
                {
                  return SearchPageRoute(
                    delegate: routeSettings.arguments,
                  );
                }
              case Routes.publisherPackageScreen:
                {
                  final publisherName = routeSettings.arguments;

                  return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocBuilder<PublisherBloc, PublisherState>(
                      builder: (BuildContext context, PublisherState state) =>
                          PublisherPackagesPage(
                        publisher: publisherName,
                        publisherState: state,
                      ),
                    ),
                  );
                }
              case Routes.settingsScreen:
                {
                  return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (BuildContext context, SettingsState state) =>
                          SettingsScreen(state: state),
                    ),
                  );
                }
              case Routes.packageDetailsScreen:
                {
                  final packageDetailsArguments =
                      routeSettings.arguments as PackageDetailsArguments;
                  assert(packageDetailsArguments is PackageDetailsArguments);
                  return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocProvider<PackageDetailsBloc>(
                      create: (context) => PackageDetailsBloc(
                        package: packageDetailsArguments.package,
                      ),
                      child: PackageDetailsScreen(),
                    ),
                  );
                }
              default:
                {
                  return MaterialPageRoute(builder: (BuildContext context) {
                    return Material(
                      child: Center(
                        child: Text(
                            "Sorry, we've encountered an error!\n Please open a ticket at our repo."),
                        //TODO: Add a link to do so with pre-filled information
                      ),
                    );
                  });
                }
            }
          },
        );
      },
    );
  }
}
