"use client";
import { useState } from "react";
import { AdminTable } from "@/components/admin/AdminTable";
import data from "@/data/product";
import { EditDialog } from "@/components/common/EditDialog";
import { CloseDialog } from "@/components/common/CloseDialog";
import { User } from "@/types/User";

const UserPage = () => {
  const { users } = data;
  const [open, setOpen] = useState(false);
  const [openClose, setOpenClose] = useState(false);
  const [selectedUser, setSelectedUser] = useState<User | null>(null);

  const handleEdit = (item: User, dialogType: string) => {
    setSelectedUser(item);
    if (dialogType == "edit") {
      setOpen(true);
    } else {
      setOpenClose(true);
    }
  };

  const handleSave = (updated: User) => {
    console.log("Saving User:", updated);
    setOpen(false);
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-4">List Users</h1>

      <AdminTable
        data={users}
        columns={[
          { key: "id", label: "id", sortable: true },
          { key: "username", label: "Name" },
          { key: "email", label: "Name" },

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

      <EditDialog<User>
        open={open}
        title="Edit User"
        item={selectedUser}
        onOpenChange={setOpen}
        onSave={handleSave}
        fields={[
          { key: "username", label: "User name" },
          { key: "email", label: "User email" },
          { key: "role", label: "User role" },
          { key: "created_at", label: "Created At", disabled: true },
        ]}
      />
      <CloseDialog<User>
        open={openClose}
        title={`Delete a category`}
        field={`Do you want to delete this user ${selectedUser?.username}`}
        item={selectedUser}
        onOpenChange={setOpenClose}
        onDelete={() => {}}
      />
    </div>
  );
};

export default UserPage;
