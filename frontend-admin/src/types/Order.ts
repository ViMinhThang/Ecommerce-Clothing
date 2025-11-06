export interface Order {
  id: number;
  user_email: string;
  status: string;
  total_amount: number;
  payment_method: string;
  shipping_address: string;
  created_at: string;
  updated_at: string;
  items: OrderItem[];
}
export interface OrderItem {
  product_id: number;
  variant_id: number;
  quantity: number;
  unit_price: number;
  subtotal: number;
}
