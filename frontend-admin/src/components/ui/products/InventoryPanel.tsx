"use client";

import { useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import axios from "axios";
import { Button } from "@/components/ui/button";
import { RadioGroup } from "@/components/ui/custom/RadioGroup";
import { InputWithLabel } from "@/components/ui/InputWithLabel";

interface InventoryPanelProps {
  quantity: number;
}

export const InventoryPanel = ({ quantity }: InventoryPanelProps) => {
  const [stock, setStock] = useState<number>(quantity);
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const searchParams = useSearchParams();
  const variantId = searchParams.get("variantId");

  const handleSave = async () => {
    if (!variantId) {
      alert("Missing variantId in URL");
      return;
    }

    setLoading(true);
    try {
      const payload = { quantity: stock, variantId: variantId };

      const res = await axios.put(
        `http://localhost:8080/api/admin/variants/update-variant-stock`,
        payload
      );

      console.log("Stock updated:", res.data);

      alert("Stock updated successfully!");
      router.refresh();
    } catch (error: unknown) {
      console.error("Error updating stock:", error);
      alert("Failed to update stock!");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-background rounded-lg p-5 border-3">
      <h1 className="font-bold text-lg mb-5">Inventory</h1>

      <div className="flex flex-col w-[75%] gap-5">
        <RadioGroup name="manageStock" label="Manage Stock" />
        <RadioGroup name="stockAvail" label="Stock Availability" />

        <InputWithLabel
          type="number"
          placeholder="Stock"
          label="Quantity"
          id="quantity"
          value={stock.toString()}
          onChange={(e) => setStock(Number(e.target.value))}
        />
      </div>

      <Button
        onClick={handleSave}
        disabled={loading}
        className="mt-5 cursor-pointer bg-background border-2 text-foreground border-secondary"
      >
        {loading ? "Saving..." : "Save"}
      </Button>
    </div>
  );
};
