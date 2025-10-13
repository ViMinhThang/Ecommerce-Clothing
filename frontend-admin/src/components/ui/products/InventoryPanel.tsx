// components/product/InventoryPanel.tsx
import { Button } from "@/components/ui/button";
import { RadioGroup } from "@/components/ui/custom/RadioGroup";
import { InputWithLabel } from "@/components/ui/InputWithLabel";

export const InventoryPanel = () => (
  <div className="bg-white rounded-lg p-5">
    <h1 className="font-bold text-lg mb-5">Inventory</h1>
    <div className="flex flex-col w-[75%] gap-5">
      <RadioGroup name="manageStock" label="Manage Stock" />
      <RadioGroup name="stockAvail" label="Stock Availability" />
      <InputWithLabel
        type="number"
        placeholder="Stock"
        label="Quantity"
        id="quantity"
      />
    </div>
    <Button className="mt-5 cursor-pointer">Save</Button>
  </div>
);
