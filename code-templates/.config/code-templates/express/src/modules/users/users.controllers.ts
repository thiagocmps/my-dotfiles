import type { Request, Response } from "express";
import * as userService from "./users.service.ts";

// rota para criar utilizador ================================================
export async function createUser(_req: Request, res: Response) {
  const { name, email, password } = _req.body;
  const userData = {
    name: name,
    email: email,
    password: password,
  };
  const user = await userService.createUser(userData);

  res.status(200).json({ user, message: "User was created successfully." });
}
// rota para pegar todos os utilizadores
// lembrar de criar middleware isAdmin para essa rota.
export async function getAllUsers(_req: Request, res: Response) {
  const user = await userService.getAllUsers();
  res.status(200).json({ user, message: "All users were fetched." });
}

// Rotas que exigem ID do utilizador ==========================================
// pega utilizador
export async function getUser(_req: Request<{ id: string }>, res: Response) {
  const { id } = _req.params;
  const user = await userService.getUser(id);
  res.status(200).json({ user, message: "User was fetched." });
}

// edita o utilizador
export async function editUser(_req: Request<{ id: string }>, res: Response) {
  const { id } = _req.params;
  const user = await userService.editUser(id);
  res.status(200).json({ user, message: "User was edited successfully." });
}

// deleta o utilizador
export async function deleteUser(_req: Request<{ id: string }>, res: Response) {
  const { id } = _req.params;
  const user = await userService.deleteUser(id);
  res.status(200).json({ user, message: "User was deleted successfully." });
}
