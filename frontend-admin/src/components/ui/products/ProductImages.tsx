"use client";
import { useRef, useState, useEffect } from "react";
import Image from "next/image";
import { Upload, Trash, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import axios from "axios";
import { useSearchParams } from "next/navigation";
import { VariantImage } from "@/types/Product";

interface ProductImagesProps {
  images?: VariantImage[];
}

export const ProductImages = ({
  images: initialImages = [],
}: ProductImagesProps) => {
  const [images, setImages] = useState<VariantImage[]>([]);
  const [selectedImages, setSelectedImages] = useState<string[]>([]);
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement | null>(null);
  const searchParams = useSearchParams();
  const variantId = searchParams.get("variantId");

  // --- Load ảnh ban đầu ---
  useEffect(() => {
    if (initialImages && initialImages.length > 0) {
      setImages(initialImages);
    }
  }, [initialImages]);

  // --- Upload ảnh ---
  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files) return;

    if (!variantId) {
      setError("Missing variantId — cannot upload image.");
      return;
    }

    const newImages: VariantImage[] = [];

    for (const file of Array.from(files)) {
      const formData = new FormData();
      formData.append("file", file);
      formData.append("variantId", variantId);

      try {
        const res = await axios.post(
          "http://localhost:8080/api/admin/variants/variant-images/upload",
          formData,
          { headers: { "Content-Type": "multipart/form-data" } }
        );
        // Giả sử server trả về { id, imageUrl }
        newImages.push(res.data);
      } catch (err) {
        console.error("Upload failed:", err);
        setError("Failed to upload image.");
      }
    }

    setImages((prev) => [...prev, ...newImages]);
    setError(null);
  };

  // --- Xoá ảnh ---
  const handleDelete = async (id: number) => {
    try {
      await axios.delete(
        `http://localhost:8080/api/admin/variants/variant-images/${id}`
      );
      setImages((prev) => prev.filter((img) => img.id !== id));
      setSelectedImages((prev) =>
        prev.filter((url) => {
          const img = images.find((i) => i.id === id);
          return img ? url !== img.imageUrl : true;
        })
      );
      setError(null);
    } catch (err) {
      console.error("Error deleting image:", err);
      setError("Failed to delete image from server.");
    }
  };

  // --- Chọn ảnh ---
  const handleSelect = (url: string) => {
    if (selectedImages.includes(url)) {
      setSelectedImages((prev) => prev.filter((img) => img !== url));
    } else {
      if (selectedImages.length >= 4) {
        setError("You can only select up to 4 images to submit.");
        return;
      }
      setSelectedImages((prev) => [...prev, url]);
    }
    setError(null);
  };

  // --- Lưu ảnh được chọn ---
  const handleSave = async () => {
    if (selectedImages.length === 0) {
      setError("Please select up to 4 images before submitting.");
      return;
    }

    try {
      await axios.put(
        `http://localhost:8080/api/admin/variants/${variantId}/main-images`,
        {
          imageUrls: selectedImages,
        }
      );
      alert("Saved selected images successfully!");
    } catch (err) {
      console.error(err);
      setError("Failed to save selected images.");
    }
  };
  console.log(images);
  return (
    <div className="bg-background p-5 rounded-lg border-3">
      <h1 className="font-bold text-lg mb-5">Product Images</h1>

      {/* Upload zone */}
      <div
        onClick={() => fileInputRef.current?.click()}
        className="border-2 border-dashed border-gray-300 p-10 text-center rounded-lg cursor-pointer hover:bg-background transition"
      >
        <Upload className="mx-auto mb-2 text-gray-500" size={28} />
        <p className="text-gray-600">Click to upload product images</p>
        <input
          type="file"
          ref={fileInputRef}
          onChange={handleUpload}
          multiple
          accept="image/*"
          className="hidden"
        />
      </div>

      {/* Error */}
      {error && <p className="text-red-500 mt-2 text-sm">{error}</p>}

      {/* Image Grid */}
      {images.length > 0 && (
        <div className="grid grid-cols-3 gap-4 mt-5">
          {images.map((img, idx) => {
            const isSelected = selectedImages.includes(img.imageUrl);
            return (
              <div key={idx} className="relative group">
                {img.imageUrl && (
                  <Image
                    src={img.imageUrl}
                    alt={`Product ${img.id}`}
                    width={300}
                    height={300}
                    unoptimized
                    className={`rounded-lg object-cover w-full h-40 ${
                      isSelected ? "ring-4 ring-green-400" : ""
                    }`}
                  />
                )}

                <div className="absolute top-2 left-2 flex gap-2 opacity-0 group-hover:opacity-100 transition">
                  <button
                    onClick={() => handleDelete(img.id)}
                    className="bg-white p-1 rounded-full shadow hover:bg-red-100"
                  >
                    <Trash size={16} className="text-red-500" />
                  </button>
                  <button
                    onClick={() => handleSelect(img.imageUrl)}
                    className={`bg-white p-1 rounded-full shadow hover:bg-green-100 ${
                      isSelected ? "bg-green-200" : ""
                    }`}
                  >
                    <Check
                      size={16}
                      className={`${
                        isSelected ? "text-green-600" : "text-gray-500"
                      }`}
                    />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Save button */}
      <div className="mt-5 flex justify-end">
        <Button
          onClick={handleSave}
          disabled={selectedImages.length === 0}
          className={`${
            selectedImages.length === 0
              ? "opacity-50 cursor-not-allowed"
              : "cursor-pointer bg-background border-secondary"
          }`}
        >
          Save ({selectedImages.length}/4)
        </Button>
      </div>
    </div>
  );
};
