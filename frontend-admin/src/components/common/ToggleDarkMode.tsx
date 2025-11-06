"use client";

import { useTheme } from "next-themes";
import { useEffect, useState } from "react";
import { Sun, Moon } from "lucide-react";

export default function ThemeToggle() {
  const { theme, setTheme, systemTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => setMounted(true), []);

  if (!mounted) return null;

  const current = theme === "system" ? systemTheme : theme;

  return (
    <button
      aria-label="Toggle theme"
      className="rounded-md hover:bg-muted transition"
      onClick={() => {
        if (current === "dark") setTheme("light");
        else setTheme("dark");
      }}
    >
      {current === "dark" ? (
        <div className="flex items-center">
          {" "}
          <Sun className="w-4 h-4" />
          <p>Light Mode</p>
        </div>
      ) : (
        <div className="flex items-center">
          {" "}
          <Moon className="w-4 h-4" />
          <p>Dark Mode</p>
        </div>
      )}
    </button>
  );
}
