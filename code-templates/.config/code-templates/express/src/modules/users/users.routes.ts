import { Router } from "express";
import * as userControllers from "./users.controllers.ts";
const router = Router();

// "_" antes de "_req" é convenção para uma variavel que nao pretende ser usada
// não esquecer de criar middleware de autenticacao e verificacao de admin.
// CRUD - Create, Read, Update e Delete
router.post("/", userControllers.createUser);
router.get("/", userControllers.getAllUsers);
router.get("/:id", userControllers.getUser);
router.put("/:id", userControllers.editUser);
router.delete("/:id", userControllers.deleteUser);

export default router;
