"use client";
import { useState } from "react";
import { AdminTable } from "@/components/admin/AdminTable";
import data from "@/data/product";
import { EditDialog } from "@/components/common/EditDialog";
import { Category } from "@/types/Category";
import { CloseDialog } from "@/components/common/CloseDialog";

const CategoryPage = () => {
  const { categories } = data;
  const [open, setOpen] = useState(false);
  const [openClose, setOpenClose] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(
    null
  );

  const handleEdit = (item: Category, dialogType: string) => {
    setSelectedCategory(item);
    if (dialogType == "edit") {
      setOpen(true);
    } else {
      setOpenClose(true);
    }
  };

  const handleSave = (updated: Category) => {
    console.log("Saving category:", updated);
    setOpen(false);
  };

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
        onEdit={handleEdit}
        onDelete={handleEdit}
      />

      <EditDialog<Category>
        open={open}
        title="Edit Category"
        item={selectedCategory}
        onOpenChange={setOpen}
        onSave={handleSave}
        fields={[
          { key: "name", label: "Name" },
          { key: "created_at", label: "Created At", disabled: true },
        ]}
      />
      <CloseDialog<Category>
        open={openClose}
        title={`Delete a category`}
        field={`Do you want to delete this category ${selectedCategory?.name}`}
        item={selectedCategory}
        onOpenChange={setOpenClose}
        onDelete={() => {}}
      />
    </div>
  );
};

export default CategoryPage;
