export interface VariantImage {
  id: number;
  imageUrl: string;
}

export interface VariantContent {
  variantId: number;
  price: number;
  quantity: number;
  size: { id: number; name: string };
  color: { id: number; name: string };
  images: VariantImage[];
  SKU: string;
  description: string;
}

export interface VariantDetailResponse {
  productId: number;
  productName: string;
  content: VariantContent;
  variants: VariantContent[];
}
