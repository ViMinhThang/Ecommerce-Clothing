import { Button } from "@/components/ui/button";
import { InputWithLabel } from "@/components/ui/InputWithLabel";
import fields from "@/constant/productDetail";

export const ProductInfoForm = () => (
  <div className="bg-white p-5 rounded-lg">
    <div className="flex justify-start gap-4 items-center mb-5">
      <h1 className="font-bold text-lg">Air Force 1 Low EXP</h1>
      <span className="flex items-center gap-2 text-sm bg-green-200 p-2 rounded-lg">
        Enable
      </span>
    </div>

    <div className="flex gap-4">
      {fields.basicInfoFields.map((field) => (
        <InputWithLabel key={field.id} {...field} />
      ))}
    </div>

    <div className="flex gap-4 mt-5">
      {fields.detailsFields.map((field) => (
        <InputWithLabel key={field.id} {...field} />
      ))}
    </div>

    <Button className="mt-5 cursor-pointer">Save</Button>
  </div>
);
