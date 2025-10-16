"use client";
import { useRef, useState } from "react";
import Image from "next/image";
import { Upload, Trash, Check } from "lucide-react";
import { Button } from "@/components/ui/button";

export const ProductImages = () => {
  const [images, setImages] = useState<string[]>([]);
  const [selectedImages, setSelectedImages] = useState<string[]>([]);
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement | null>(null);

  const handleUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files) return;

    const newImages = Array.from(files).map((file) =>
      URL.createObjectURL(file)
    );
    setImages((prev) => [...prev, ...newImages]);
  };

  const handleDelete = (url: string) => {
    setImages((prev) => prev.filter((img) => img !== url));
    setSelectedImages((prev) => prev.filter((img) => img !== url));
    setError(null);
  };

  const handleSelect = (url: string) => {
    if (selectedImages.includes(url)) {
      setSelectedImages((prev) => prev.filter((img) => img !== url));
      setError(null);
    } else {
      if (selectedImages.length >= 4) {
        setError("You can only select up to 4 images to submit.");
        return;
      }
      setSelectedImages((prev) => [...prev, url]);
      setError(null);
    }
  };

  const handleSave = () => {
    if (selectedImages.length === 0) {
      setError("Please select up to 4 images before submitting.");
      return;
    }

    setError(null);

    console.log("Selected images to submit:", selectedImages);
    alert(`Submitting ${selectedImages.length} selected images.`);
  };

  return (
    <div className="bg-background p-5 rounded-lg border-3">
      <h1 className="font-bold text-lg mb-5">Product Images</h1>

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

      {/* Uploaded images */}
      {images.length > 0 && (
        <div className="grid grid-cols-3 gap-4 mt-5">
          {images.map((url, index) => {
            const isSelected = selectedImages.includes(url);
            return (
              <div key={index} className="relative group">
                <Image
                  src={url}
                  alt={`Uploaded ${index}`}
                  width={300}
                  height={300}
                  className={`rounded-lg object-cover w-full h-40 ${
                    isSelected ? "ring-4 ring-green-400" : ""
                  }`}
                />

                {/* Hover buttons */}
                <div className="absolute top-2 left-2 flex gap-2 opacity-0 group-hover:opacity-100 transition">
                  <button
                    onClick={() => handleDelete(url)}
                    className="bg-white p-1 rounded-full shadow hover:bg-red-100"
                  >
                    <Trash size={16} className="text-red-500" />
                  </button>

                  <button
                    onClick={() => handleSelect(url)}
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
