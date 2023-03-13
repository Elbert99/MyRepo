import mongoose from 'mongoose';

const UserSchema = mongoose.Schema({
    carnet:{
        type: String,
        required: true,
        trim: true,
    },
    nombre:{
        type: String,
        required: true,
        trim: true,
    },
    dirección:{
        type: String,
        required: true,
        trim: true,
    },
    municipio:{
        type: String,
        required: true,
        trim: true,
    },
    tipoMetro:{
        type: String,
        required: true,
        trim: true,
    },
    lectura:{
        type: Number,
        required: true,
        trim: true,
    },
    mes_de_envio_lectura:{
        type: Number,
        required: true,
        trim: true,
    },
    consumo:{
        type: Number,
        required: true,
        trim: true,
        default: 0
    },
    tarifa:{
        type: Number,
        required: true,
        trim: true,
        default: 0
    },
    timestamp:{
        type: Date,
        default: Date.now
    }
})

const UserModel = mongoose.model('consumo_metros', UserSchema);

export default UserModel;