import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

interface InputWithLabelProps {
  label: string;
  type: string;
  placeholder: string;
  id: string;
  value: string | number;
  disabled?: boolean;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

export function InputWithLabel({
  label,
  type,
  placeholder,
  id,
  value,
  disabled,
  onChange,
}: InputWithLabelProps) {
  return (
    <div className="grid w-full max-w-sm items-center gap-3 border-white">
      <Label className="text-md" htmlFor={id}>
        {label}
      </Label>
      <Input
        className="h-12 text-xl rounded-xl"
        type={type}
        id={id}
        value={value}
        onChange={onChange}
        placeholder={placeholder}
        disabled={disabled}
      />
    </div>
  );
}
