import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import data from "@/data/product";
import React from "react";

const Page = () => {
  const order = data.orders[0];
  const user = data.users[0];
  return (
    <>
      <div className="border-b-2 pb-2">
        <h1 className="font-bold text-2xl">Order Details</h1>
      </div>
      <div className="flex items-start gap-5 ">
        <div className="flex flex-col w-[80%]">
          <div className="bg-background shadow-md p-5 mt-5 rounded-lg border-3">
            <h1 className="font-bold">Order number #{order.id}</h1>
            <div className="mt-2 ">
              <h1>User information:</h1>
              <p>Email: {user.email}</p>
              <p>User name: {user.username}</p>
              <p>Created At: {user.created_at}</p>
            </div>
          </div>
          <div className="mt-5">
            {order.items.map((od, id) => (
              <Card className="mb-2 shadow-md border-3 bg-background" key={id}>
                <CardHeader>
                  <CardTitle>Id #{od.product_id}</CardTitle>
                </CardHeader>
                <CardContent>
                  <p>product name: {od.variant_id}</p>
                  <p>quantity: {od.quantity}</p>
                  <p>unit price: {od.unit_price}</p>{" "}
                </CardContent>
                <CardFooter>
                  <p>sub total : {od.subtotal}</p>
                </CardFooter>
              </Card>
            ))}
          </div>
        </div>
        <div className="flex flex-col w-[20%]">
          <div className="bg-background p-5 mt-5 rounded-lg me-5 border-3 shadow-md">
            <h1 className="font-bold">Shipping Address</h1>
            <div className="mt-2 space-y-2">
              <p>Street: 12 Nguyễn Văn Cừ</p>
              <p>District: Quận 1</p>
              <p>City: TP.HCM</p>
              <div className="flex items-center gap-2">
                Status:
                <select className="bg-background text-foreground p-2 rounded-lg">
                  <option>Shipping</option>
                  <option>Cancelled</option>
                  <option>Completed</option>
                  <option>Pending</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Page;
