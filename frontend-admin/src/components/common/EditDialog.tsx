"use client";

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useEffect, useState } from "react";

interface Field<T> {
  key: keyof T;
  label: string;
  type?: string;
  disabled?: boolean;
}

interface EditDialogProps<T extends object> {
  open: boolean;
  title: string;
  fields: Field<T>[];
  item: T | null;
  onOpenChange: (open: boolean) => void;
  onSave: (updated: T) => void;
}

export function EditDialog<T extends object>({
  open,
  title,
  fields,
  item,
  onOpenChange,
  onSave,
}: EditDialogProps<T>) {
  const [formData, setFormData] = useState<T | null>(item);

  useEffect(() => {
    setFormData(item);
  }, [item]);

  const handleChange = (key: keyof T, value: unknown) => {
    if (!formData) return;
    setFormData({ ...formData, [key]: value } as T);
  };

  if (!formData) return null;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[400px]">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
        </DialogHeader>

        <div className="flex flex-col gap-4 mt-2">
          {fields.map((f) => (
            <div key={String(f.key)}>
              <Label className="text-sm font-medium">{f.label}</Label>
              <Input
                type={f.type || "text"}
                value={String(formData[f.key] ?? "")}
                disabled={f.disabled}
                onChange={(e) => handleChange(f.key, e.target.value)}
              />
            </div>
          ))}
        </div>

        <DialogFooter className="mt-5">
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={() => formData && onSave(formData)}>Save</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
