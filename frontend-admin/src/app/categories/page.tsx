"use client";
import { AdminTable } from "@/components/admin/AdminTable";
import data from "@/data/product";
import { useRouter } from "next/navigation";
import React from "react";

const CategoryPage = () => {
  const { categories } = data;
  const router = useRouter();
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-4">Categories</h1>
      <AdminTable
        data={categories}
        columns={[
          { key: "id", label: "id", sortable: true },
          { key: "name", label: "Name" },
          {
            key: "created_at",
            label: "Created At",
            sortable: true,
            render: (item) => new Date(item.created_at).toLocaleDateString(),
          },
          {
            key: "updated_at",
            label: "Updated At",
            sortable: true,
            render: (item) => new Date(item.updated_at).toLocaleDateString(),
          },
        ]}
        onEdit={(item) => router.push(`/products/${item.id}/edit`)}
        onDelete={(item) => console.log("Delete", item)}
      />
    </div>
  );
};

export default CategoryPage;
