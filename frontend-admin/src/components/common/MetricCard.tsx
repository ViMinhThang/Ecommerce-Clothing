import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
} from "@/components/ui/card";
import { TrendingUp, TrendingDown } from "lucide-react";

interface MetricCardProps {
  title: string;
  value: string | number;
  change?: number;
  trend?: "up" | "down";
  description?: string;
  subtext?: string;
}

export default function MetricCard({
  title,
  value,
  change = 0,
  trend = "up",
  description,
  subtext,
}: MetricCardProps) {
  const TrendIcon = trend === "up" ? TrendingUp : TrendingDown;
  const trendColor = trend === "up" ? "text-green-500" : "text-red-500";

  return (
    <Card className="shadow-sm border-1">
      <CardHeader className="space-y-1">
        <div className="flex justify-between items-center">
          <CardDescription className="text-md">{title}</CardDescription>
          <div className="flex items-center border px-2 py-0.5 rounded-sm gap-1">
            <TrendIcon size={12} />
            <p className={`text-xs`}>
              {change > 0 ? `+${change}%` : `${change}%`}
            </p>
          </div>
        </div>
        <CardTitle className="text-3xl font-bold">{value}</CardTitle>
      </CardHeader>

      <CardContent className="space-y-1 text-sm">
        {description && (
          <p className="flex items-center gap-1 font-bold">
            {description} <TrendIcon size={16} />
          </p>
        )}
        {subtext && <p className="text-muted-foreground">{subtext}</p>}
      </CardContent>
    </Card>
  );
}
