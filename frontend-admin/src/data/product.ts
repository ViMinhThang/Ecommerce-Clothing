// data/products.js

const categories = [
  {
    id: 1,
    name: "Áo vbcvbcvbcvthun",
    description: "Các loại áo thun thời trang unisex",
    created_at: "2025-10-12T10:00:00Z",
    updated_at: "2025-10-12T10:00:00Z",
  },
  {
    id: 1,
    name: "Áo 12312312",
    description: "Các loại áo thun thời trang unisex",
    created_at: "2025-10-12T10:00:00Z",
    updated_at: "2025-10-12T10:00:00Z",
  },
  {
    id: 1,
    name: "Áo wdasdasdthun",
    description: "Các loại áasdasdasd",
    created_at: "2025-10-12T10:00:00Z",
    updated_at: "2025-10-12T10:00:00Z",
  },
  {
    id: 1,
    name: "Áo 123123thun",
    description: "Các loại áo123123dfsdvcxvx",
    created_at: "2025-10-12T10:00:00Z",
    updated_at: "2025-10-12T10:00:00Z",
  },
];

const brands = [
  {
    id: 1,
    name: "Coolmate",
    description: "Thương hiệu thời trang nam Việt Nam",
  },
];

const products = [
  {
    id: 1,
    name: "Áo thun cotton",
    description: "Áo thun unisex chất cotton mềm mịn, thoáng mát, dễ phối đồ.",
    category_id: 1,
    brand_id: 1,
    created_at: "2025-10-12T10:00:00Z",
    updated_at: "2025-10-12T10:00:00Z",
    colors: [
      { id: 1, name: "Đỏ", hex_code: "#FF0000" },
      { id: 2, name: "Xanh dương", hex_code: "#0000FF" },
    ],
    sizes: [
      { id: 1, name: "S" },
      { id: 2, name: "M" },
      { id: 3, name: "L" },
    ],
    variants: [
      {
        id: 1,
        color_id: 1,
        size_id: 1,
        sku: "TS-RED-S",
        price: 123123123,
        stock_quantity: 50,
        image_url: "https://placehold.co/300x200/png",
        isActive: true,
      },
      {
        id: 2,
        color_id: 1,
        size_id: 2,
        sku: "TS-RED-M",
        price: 1111111,
        stock_quantity: 30,
        image_url: "https://placehold.co/300x200/png",
        isActive: true,
      },
      {
        id: 3,
        color_id: 2,
        size_id: 1,
        sku: "TS-BLU-S",
        price: 100000,
        stock_quantity: 20,
        image_url: "https://placehold.co/300x200/png",
        isActive: true,
      },
      {
        id: 4,
        color_id: 2,
        size_id: 2,
        sku: "TS-BLU-M",
        price: 199000,
        stock_quantity: 25,
        image_url: "https://placehold.co/300x200/png",
        isActive: true,
      },
    ],
  },
];
const users = [
  {
    id: 1,
    username: "admin",
    email: "admin@example.com",
    role: "admin",
    created_at: "2025-10-10T09:00:00Z",
    updated_at: "2025-10-12T12:00:00Z",
  },
  {
    id: 2,
    username: "john_doe",
    email: "john@example.com",
    role: "editor",
    created_at: "2025-10-11T08:30:00Z",
    updated_at: "2025-10-13T11:00:00Z",
  },
  {
    id: 3,
    username: "jane_smith",
    email: "jane@example.com",
    role: "viewer",
    created_at: "2025-10-12T07:45:00Z",
    updated_at: "2025-10-13T10:15:00Z",
  },
];
const orders = [
  {
    id: 101,
    user_email: "abc@gmail.com",
    status: "completed",
    total_amount: 520000,
    payment_method: "credit_card", // credit_card | cash | paypal
    shipping_address: "123 Đường Nguyễn Trãi, Quận 5, TP.HCM",
    created_at: "2025-10-13T09:15:00Z",
    updated_at: "2025-10-13T11:30:00Z",
    items: [
      {
        product_id: 1,
        variant_id: 1,
        quantity: 2,
        unit_price: 250000,
        subtotal: 500000,
      },
      {
        product_id: 1,
        variant_id: 2,
        quantity: 1,
        unit_price: 20000,
        subtotal: 20000,
      },
    ],
  },
  {
    id: 102,
    user_email: "abc@gmail.com",
    status: "pending",
    total_amount: 250000,
    payment_method: "cash",
    shipping_address: "45 Lý Thường Kiệt, Quận 10, TP.HCM",
    created_at: "2025-10-14T08:45:00Z",
    updated_at: "2025-10-14T09:00:00Z",
    items: [
      {
        product_id: 1,
        variant_id: 1,
        quantity: 1,
        unit_price: 250000,
        subtotal: 250000,
      },
    ],
  },
  {
    id: 103,
    user_email: "abc@gmail.com",
    status: "cancelled",
    total_amount: 270000,
    payment_method: "paypal",
    shipping_address: "12 Nguyễn Văn Cừ, Quận 1, TP.HCM",
    created_at: "2025-10-11T10:00:00Z",
    updated_at: "2025-10-12T08:00:00Z",
    items: [
      {
        product_id: 1,
        variant_id: 2,
        quantity: 1,
        unit_price: 270000,
        subtotal: 270000,
      },
    ],
  },
];
const data = { categories, products, brands, users, orders };

export default data;
