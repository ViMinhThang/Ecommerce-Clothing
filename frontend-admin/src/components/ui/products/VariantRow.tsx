import { Bolt, Tag } from "lucide-react";
import Image from "next/image";

// 🧩 Variant table row
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const VariantRow = ({ item }: { item: any }) => (
  <div className="grid grid-cols-7 border-b hover:bg-secondary transition-colors">
    <div className="text-slate-700 pe-2 py-2">
      <Image
        className="rounded-lg object-cover"
        src={item.image_url}
        alt={item.color_id}
        width={100}
        height={100}
      />
    </div>
    <div className="flex items-center text-slate-700 pe-2 py-2">
      {item.size_id}
    </div>
    <div className="flex items-center text-slate-700 pe-2 py-2">
      {item.color_id}
    </div>
    <div className="flex items-center text-slate-700 pe-2 py-2">
      {item.price}$
    </div>
    <div className="flex items-center text-slate-700 pe-2 py-2">
      {item.stock_quantity}
    </div>
    <div className="flex items-center text-slate-700 pe-2 py-2">
      <span
        className={`flex items-center gap-2 text-sm p-2 rounded-lg ${
          item.isActive ? "bg-green-200" : "bg-red-200"
        }`}
      >
        {item.isActive ? "Enable" : "Disable"}
        <Tag size={16} />
      </span>
    </div>
    <div className="flex items-center gap-4 px-2">
      <Bolt className="cursor-pointer text-slate-500 hover:text-blue-500" />
    </div>
  </div>
);
