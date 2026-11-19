import type * as userType from "./users.type.ts";

export async function findById(id: string) {
  //consulta o banco de dados. isso é só pra encher linguiça
  if (!id) {
    console.log(`id não encontrado: ${id}`);
  } else {
    console.log(`id encontrado: ${id}`);
  }
  const user = {
    name: "User",
    email: "email@email.com",
    password: "123456",
  };
  return user;
}

export async function findByEmail(email: string) {
  //consulta o banco de dados. isso é só pra encher linguiça
  if (!email) {
    console.log(`id não encontrado: ${email}`);
  } else {
    console.log(`id encontrado: ${email}`);
  }
  const user = {
    name: "User",
    email: "email@email.com",
    password: "123456",
  };
  return user;
}

export async function getAllUsers() {
  //consulta o banco de dados. isso é só pra encher linguiça
  const users = [
    {
      name: "User",
      email: "email@email.com",
      password: "123456",
    },
    {
      name: "User1",
      email: "email1@email.com",
      password: "123456",
    },
  ];
  return users;
}

export async function createUser(data: userType.Users) {
  if (!data) {
    console.log("Campos obrigatórios não encontrados.");
  }
  // envia pra base de dados, to só fazendo graça
  const user = data;

  return user;
}
// o resto: Enviar pra base de dados, atualizar, deletar etc.
