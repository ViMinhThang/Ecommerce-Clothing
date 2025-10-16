"use client";
import { RadioGroup } from "@/components/ui/custom/RadioGroup";
import { InventoryPanel } from "@/components/ui/products/InventoryPanel";
import { ProductImages } from "@/components/ui/products/ProductImages";
import { ProductInfoForm } from "@/components/ui/products/ProductInfoForm";
import { ProductVariants } from "@/components/ui/products/ProductVariant";

const Page = () => {
  return (
    <>
      <div className="border-b-2 pb-2">
        <h1 className="font-bold text-2xl">Editing</h1>
      </div>

      <div className="flex justify-center items-start gap-5 mx-5 mt-5">
        {/* Left Section */}
        <div className="flex flex-col gap-5 w-[80%]">
          <ProductInfoForm />
          <ProductImages />
          <ProductVariants />
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

          <InventoryPanel />
        </div>
      </div>
    </>
  );
};

export default Page;
