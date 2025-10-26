"use client";
import { useState, useEffect } from "react";
import axios from "axios";
import { useSearchParams } from "next/navigation";
import { RadioGroup } from "@/components/ui/custom/RadioGroup";
import { InventoryPanel } from "@/components/ui/products/InventoryPanel";
import { ProductImages } from "@/components/ui/products/ProductImages";
import { ProductInfoForm } from "@/components/ui/products/ProductInfoForm";
import { ProductVariants } from "@/components/ui/products/ProductVariant";
import { VariantDetailResponse } from "@/types/ProductDetails";

const Page = () => {
  const searchParams = useSearchParams();
  const productId = searchParams.get("productId");
  const variantId = searchParams.get("variantId");

  const [data, setData] = useState<VariantDetailResponse | null>(null);

  const fetchVariantDetails = async () => {
    try {
      const response = await axios.get<VariantDetailResponse>(
        "http://localhost:8080/api/admin/variants/details",
        {
          params: {
            productId,
            variantId,
          },
        }
      );
      setData(response.data);
    } catch (error) {
      console.error("Lỗi khi fetch variant details:", error);
    }
  };

  useEffect(() => {
    if (productId && variantId) {
      fetchVariantDetails();
    }
  }, [productId, variantId]);

  if (!data) {
    return <p className="text-center mt-10">Đang tải dữ liệu...</p>;
  }

  const { productId: id, productName, content, variants } = data;
  return (
    <>
      <div className="border-b-2 pb-2">
        <h1 className="font-bold text-2xl">
          Editing {productName} (ID: {id})
        </h1>
      </div>

      <div className="flex justify-center items-start gap-5 mx-5 mt-5">
        {/* Left Section */}
        <div className="flex flex-col gap-5 w-[80%]">
          <ProductInfoForm content={content} />

          <ProductImages images={content.images} />

          <ProductVariants variants={variants} />
        </div>

        {/* Right Section */}
        <div className="flex flex-col gap-5 w-[20%]">
          <div className="bg-background rounded-lg p-5 border-3">
            <RadioGroup
              name="active"
              label="Set Active"
              description="Set if the item is active for purchase"
            />
          </div>
          <InventoryPanel quantity={content.quantity} />{" "}
        </div>
      </div>
    </>
  );
};

export default Page;
