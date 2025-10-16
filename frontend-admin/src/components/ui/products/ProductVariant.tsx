// components/product/ProductVariants.tsx
import data from "@/data/product";
import { VariantRow } from "./VariantRow";

export const ProductVariants = () => {
  const { products } = data;

  return (
    <div className="bg-background p-5 rounded-lg border-3">
      <h1 className="font-bold text-lg mb-5">Variant</h1>
      <div className="grid grid-cols-7 border-b font-semibold pb-2 pe-2">
        {["Image", "Size", "Color", "Price", "Stock", "Status", "Action"].map(
          (col) => (
            <p key={col}>{col}</p>
          )
        )}
      </div>

      {products[0].variants.map((variant, i) => (
        <VariantRow key={i} item={variant} />
      ))}
    </div>
  );
};
