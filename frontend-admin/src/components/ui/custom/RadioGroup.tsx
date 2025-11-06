import { Input } from "../input";

export const RadioGroup = ({
  name,
  label,
  description,
  options = ["Yes", "No"],
}: {
  name: string;
  label: string;
  description?: string;
  options?: string[];
}) => (
  <div>
    <h1 className="font-bold text-lg mb-2">{label}</h1>
    {description && (
      <p className="text-sm text-slate-500 mb-3">{description}</p>
    )}
    <div className="flex justify-start items-center gap-4">
      {options.map((option) => (
        <label key={option} className="flex items-center gap-2 cursor-pointer">
          <Input type="radio" name={name} value={option.toLowerCase()} />
          <p>{option}</p>
        </label>
      ))}
    </div>
  </div>
);
