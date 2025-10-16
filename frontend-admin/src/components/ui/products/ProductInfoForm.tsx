import { Button } from "@/components/ui/button";
import { InputWithLabel } from "@/components/ui/InputWithLabel";
import fields from "@/constant/productDetail";

export const ProductInfoForm = () => (
  <div className="bg-background p-5 rounded-lg border-3">
    <div className="flex justify-start gap-4 items-center mb-5">
      <h1 className="font-bold text-lg">Air Force 1 Low EXP</h1>
      <span className="flex items-center gap-2 text-sm bg-green-200 p-2 rounded-lg text-background">
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

    <Button className="mt-5 cursor-pointer bg-background text-foreground border-1 border-secondary">
      Save
    </Button>
  </div>
);
