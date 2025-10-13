import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

interface InputWithLabelProps {
  label: string;
  type: string;
  placeholder: string;
  id: string;
}

export function InputWithLabel(props: InputWithLabelProps) {
  return (
    <div className="grid w-full max-w-sm items-center gap-3 border-white">
      <Label className="text-md" htmlFor={props.id}>
        {props.label}
      </Label>
      <Input
        className="h-12 text-xl rounded-xl"
        type={props.type}
        id={props.id}
        placeholder={props.placeholder}
      />
    </div>
  );
}
