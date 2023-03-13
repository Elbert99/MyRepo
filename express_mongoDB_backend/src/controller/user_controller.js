import UserModel from "../model/user_model.js";
import Utils from "../utils/utils.js";

class UserController {
    static createUser = async(req, res)=>{
        try {
           //create new user
           const user = new UserModel(req.body);
           //find last user with matches to calculate consumo
           const lastUserMatch =  await UserModel.findOne({carnet: req.body.carnet,tipoMetro: req.body.tipoMetro})
           .sort({$natural:-1});
           const calculator = new Utils();

           if (lastUserMatch != null) {
            //calculate monthConsumo and set user.consumo
           user.consumo = calculator.calculateMonthConsumo(req.body.lectura,lastUserMatch.lectura); 
            
           //calculate toPay with month consume
           user.tarifa = calculator.calculatePay(user.consumo, req.body.tipoMetro);
           console.log('Matches Last',lastUserMatch);

           await user.save();
           console.log('A new user is add. Please check', req.body.nombre,user.consumo, user.tarifa);
           } else {
            await user.save();
            console.log('A new user is add. Please check', req.body.nombre);
           }

           //res.json(user);
           res.json({ message: 'New user is added'});
        } catch (error) {
            console.log(error);
        }   
   }

 static getAllUsers = async(req, res) =>{
    try {
    const result = await UserModel.find()
    res.send(result)
    } catch (error) {
    console.log(error)
    }
  }

  static getResultActualUser = async(req, res) =>{
    try {
    const result =  await UserModel.findOne().sort({$natural:-1});
    res.send(result)
    } catch (error) {
    console.log(error)
    }
  }

  static getUserByCI = async(req, res) =>{
    try {
    const result = await UserModel.find({carnet: req.params.carnet})
    res.json(result)
    } catch (error) {
    console.log(error)
    }
  }
  
  static getUserByCIandMetroType = async(req, res) =>{
    try {
    const result = await UserModel.find({carnet: req.params.carnet, tipoMetro: req.params.tipoMetro})
    res.json(result)
    } catch (error) {
    console.log(error)
    }
  }
  
  static deleteUserByCI = async(req, res)=>{
    try {
       //delete user by CI
       await UserModel.deleteMany({carnet:req.params.carnet});
       console.log('User deleted');
       res.json({ message: 'User deleted'});
    } catch (error) {
        console.log(error);
    }   
 }
   
}
export default UserController