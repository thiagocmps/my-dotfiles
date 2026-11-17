import express from "express";
const userController = "./users.controllers.ts"
export const userRouter = express.Router();

userRouter.get("/user", async function(req, res) {
  try {
    await userController.
  } catch (error) {
  }
})
