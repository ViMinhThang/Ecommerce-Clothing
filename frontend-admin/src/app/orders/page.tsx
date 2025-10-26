"use client";
import { AdminTable } from "@/components/admin/AdminTable";
import { CloseDialog } from "@/components/common/CloseDialog";
import data from "@/data/product";
import { Order } from "@/types/Order";
import { useRouter } from "next/navigation";
import React, { useState } from "react";

const OrderPage = () => {
  const orders: Order[] = data.orders;
  const [open, setOpen] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const router = useRouter();
  const handleEdit = (item: Order, actionType: string) => {
    if (actionType == "edit") {
      router.push(`/orders/${item.id}`);
    } else {
      setSelectedOrder(item);
      setOpen(true);
    }
  };
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-4">List Users</h1>

      <AdminTable
        data={orders}
        columns={[
          { key: "id", label: "id", sortable: true },
          { key: "status", label: "Status" },
          { key: "user_email", label: "Email" },
          { key: "total_amount", label: "Amount" },
          { key: "payment_method", label: "Method" },

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
      <CloseDialog<Order>
        open={open}
        title={`Delete an order`}
        field={`Do you want to delete this order ${selectedOrder?.id}`}
        item={selectedOrder}
        onOpenChange={setOpen}
        onDelete={() => {}}
      />
    </div>
  );
};
export default OrderPage;
