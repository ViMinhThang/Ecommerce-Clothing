import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/filter_attributes.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:retrofit/retrofit.dart';
part 'filter_api_service.g.dart';
@RestApi()
abstract class FilterApiService {
  factory FilterApiService(Dio dio, {String? baseUrl}) = _FilterApiService;

  @GET("api/filter/{categoryId}")
  Future<FilterResponse> getFilterAttributes(
    @Path("categoryId") int categoryId,
  );

  @POST("api/filter/count/{categoryId}")
  Future<int> countProductAvailable(
    @Body() Map<String, dynamic> filters,
    @Path("categoryId") int categoryId,
  );

  @POST("api/filter/{categoryId}")
  Future<HttpResponse<PageResponse<ProductView>>> filter(
    @Body() Map<String, dynamic> filters,
    @Path("categoryId") int categoryId,
  );
}
