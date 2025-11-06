"use client";
import { useState } from "react";
import axios from "axios";
import { Button } from "@/components/ui/button";
import { InputWithLabel } from "../InputWithLabel";
import { VariantContent } from "@/types/ProductDetails";
import { Label } from "recharts";
import { useRouter } from "next/navigation";

interface ProductInfoFormProps {
  content: VariantContent;
}

export const ProductInfoForm = ({ content }: ProductInfoFormProps) => {
  const [formData, setFormData] = useState({
    variantId: content?.variantId || "",
    price: content?.price || 0,
    SKU: content?.SKU || "",
    color: content?.color?.name || "",
    size: content?.size?.name || "",
    description: content?.description || "",
  });
  const router = useRouter();
  if (!content) return null;

  const handleChange = (id: string, value: string | number) => {
    setFormData((prev) => ({ ...prev, [id]: value }));
  };

  const handleSave = async () => {
    try {
      const payload = {
        price: formData.price,
        SKU: formData.SKU,
        description: formData.description,
        variantId: formData.variantId,
        color: formData.color,
        size: formData.size,
      };

      const res = await axios.put(
        `http://localhost:8080/api/admin/variants/update-variant-info`,
        payload
      );

      console.log("Updated variant:", res.data);
      alert("Variant updated successfully!");
      router.refresh();
    } catch (error: unknown) {
      console.error("Error updating variant:", error);
      alert("Failed to update variant!");
    }
  };

  const basicInfoFields = [
    {
      id: "variantId",
      label: "Variant ID",
      value: formData.variantId,
      type: "text",
      placeholder: "Variant ID",
      disabled: true,
    },
    {
      id: "price",
      label: "Price",
      value: formData.price,
      type: "number",
      placeholder: "Enter price",
    },
    {
      id: "SKU",
      label: "SKU",
      value: formData.SKU,
      type: "text",
      placeholder: "Enter SKU",
    },
  ];

  const detailsFields = [
    {
      id: "color",
      label: "Color",
      value: formData.color,
      type: "text",
      placeholder: "Color name",
      disabled: false,
    },
    {
      id: "size",
      label: "Size",
      value: formData.size,
      type: "text",
      placeholder: "Size name",
      disabled: false,
    },
  ];

  return (
    <div className="bg-background p-5 rounded-lg border-3">
      {/* Header */}
      <div className="flex justify-start gap-4 items-center mb-5">
        <h1 className="font-bold text-lg">Variant #{formData.variantId}</h1>
        <span className="flex items-center gap-2 text-sm bg-green-200 p-2 rounded-lg">
          Active
        </span>
      </div>

      {/* Basic Info */}
      <div className="flex gap-4">
        {basicInfoFields.map((field) => (
          <InputWithLabel
            key={field.id}
            {...field}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              handleChange(field.id, e.target.value)
            }
          />
        ))}
      </div>

      {/* Details */}
      <div className="flex flex-col mt-5 space-y-5">
        <div className="flex gap-4">
          {detailsFields.map((field) => (
            <InputWithLabel
              key={field.id}
              {...field}
              onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                handleChange(field.id, e.target.value)
              }
            />
          ))}
        </div>

        {/* Description */}
        <div className="flex flex-col space-y-2">
          <Label>Description</Label>
          <textarea
            className="border rounded-md p-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            cols={100}
            rows={5}
            value={formData.description}
            onChange={(e) => handleChange("description", e.target.value)}
          />
        </div>
      </div>

      {/* Save button */}
      <Button
        variant="outline"
        className="mt-5 cursor-pointer text-foreground border-1 border-secondary"
        onClick={handleSave}
      >
        Save
      </Button>
    </div>
  );
};
