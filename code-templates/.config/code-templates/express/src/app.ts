import express from "express";
import type { Request, Response } from "express";
import userRoutes from "./modules/users/users.routes.ts";
// importa os routes por modulos (exemplo: user.routes, books.routes, etc)

const app = express();

app.use(express.json());
app.use("/api/users", userRoutes);
app.get("/api/health", (_req: Request, res: Response) => {
  res.status(200).json({
    status: "ok",
    name: "node-backend",
  });
});

export default app;
