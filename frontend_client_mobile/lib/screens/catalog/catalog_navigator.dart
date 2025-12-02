import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_detail_screen.dart';
import 'package:frontend_client_mobile/screens/catalog/catalog_screen.dart';
import 'package:frontend_client_mobile/screens/filter/filter_color_screen.dart';
import 'package:frontend_client_mobile/screens/filter/filter_material_screen.dart';
import 'package:frontend_client_mobile/screens/filter/filter_screen.dart';
import 'package:frontend_client_mobile/screens/filter/filter_size_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogNavigator extends StatefulWidget {
  const CatalogNavigator({super.key});

  @override
  State<CatalogNavigator> createState() => _CatalogNavigatorState();
}

class _CatalogNavigatorState extends State<CatalogNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final screenTheme = base.copyWith(
      textTheme: GoogleFonts.loraTextTheme(base.textTheme),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.lora(
          textStyle: base.textTheme.titleLarge?.copyWith(
            color: base.colorScheme.onPrimary,
          ),
        ),
      ),
    );
    return Theme(
      data: screenTheme,
      child: Material(
        color: Colors.transparent,
        child: Navigator(
          // (Bạn có thể dùng onGenerateRoute để linh hoạt hơn)
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                // Trang gốc của tab Catalog
                builder = (BuildContext _) => CatalogScreen();
                break;
              case '/details':
                final args = settings.arguments;
                if (args is Map<String, dynamic>) {
                  builder = (_) => CatalogDetailScreen(
                    filterParams: args,
                    categoryName: args['categoryName'] as String,
                    categoryId: args['categoryId'] as int,
                  );
                } else {
                  // Xử lý lỗi nếu không truyền tham số hoặc sai kiểu
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Missing Category ID')),
                    ),
                  );
                }
                break;
              case '/filter':
                final args = settings.arguments;
                if (args is Map<String, dynamic>) {
                  builder = (_) => FiltersPage(filterParams: args);
                } else {
                  // Xử lý lỗi nếu không truyền tham số hoặc sai kiểu
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Missing data')),
                    ),
                  );
                }
                break;
              case '/material':
                // Trang con (trang search) của tab Catalog
                builder = (BuildContext _) => FilterMaterialLayout();
                break;
              case '/color':
                // Trang con (trang search) của tab Catalog
                builder = (BuildContext _) => FilterColorLayout();
                break;
              case '/size':
                // Trang con (trang search) của tab Catalog
                builder = (BuildContext _) => FilterSizeLayout();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }
}
