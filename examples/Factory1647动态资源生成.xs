/**
 * @brief 设置贸易工厂[1647]每分钟的动态资源生成率
          每个贸易工厂生成率公式（factories 代表拥有贸易工厂总数）： rate = 1/sqrt(factories)
 * @param wood: 木材生成点数/min
 * @param food: 食物生成点数/min
 * @param gold: 黄金生成点数/min
 * @param stone: 石头生成点数/min
 * @param p: 玩家序号
 * @return <Bool> 生成率改变的标志。若rate发生改变返回true，否则返回false
**/
bool Factory1647DynamicRate(float wood=0.0, float food=0.0, float gold=0.0, float stone=0.0, int p=-1) 
{
    static int factories = 0;
    float rate = 0.0;
    int cur_factory = xsGetObjectCount(p, 1647);    //获取当前的贸易工厂数量
    if(factories != cur_factory) {
        factories = cur_factory;
        if(factories == 0) {rate = 0.0;}
        else if(factories > 0) {rate = 1.0/sqrt(factories);}
        xsEffectAmount(1, 243, 0, rate*wood/(2.25*60), p);
        xsEffectAmount(1, 242, 0, rate*food/(2.25*60), p);
        xsEffectAmount(1, 245, 0, rate*gold/(2.25*60), p);
        xsEffectAmount(1, 244, 0, rate*stone/(2.25*60),p);
        return (true);
    }
    return (false);
}
