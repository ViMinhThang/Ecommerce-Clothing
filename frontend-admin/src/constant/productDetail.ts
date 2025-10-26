const basicInfoFields = [
  { id: "name", label: "Name", placeholder: "Product name", type: "text" },
  {
    id: "category",
    label: "Category",
    placeholder: "Category name",
    type: "text",
  },
];

const detailsFields = [
  { id: "SKU", label: "SKU", placeholder: "SKU", type: "text" },
  { id: "Price", label: "Price", placeholder: "Price", type: "number" },
];
const fields = { basicInfoFields, detailsFields };
export default fields;
