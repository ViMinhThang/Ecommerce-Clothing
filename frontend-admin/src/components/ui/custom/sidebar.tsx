"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { Home, Users, SquareChartGantt, StretchHorizontal } from "lucide-react";

const menuItems = [
  { name: "Dashboard", href: "/", icon: Home },
  { name: "Users", href: "/users", icon: Users },
  { name: "Products", href: "/products", icon: StretchHorizontal },
  { name: "Orders", href: "/orders", icon: SquareChartGantt },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="fixed left-0 top-0 h-full w-64 border-r bg-background p-4">
      <div className="mb-6 text-2xl font-bold">Admin Panel</div>
      <nav className="flex flex-col gap-2">
        {menuItems.map((item) => {
          const Icon = item.icon;
          const active = pathname === item.href;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-all hover:bg-accent hover:text-accent-foreground",
                active
                  ? "bg-accent text-accent-foreground"
                  : "text-muted-foreground"
              )}
            >
              <Icon className="h-4 w-4" />
              {item.name}
            </Link>
          );
        })}
      </nav>
    </aside>
  );
}
