import express from "express";
import type { Request, Response } from "express";
import userRouter from "./modules/users/users.routes.ts";
const app = express();

app.use(express.json());
app.use("/api/users", userRouter);
app.get("/api/health", (_req: Request, res: Response) => {
  res.status(200).json({
    status: "ok",
    name: "node-backend",
  });
});

export default app;
