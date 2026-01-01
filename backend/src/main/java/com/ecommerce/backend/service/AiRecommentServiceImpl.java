package com.ecommerce.backend.service;

import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

@Service
public class AiRecommentServiceImpl implements  AiRecommentService{
    private static final String FIREBASE_CONFIG_URL =
            "https://ai-helper-14787-default-rtdb.asia-southeast1.firebasedatabase.app/ai_config.json";

    private HttpClient client;
    public AiRecommentServiceImpl() {
        this.client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }
    /**
     * Bước 1: Hỏi Firebase xem Server Colab hôm nay ở đâu?
     */
    private String getColabUrl() {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(FIREBASE_CONFIG_URL))
                    .GET()
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // Firebase trả về link dạng: "https://abcd.ngrok-free.app" (có dấu ngoặc kép)
            String rawUrl = response.body();

            if (rawUrl == null || rawUrl.equals("null")) {
                System.err.println("❌ Lỗi: Chưa có link Colab trên Firebase. Hãy chạy script Python trước!");
                return null;
            }

            // Xóa dấu ngoặc kép thừa
            return rawUrl.replace("\"", "").trim();

        } catch (Exception e) {
            System.err.println("❌ Không kết nối được Firebase: " + e.getMessage());
            return null;
        }
    }

    /**
     * Bước 2: Gửi danh sách sản phẩm lên Colab để lấy Vector
     */
    public String getVectorsFromAI(String jsonProductList) {
        // 1. Lấy link động
        String colabBaseUrl = getColabUrl();
        if (colabBaseUrl == null) return null;

        // 2. Gọi API tính toán
        String apiUrl = colabBaseUrl + "/vectorize"; // Nối thêm endpoint

        try {
            System.out.println("🚀 Đang gửi request tới: " + apiUrl);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonProductList))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                System.out.println("✅ Đã nhận kết quả Vector từ AI!");
                return response.body(); // Trả về chuỗi JSON chứa vectors
            } else {
                System.err.println("❌ Lỗi từ Colab AI: " + response.statusCode());
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
