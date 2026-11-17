import app from "./app.ts";
import env from "./config/env.ts";
const PORT = env.PORT;
// import cors from "cors";
//app.use(({ origin: ["http://localhost:4200"], credentials: true }));

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
