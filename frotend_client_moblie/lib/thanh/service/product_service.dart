import 'package:frotend_client_moblie/thanh/view_model/product_view_model.dart';

// class chuyên xử lý việc gọi api và trả về response hoặc lỗi nếu có cho ProductViewModel
class ProductService {
  // Tiêm danh sách product view model
  Future<List<ProductViewModel>> fetchProducts() async {
    //await Future.delayed(Duration(seconds: 1));
    final List<String> images = [
      'https://images.pexels.com/photos/532220/pexels-photo-532220.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/1488463/pexels-photo-1488463.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/2100063/pexels-photo-2100063.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/532220/pexels-photo-532220.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/1488463/pexels-photo-1488463.jpeg?auto=compress&w=200&h=300&fit=crop',
      'https://images.pexels.com/photos/2100063/pexels-photo-2100063.jpeg?auto=compress&w=200&h=300&fit=crop',
    ];
    final List<String> titles = [
      'Classic white shirt dress',
      'Strapless corset back dress',
      'Satin dress in mustard',
      'High-neck draped midi in black',
      'Brown pants in chocolate',
      'Shorts Satin culottes red wine',
      'One-shoulder long sleeve bodysuit',
      'Midi ruched crystal waist-draped',
    ];
    final List<String> descriptions = [
      'Một chiếc đầm sơ mi trắng cổ điển thanh lịch (Classic white shirt dress), hoàn hảo cho mọi dịp.',
      'Chiếc đầm quây ngực có dây đan (Strapless corset back dress) tuyệt đẹp, tôn lên vóc dáng của bạn.',
      'Đầm satin màu vàng mù tạt (Satin dress in mustard) sang trọng, được làm từ chất liệu vải mềm mịn.',
      'Một chiếc đầm midi xếp nếp cổ cao màu đen (High-neck draped midi in black) tinh tế, lý tưởng cho các sự kiện trang trọng.',
      'Quần dài màu nâu sô cô la (Brown pants in chocolate) thoải mái và phong cách.',
      'Quần short culottes satin màu đỏ rượu vang (Shorts Satin culottes red wine) sành điệu.',
      'Một bộ bodysuit dài tay lệch vai (One-shoulder long sleeve bodysuit) thời thượng cho vẻ ngoài hiện đại.',
      'Đầm midi nhún eo đính pha lê (Midi ruched crystal waist-draped) quyến rũ với các chi tiết xếp nếp ở eo.',
    ];
    final List<String> prices = [
      '32,425',
      '25,955',
      '18,095',
      '19,855',
      '9,855',
      '24,965',
      '9,855',
      '13,055',
    ];
    final List<ProductViewModel> productList = List.generate(
      images.length, // Giả sử cả 3 list đều có cùng độ dài
      (index) {
        // Tạo đối tượng
        return ProductViewModel(
          id: index.toString(),
          name: titles[index],
          description: descriptions[index],
          price: double.parse(prices[index].replaceAll(',', '')),
          imageUrl: images[index],
        );
      },
    );
    return productList;
  }
}
