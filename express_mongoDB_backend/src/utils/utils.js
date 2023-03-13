class Utils{
    //Atributos
    //_id = 'Null';
    //_consume = 0;
    //_toPay = 0;

    //Constructor
     Utils(){
    }
    
   // initializer(id, consume, toPay) {
    //    this._id = id;
    //    this._consume = consume;
     //   this._toPay = toPay;
     //   console.log(this._id,this._consume,this._toPay);
    //}

    //sendBackNodeRed(){
      //  const response = {carnet: this._id, consumo:  this._consume, tarifa: this._toPay}
      //  console.log(response);
      // return response
    //}

    validatOneMonth(monthNumberActual, monthNumberLast){
        var validated = true;
        var validator = monthNumberActual-monthNumberLast; 
        if (validator < 0) {
            validator = validator * (-1);
        } 
        if (validator != 1) {
            validated = false;
        } 
        return validated;
    }

    calculateMonthConsumo(actualLecture,lastLecture){
        var monthConsumo = actualLecture - lastLecture; //lo q se toma es la diferencia, el metro siempre va en aumento, por eso es actual - anterior del mes pasado excepto 99 999.9 el proximo es 00 000.1 , por lo que aqui es negativo y no se puede trabajar con valores menores a 0 por eso lo convierto en positivo
        if (monthConsumo < 0) {
            monthConsumo = monthConsumo * (-1);
        } 
        return monthConsumo;
    }
    
    calculatePay(consumo, metroType) {
        var toPay = 0;
         if(metroType == "Electricidad"){
         toPay = this.toPayElectricity(consumo);
         }
         else if(metroType == "Gas"){
         toPay = this.toPayGas(consumo);
         }
         else {
         toPay = this.toPayWater(consumo);
         }
         return toPay;
     } 
     
     toPayElectricity(consumoElectric){
         var tramoEnergetico = [100,50,50,50,50,50,50,50,50,100,100,300,800,800,800,800,800];
         var out = new Boolean(false);
         var i = 0;
         var toPayElectricity = 0;
         var consumoTemp = consumoElectric;

         if (consumoTemp!=0) {
            while (i < tramoEnergetico.length && out==false) {
                 if (i==0) {
                     if(consumoTemp < tramoEnergetico[i]){
                     toPayElectricity = toPayElectricity + (consumoTemp*0.33);
                    }else{
                       
                        toPayElectricity = toPayElectricity + 33.00; //CUP
                    } 
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                         out = true;
                     }
                 } else if (i==1) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*1.07);
                    }else{
                        toPayElectricity = toPayElectricity + 53.50; //CUP
                     } 
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                     if (consumoTemp <= 0) {
                         out = true;
                     }
                 }else if (i==2) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*1.43);
                    }else{
                        toPayElectricity = toPayElectricity + 71.50; //CUP
                     } 
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                     if (consumoTemp <= 0) {
                         out = true;
                     }
                 }else if (i==3) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*2.46);
                    }else{
                        toPayElectricity = toPayElectricity + 123.00; //CUP
                     } 
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                     if (consumoTemp <= 0) {
                         out = true;
                     }
                 }else if (i==4) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*3.00);
                    }else{
                        toPayElectricity = toPayElectricity + 150.00; //CUP
                     } 
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                     if (consumoTemp <= 0) {
                         out = true;
                     }
                 }else if (i==5) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*4.00);
                    }else{
                        toPayElectricity = toPayElectricity + 200.00; //CUP
                     } 
                      consumoTemp = consumoTemp - tramoEnergetico[i];
                     if (consumoTemp <= 0) {
                         out = true;
                     }
                 }else if (i==6) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*5.00);
                    }else{
                        toPayElectricity = toPayElectricity + 250.00; //CUP
                     }
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==7) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*6.00);
                    }else{
                        toPayElectricity = toPayElectricity + 300.00; //CUP
                     }
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==8) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*7.00);
                    }else{
                        toPayElectricity = toPayElectricity + 350.00; //CUP
                     }
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==9) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*9.20);
                    }else{
                        toPayElectricity = toPayElectricity + 920.00; //CUP
                     }
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==10) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*9.45);
                    }else{
                        toPayElectricity = toPayElectricity + 945.00; //CUP
                     }
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==11) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*9.85);
                    }else{
                        toPayElectricity = toPayElectricity + 2955.00; //CUP
                     }
                   consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==12) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*10.80);
                    }else{
                        toPayElectricity = toPayElectricity + 8640.00; //CUP
                     }
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==13) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*11.80);
                    }else{
                        toPayElectricity = toPayElectricity + 9440.00; //CUP
                     }
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==14) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*12.90);
                    }else{
                        toPayElectricity = toPayElectricity + 10320.00; //CUP
                     }
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==15) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*13.95);
                    }else{
                        toPayElectricity = toPayElectricity + 11160.00; //CUP
                     }
                     consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==16) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayElectricity = toPayElectricity + (consumoTemp*15.00);
                    }else{
                        toPayElectricity = toPayElectricity + 12000.00; //CUP
                     }
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                    else {
                        toPayElectricity = toPayElectricity + (consumoTemp*20.00); //+5000 de consumo, lo que quedo x 20 + la tarifa acumulada = tarifa total con condicion max de mas de 5000 de consumo
                    }
                }
                 i++;
             }
         }
         return toPayElectricity; 
     }
         
     toPayGas(consumoGas){
        var toPayGas = consumoGas * 2.50;
        return toPayGas; 
     }
     
     toPayWater(consumoWater){
        var tramoEnergetico = [3.0,1.5,1.5,1.5,1];
        var out = new Boolean(false);
        var i = 0;
        var toPayWater = 0;
        var consumoTemp = consumoWater;

        if (consumoTemp!=0) {
           while (i < tramoEnergetico.length && out==false) {
                if (i==0) {
                    if(consumoTemp < tramoEnergetico[i]){
                        toPayWater  = toPayWater  + (consumoTemp*1.75);
                   }else{
                    toPayWater = toPayWater + 5.25; //CUP
                   } 
                   consumoTemp = consumoTemp - tramoEnergetico[i];
                   if (consumoTemp <= 0) {
                        out = true;
                    }
                } else if (i==1) {
                   if(consumoTemp < tramoEnergetico[i]){
                    toPayWater = toPayWater + (consumoTemp*3.50);
                   }else{
                    toPayWater = toPayWater + 5.25; //CUP
                    } 
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==2) {
                   if(consumoTemp < tramoEnergetico[i]){
                    toPayWater = toPayWater + (consumoTemp*5.25);
                   }else{
                    toPayWater = toPayWater+ 7.875; //CUP
                    } 
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==3) {
                   if(consumoTemp < tramoEnergetico[i]){
                    toPayWater = toPayWater + (consumoTemp*7.00);
                   }
                   else{
                    toPayWater = toPayWater + 10.50; //CUP
                    } 
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                }else if (i==4) {
                   if(consumoTemp < tramoEnergetico[i]){
                    toPayWater = toPayWater + (consumoTemp*10.50);
                   }else{
                    toPayWater = toPayWater + 10.50; //CUP
                    } 
                    consumoTemp = consumoTemp - tramoEnergetico[i];
                    if (consumoTemp <= 0) {
                        out = true;
                    }
                   else {
                    toPayWater = toPayWater + (consumoTemp*21.00); //+8.5m3 de consumo, lo que quedo x 21 + la tarifa acumulada = tarifa total
                   }
               }
                i++;
            }
        }
        return toPayWater; 
     }

}

export default Utils