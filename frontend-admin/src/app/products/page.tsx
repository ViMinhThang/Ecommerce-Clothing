"use client";
import React, { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import axios from "axios";
import { AdminTable } from "@/components/admin/AdminTable";
import { ProductResponse, VariantRowType } from "@/types/Product";
import { CloseDialog } from "@/components/common/CloseDialog";

export default function ProductPage() {
  const [productsData, setProductsData] = useState<ProductResponse>({
    content: [],
    pageNumber: 0,
    pageSize: 10,
    totalElements: 0,
    totalPages: 0,
    lastPage: true,
  });
  const [selectedVariantRow, setSelectedVariantRow] =
    useState<VariantRowType | null>(null);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const fetchProducts = async (page = 0, size = 10) => {
    setLoading(true);
    try {
      const res = await axios.get<ProductResponse>(
        "http://localhost:8080/api/admin/products",
        {
          params: {
            pageNumber: page,
            pageSize: size,
            sortBy: "productName",
            sortOrder: "asc",
          },
        }
      );
      setProductsData(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts(productsData.pageNumber, productsData.pageSize);
  }, []);

  const productVariants: VariantRowType[] = useMemo(() => {
    return productsData.content.flatMap((product) =>
      product.variants && product.variants.length > 0
        ? product.variants.map((variant) => ({
            variantId: variant.variantId,
            price: variant.price,
            quantity: variant.quantity,
            size: variant.size.name,
            sku: variant.sku,
            color: variant.color.name,
            productName: product.productName,
            productId: product.productId,
          }))
        : []
    );
  }, [productsData]);

  const deleteVariant = async (variant: VariantRowType) => {
    try {
      await axios.delete(
        `http://localhost:8080/api/admin/variants/${variant.variantId}`
      );
      fetchProducts(productsData.pageNumber, productsData.pageSize);
      setOpen(false);
    } catch (err) {
      console.error(err);
    }
  };
  const handleEdit = (item: VariantRowType) => {
    setSelectedVariantRow(item);
    setOpen(true);
  };
  // Pagination handlers
  const handlePrevPage = () => {
    if (productsData.pageNumber > 0) {
      fetchProducts(productsData.pageNumber - 1, productsData.pageSize);
    }
  };

  const handleNextPage = () => {
    if (productsData.pageNumber < productsData.totalPages - 1) {
      fetchProducts(productsData.pageNumber + 1, productsData.pageSize);
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-4">Products</h1>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <>
          <AdminTable
            data={productVariants}
            columns={[
              { key: "variantId", label: "Variant ID", sortable: true },
              { key: "productName", label: "Product Name" },
              { key: "price", label: "Price", sortable: true },
              { key: "quantity", label: "Quantity", sortable: true },
              { key: "sku", label: "sku", sortable: true },

              {
                key: "size",
                label: "Size",
                render: (item: VariantRowType) => item.size,
              },
              {
                key: "color",
                label: "Color",
                render: (item: VariantRowType) => item.color,
              },
            ]}
            onEdit={(item: VariantRowType) =>
              router.push(
                `/products/edit?productId=${item.productId}&variantId=${item.variantId}`
              )
            }
            onDelete={handleEdit}
          />

          {/* Pagination */}
          <div className="mt-4 flex justify-between">
            <button
              disabled={productsData.pageNumber === 0}
              onClick={handlePrevPage}
              className="px-4 py-2 bg-gray-200 rounded disabled:opacity-50"
            >
              Prev
            </button>
            <span>
              Page {productsData.pageNumber + 1} / {productsData.totalPages}
            </span>
            <button
              disabled={productsData.pageNumber >= productsData.totalPages - 1}
              onClick={handleNextPage}
              className="px-4 py-2 bg-gray-200 rounded disabled:opacity-50"
            >
              Next
            </button>
          </div>
        </>
      )}
      <CloseDialog<VariantRowType>
        open={open}
        title={`Delete a variant`}
        field={`Do you want to delete this variant ${selectedVariantRow?.productName} with color ${selectedVariantRow?.color} ${selectedVariantRow?.size}`}
        item={selectedVariantRow}
        onOpenChange={setOpen}
        onDelete={async (deleted: VariantRowType | null) => {
          if (deleted) {
            console.log(1);
            await deleteVariant(deleted);
          }
        }}
      />
    </div>
  );
}
