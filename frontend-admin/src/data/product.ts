// data/products.js

const categories = [
  {
    id: 1,
    name: "Áo thun",
    description: "Các loại áo thun thời trang unisex",
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
        image_url: "/images/products/ts-red-s.jpg",
      },
      {
        id: 2,
        color_id: 1,
        size_id: 2,
        sku: "TS-RED-M",
        price: 1111111,
        stock_quantity: 30,
        image_url: "/images/products/ts-red-m.jpg",
      },
      {
        id: 3,
        color_id: 2,
        size_id: 1,
        sku: "TS-BLU-S",
        price: 100000,
        stock_quantity: 20,
        image_url: "/images/products/ts-blue-s.jpg",
      },
      {
        id: 4,
        color_id: 2,
        size_id: 2,
        sku: "TS-BLU-M",
        price: 199000,
        stock_quantity: 25,
        image_url: "/images/products/ts-blue-m.jpg",
      },
    ],
    images: [
      { id: 1, image_url: "/images/products/ts-main.jpg", is_primary: true },
      { id: 2, image_url: "/images/products/ts-alt1.jpg", is_primary: false },
    ],
  },
];

const data = { categories, products, brands };

export default data;
