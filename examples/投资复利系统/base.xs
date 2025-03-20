
//食物资源ID
extern const int rFoodStorage = 0;
//木材资源ID
extern const int rWoodStorage = 1;
//石头资源ID
extern const int rStoneStorage = 2;
//黄金资源ID
extern const int rGoldStorage = 3;

// round: 对实数 f_ 按照小数位数 n 进行四舍五入
float round(float val_=0.0f, int n=0) {float num=0;int pn=pow(10,n);float pf=val_*pn;int ipf=1*pf; if(abs(pf-ipf)<0.5){num=1.0*ipf/pn;} else{num=1.0*(ipf+1)/pn;} return(num);}

float random(bool sign_=false) 
{
    static float sign=1.0;
    if(sign_){sign=0.0-sign;}
    float rn=xsGetRandomNumber();
    int I=xsGetRandomNumberLH(0,31);
    if(I>=30){rn=xsGetRandomNumberLH(0,16990);}
    rn=0.000001*sign*(rn+I*32767);
    static int fix=1; fix=0-fix;
    if((rn>0.83&&rn<0.88)&&(fix==1)){rn=rn-0.72;}
    return (rn);
}

void xsModResource(int p=0, int src_id=0, string operate="+", float amt_=0.0) 
{
         if(operate=="set") {xsEffectAmount(1, src_id, 0, amt_, p);}
    else if(operate=="add") {xsEffectAmount(1, src_id, 1, amt_, p);}
    else if(operate=="sub") {xsEffectAmount(1, src_id, 1, 0.0-amt_, p);}
    else if(operate=="mul") {xsEffectAmount(6, src_id, 0, amt_, p);}
    else {}
}

/**
 * @brief 设置 贸易工厂(1647) 资源生成率（点/秒）
 * @param WR: 贸易工厂木材生成率[243]
 * @param FR: 贸易工厂食物生成率[242]
 * @param GR: 贸易工厂黄金生成率[245]
 * @param SR: 贸易工厂石头生成率[244]
 * @param p: 玩家序号 [-1, 8]
 * @return <void>
**/
void Fac1647Rate(float WR=0, float FR=0, float GR=0, float SR=0, int p=-1) 
{
    xsEffectAmount(1, 243, 0, WR/2.25, p);
    xsEffectAmount(1, 242, 0, FR/2.25, p);
    xsEffectAmount(1, 245, 0, GR/2.25, p);
    xsEffectAmount(1, 244, 0, SR/2.25, p);
}
