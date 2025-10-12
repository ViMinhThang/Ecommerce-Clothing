"use client";
import React, { useEffect, useMemo, useState } from "react";
import data from "../../data/product";
import { ArrowDownUp, ArrowLeft, ArrowRight, Bolt, Trash } from "lucide-react";
import { Button } from "@/components/ui/button";

const Page = () => {
  const { products } = data;
  const [sortCriteria, setSortCriteria] = useState<string>("");
  const [sortOrder, setSortOrder] = useState("asc");

  const handleSort = (criteria: string) => {
    if (!criteria) return;
    if (sortCriteria === criteria) {
      setSortOrder((prev) => (prev === "asc" ? "desc" : "asc"));
    } else {
      setSortCriteria(criteria);
      setSortOrder("asc");
    }
  };
  const productVariants = useMemo(() => {
    return products.flatMap((product) =>
      product.variants.map((variant) => ({
        ...variant,
        productName: product.name,
        created_at: product.created_at,
        updated_at: product.updated_at,
      }))
    );
  }, [products]);
  const sortedData = useMemo(() => {
    if (!sortCriteria) return productVariants;

    return [...productVariants].sort((a, b) => {
      let valA = a[sortCriteria as keyof typeof a];
      let valB = b[sortCriteria as keyof typeof b];

      if (sortCriteria === "productName") {
        valA = a.productName;
        valB = b.productName;
      }

      if (sortCriteria === "created_at" || sortCriteria === "updated_at") {
        valA = new Date(valA).getTime();
        valB = new Date(valB).getTime();
      }

      if (typeof valA === "string") valA = valA.toLowerCase();
      if (typeof valB === "string") valB = valB.toLowerCase();

      if (valA < valB) return sortOrder === "asc" ? -1 : 1;
      if (valA > valB) return sortOrder === "asc" ? 1 : -1;
      return 0;
    });
  }, [productVariants, sortCriteria, sortOrder]);
  return (
    <div className="p-6">
      <div className="border-b pb-4 mb-4">
        <h1 className="text-2xl font-bold text-slate-800">List Products</h1>
      </div>

      <div className="border border-slate-300 rounded-xl overflow-hidden shadow-sm bg-white">
        {/* Header */}
        <div className="grid grid-cols-[2fr_1fr_1fr_1fr_1fr_auto] items-center bg-slate-50 text-slate-600 font-semibold border-b">
          {[
            { label: "Name", sortable: true, criteria: "productName" },
            { label: "SKU" },
            { label: "Price", sortable: true, criteria: "price" },
            { label: "Created At", sortable: true, criteria: "created_at" },
            { label: "Updated At", sortable: true, criteria: "updated_at" },
            { label: "Action" },
          ].map((col, i) => (
            <div
              key={i}
              className={`flex items-center gap-2 px-4 py-3 select-none ${
                col.sortable ? "cursor-pointer hover:bg-slate-100" : ""
              }`}
              onClick={() => handleSort(col.criteria ?? "")}
            >
              {col.sortable && (
                <ArrowDownUp
                  size={16}
                  className={`transition-transform duration-200 ${
                    sortCriteria === col.criteria
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
        </div>

        {/* Body */}
        {sortedData.map((variant) => (
          <div
            key={variant.id}
            className="grid grid-cols-[2fr_1fr_1fr_1fr_1fr_auto] items-center border-b last:border-b-0 hover:bg-slate-50 transition-colors duration-150"
          >
            <div className="px-4 py-3 font-medium text-slate-800">
              {variant.productName}
            </div>
            <div className="px-4 py-3 text-slate-600">{variant.sku}</div>
            <div className="px-4 py-3 text-slate-700 font-semibold">
              {variant.price.toLocaleString()} ₫
            </div>
            <div className="px-4 py-3 text-slate-500">
              {new Date(variant.created_at).toLocaleDateString()}
            </div>
            <div className="px-4 py-3 text-slate-500">
              {new Date(variant.updated_at).toLocaleDateString()}
            </div>
            <div className="flex items-center gap-4 px-4 py-3">
              <Bolt className="cursor-pointer text-slate-500 hover:text-blue-500 transition-colors" />
              <Trash className="cursor-pointer text-slate-500 hover:text-red-500 transition-colors" />
            </div>
          </div>
        ))}
      </div>
      <div className="flex justify-end mt-5">
        <Button variant="outline" className="cursor-pointer">
          <ArrowLeft></ArrowLeft>
        </Button>
        <Button variant="outline" className="cursor-pointer">
          1
        </Button>
        <Button variant="outline" className="cursor-pointer">
          2
        </Button>
        <Button variant="outline" className="cursor-pointer">
          3
        </Button>
        <Button variant="outline" className="cursor-pointer">
          <ArrowRight></ArrowRight>
        </Button>
      </div>
    </div>
  );
};

export default Page;
