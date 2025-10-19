"use client";
import React, { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import axios from "axios";
import { AdminTable } from "@/components/admin/AdminTable";
import { Product } from "@/types/Product";

export default function ProductPage() {
  const [productsData, setProductsData] = useState({
    content: [],
    pageNumber: 0,
    pageSize: 10,
    totalElements: 0,
    totalPages: 0,
    lastPage: true,
  });
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const fetchProducts = async (page = 0, size = 10) => {
    setLoading(true);
    try {
      const response = await axios.get(
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
      setProductsData(response.data);
    } catch (error) {
      console.error("Error fetch product:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts(productsData.pageNumber, productsData.pageSize);
  }, []);

  // Flatten variants for table
  const productVariants = useMemo(() => {
    return productsData.content.flatMap((product: Product) =>
      product.variants.map((variant) => ({
        id: variant.variantId,
        productName: product.productName,
        price: variant.price,
        quantity: variant.quantity,
        size: variant.size?.name,
        color: variant.color?.name,
        images: variant.images?.map((img) => img.imageUrl).join(", "),
      }))
    );
  }, [productsData]);
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
              { key: "id", label: "Variant ID", sortable: true },
              { key: "productName", label: "Product Name" },
              { key: "price", label: "Price", sortable: true },
              { key: "quantity", label: "Quantity", sortable: true },
              { key: "size", label: "Size" },
              { key: "color", label: "Color" },
            ]}
            onEdit={(item) => router.push(`/products/${item.id}/edit`)}
            onDelete={(item) => console.log("Delete", item)}
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
    </div>
  );
}
