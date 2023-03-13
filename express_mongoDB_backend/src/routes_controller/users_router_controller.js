import express from 'express'
import UserController from "../controller/user_controller.js"

const usersRouterController = express.Router();

usersRouterController.post('/creation',UserController.createUser);
usersRouterController.get('/users',UserController.getAllUsers);
usersRouterController.get('/user',UserController.getResultActualUser);
usersRouterController.get('/users/:carnet',UserController.getUserByCI);
usersRouterController.get('/users/:carnet/metrocounter/:tipoMetro',UserController.getUserByCIandMetroType);
usersRouterController.delete('/users/:carnet',UserController.deleteUserByCI);

export default usersRouterController;