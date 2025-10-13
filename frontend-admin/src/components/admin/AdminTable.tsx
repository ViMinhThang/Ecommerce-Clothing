"use client";
import React, { useMemo, useState } from "react";
import { ArrowDownUp, Bolt, Trash } from "lucide-react";

type Column<T> = {
  key: keyof T;
  label: string;
  sortable?: boolean;
  render?: (item: T) => React.ReactNode;
};

type AdminTableProps<T extends object> = {
  columns: Column<T>[];
  data: T[];
  onEdit?: (item: T) => void;
  onDelete?: (item: T) => void;
};

export function AdminTable<T extends object>({
  columns,
  data,
  onEdit,
  onDelete,
}: AdminTableProps<T>) {
  const [sortKey, setSortKey] = useState<keyof T | null>(null);
  const [sortOrder, setSortOrder] = useState<"asc" | "desc">("asc");

  const handleSort = (key: keyof T) => {
    if (sortKey === key) {
      setSortOrder((prev) => (prev === "asc" ? "desc" : "asc"));
    } else {
      setSortKey(key);
      setSortOrder("asc");
    }
  };

  const sortedData = useMemo(() => {
    if (!sortKey) return data;

    return [...data].sort((a, b) => {
      const valA = a[sortKey];
      const valB = b[sortKey];

      const aValue =
        typeof valA === "string"
          ? valA.toLowerCase()
          : (valA as number | string);
      const bValue =
        typeof valB === "string"
          ? valB.toLowerCase()
          : (valB as number | string);

      if (aValue < bValue) return sortOrder === "asc" ? -1 : 1;
      if (aValue > bValue) return sortOrder === "asc" ? 1 : -1;
      return 0;
    });
  }, [data, sortKey, sortOrder]);
  return (
    <div className="border border-slate-300 rounded-xl overflow-hidden shadow-sm bg-white">
      {/* Header */}
      <div className="grid grid-cols-[repeat(auto-fit,minmax(150px,1fr))] bg-slate-50 border-b text-slate-600 font-semibold">
        {columns.map((col) => (
          <div
            key={String(col.key)}
            className={`flex items-center gap-2 px-4 py-3 ${
              col.sortable ? "cursor-pointer hover:bg-slate-100" : ""
            }`}
            onClick={() => col.sortable && handleSort(col.key)}
          >
            {col.sortable && (
              <ArrowDownUp
                size={16}
                className={`transition-transform ${
                  sortKey === col.key
                    ? sortOrder === "asc"
                      ? "rotate-180 text-blue-500"
                      : "text-blue-500"
                    : "text-slate-400"
                }`}
              />
            )}
            <span>{col.label}</span>
          </div>
        ))}
        <div className="px-4 py-3">Actions</div>
      </div>

      {/* Rows */}
      {sortedData.map((item, i) => (
        <div
          key={i}
          className="grid grid-cols-[repeat(auto-fit,minmax(150px,1fr))] border-b hover:bg-slate-50 transition-colors"
        >
          {columns.map((col) => (
            <div key={String(col.key)} className="px-4 py-3 text-slate-700">
              {col.render ? col.render(item) : String(item[col.key])}{" "}
            </div>
          ))}
          <div className="flex items-center gap-4 px-4 py-3">
            <Bolt
              className="cursor-pointer text-slate-500 hover:text-blue-500"
              onClick={() => onEdit?.(item)}
            />
            <Trash
              className="cursor-pointer text-slate-500 hover:text-red-500"
              onClick={() => onDelete?.(item)}
            />
          </div>
        </div>
      ))}
    </div>
  );
}
