import React, { useEffect, useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "../ui/dialog";
import { Button } from "../ui/button";

interface CloseDialogProps<T extends object> {
  open: boolean;
  title: string;
  field: string;
  item: T | null;
  onOpenChange: (open: boolean) => void;
  onDelete: (deleted: T | null) => Promise<void>;
}

export function CloseDialog<T extends object>({
  open,
  title,
  field,
  item,
  onOpenChange,
  onDelete,
}: CloseDialogProps<T>) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[400px]">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
        </DialogHeader>

        <div className="flex flex-col gap-4 mt-2">{field}</div>

        <DialogFooter className="mt-5">
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button className="bg-red-500" onClick={() => onDelete(item)}>
            Delete
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
