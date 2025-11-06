import { ChartLineInteractive } from "@/components/common/ChartOrders";
import { ChartRadarDefault } from "@/components/common/ChartPerformance";
import { ChartLineDefault } from "@/components/common/ChartUsers";
import MetricCard from "@/components/common/MetricCard";
import { ChartPieSimple } from "@/components/common/PieProductSold";
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { TrendingUp } from "lucide-react";

export default function Page() {
  return (
    <div className="flex flex-col space-y-2">
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <MetricCard
          title="Total Revenue"
          value="$1,024"
          change={12}
          trend="up"
          description="Revenue increased this month"
          subtext="Revenue for the last 6 months"
        />

        <MetricCard
          title="Total Orders"
          value="384"
          change={-8}
          trend="down"
          description="Orders decreased this month"
          subtext="Compared to last 6 months"
        />

        <MetricCard
          title="New Customers"
          value="120"
          change={15}
          trend="up"
          description="Customer growth rate"
          subtext="vs previous month"
        />

        <MetricCard
          title="Conversion Rate"
          value="4.3%"
          change={1.2}
          trend="up"
          description="Better conversion performance"
        />
      </div>
      <div className="flex flex-col gap-2">
        <ChartLineInteractive />
        <div className="grid grid-cols-3 gap-2">
          <ChartLineDefault />
          <ChartPieSimple />
          <ChartRadarDefault />
        </div>
      </div>
    </div>
  );
}
