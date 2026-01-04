import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:frontend_client_mobile/models/voucher.dart';

part 'voucher_api_service.g.dart';

@RestApi()
abstract class VoucherApiService {
  factory VoucherApiService(Dio dio, {String? baseUrl}) = _VoucherApiService;

  @GET('/api/vouchers')
  Future<List<Voucher>> getAllVouchers();

  @GET('/api/vouchers/{id}')
  Future<Voucher> getVoucherById(@Path('id') int id);

  @GET('/api/vouchers/code/{code}')
  Future<Voucher> getVoucherByCode(@Path('code') String code);

  @POST('/api/vouchers')
  Future<Voucher> createVoucher(@Body() Map<String, dynamic> voucher);

  @PUT('/api/vouchers/{id}')
  Future<Voucher> updateVoucher(@Path('id') int id, @Body() Map<String, dynamic> voucher);

  @DELETE('/api/vouchers/{id}')
  Future<void> deleteVoucher(@Path('id') int id);

  @POST('/api/vouchers/validate')
  Future<ValidateVoucherResponse> validateVoucher(@Body() Map<String, dynamic> request);

  @GET('/api/vouchers/active')
  Future<List<Voucher>> getActiveVouchers();
}
