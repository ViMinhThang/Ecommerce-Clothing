"use client";

import Image from "next/image";
import { Button } from "@/components/ui/button";
import type { VariantContent } from "@/types/ProductDetails";

interface ProductVariantsProps {
  variants: VariantContent[];
}

export const ProductVariants = ({ variants }: ProductVariantsProps) => {
  return (
    <div className="bg-background p-5 rounded-lg border-2 border-muted">
      <h1 className="font-bold text-lg mb-5">Variants</h1>

      <div className="grid grid-cols-7 border-b font-semibold pb-2 pe-2 text-sm text-muted-foreground">
        {["Image", "Size", "Color", "Price", "Stock", "Status", "Action"].map(
          (col) => (
            <p key={col} className="truncate">
              {col}
            </p>
          )
        )}
      </div>

      {/* Body Rows */}
      {variants.map((variant) => (
        <div
          key={variant.variantId}
          className="grid grid-cols-7 items-center py-3 border-b text-sm"
        >
          {/* 🖼 Image */}
          <div className="flex items-center justify-center">
            {variant.images && variant.images.length > 0 ? (
              <Image
                src={variant.images[0].imageUrl}
                alt={`Variant ${variant.variantId}`}
                width={60}
                height={60}
                className="rounded-md border"
              />
            ) : (
              <div className="w-[60px] h-[60px] bg-muted flex items-center justify-center rounded-md text-xs">
                N/A
              </div>
            )}
          </div>

          <p>{variant.size?.name || "-"}</p>

          <p>{variant.color?.name || "-"}</p>

          <p>${variant.price.toLocaleString()}</p>

          <p>{variant.quantity}</p>

          <p>{variant.quantity > 0 ? "Active" : "Out of Stock"}</p>

          {/* ⚙️ Action */}
          <div className="flex gap-2">
            <Button variant="outline" size="sm">
              Edit
            </Button>
          </div>
        </div>
      ))}

      {variants.length === 0 && (
        <p className="text-center text-muted-foreground py-4">
          No variants available.
        </p>
      )}
    </div>
  );
};
