// Product.ts

export interface VariantImage {
  id: number;
  imageUrl: string;
}

export interface Size {
  id: number;
  name: string;
}

export interface Color {
  id: number;
  name: string;
}

export interface Variant {
  variantId: number;
  price: number;
  quantity: number;
  size: Size;
  color: Color;
  images: VariantImage[];
}
export interface VariantRowType {
  variantId: number;
  price: number;
  quantity: number;
  size: string;
  color: string;
  productName: string;
}

export interface Product {
  productId: number;
  productName: string;
  variants: Variant[];
  available?: boolean;
}

export interface ProductResponse {
  content: Product[];
  pageNumber: number;
  pageSize: number;
  totalElements: number;
  totalPages: number;
  lastPage: boolean;
}
