import * as usersRepository from "./users.repository.ts";
import type * as userTypes from "./users.type.ts";

// pega todos os utilizadores: rota de admin
export async function getAllUsers() {
  const users = await usersRepository.getAllUsers();
  return users;
}

export async function createUser(data: userTypes.Users) {
  //logica pra enviar para bd
  const users = await usersRepository.createUser(data);
  return users;
}

// pega utilizador pelo ID
export async function getUser(id: string) {
  const user = await usersRepository.findById(id);
  if (!user) {
    throw new Error("User not found");
  }
  return user;
}

// dita utilizador pelo id
export async function editUser(id: string) {
  const user = await usersRepository.findById(id);
  if (!user) {
    throw new Error("User not found");
  }
  // logica de editar utilizador
  // envia para o userRepository fazer um update
  return user; // retorna já editado bonitinho
}

export async function deleteUser(id: string) {
  const user = await usersRepository.findById(id);
  if (!user) {
    throw new Error("User not found");
  }
  // envia para o userRepository deletar
  return user; // retorna já editado bonitinho
}
