/*
【案例】：开宝箱
作者:mdfc
*/

int treasure_box = 835;//宝箱的id一定要是非自动转化类中的一个 且是大地之母的
int treasure = 305;//宝物的id一定要是自动转化类中的一个
int players = xsGetNumPlayers();//遍历对应的玩家数量 与编辑器中拥有的玩家数必须一致


void Func1740471558()
{//初始化属性
    xsEffectAmount(0,treasure_box,5,0,0);//[宝箱ID]设置[移动速度](0)给大地之母
    xsEffectAmount(0,treasure_box,0,1,0);//[宝箱ID]设置[生命值](1)给大地之母
    xsEffectAmount(0,treasure_box,71,15403,0);//[宝箱ID]设置[站立图像1](15403)给大地之母
    xsEffectAmount(0,treasure_box,72,0,0);//[宝箱ID]设置[站立图像2](0)给大地之母
    xsEffectAmount(0,treasure_box,73,0,0);//[宝箱ID]设置[濒死图像](0)给大地之母
    xsEffectAmount(0,treasure_box,75,0,0);//[宝箱ID]设置[行走图像](0)给大地之母
    xsEffectAmount(0,treasure_box,76,0,0);//[宝箱ID]设置[奔跑图像](0)给大地之母
    xsEffectAmount(0,treasure_box,70,0,0);//[宝箱ID]设置[攻击图像](0)给大地之母
    xsEffectAmount(0,treasure_box,57, treasure,0);//[宝箱ID]设置[死亡单位ID](宝物ID)给大地之母
    xsEffectAmount(0,treasure_box,66,-1,0);//[宝箱ID]设置[血迹单位ID](-1)给大地之母
    
    xsEffectAmount(0,treasure,5,0,0);//[宝物ID]设置[移动速度](0)给大地之母
    xsEffectAmount(0,treasure,0,1,0);//[宝物ID]设置[生命值](1)给大地之母
    xsEffectAmount(0,treasure,71,7640,0);//[宝物ID]设置[站立图像1](7640)给大地之母
    xsEffectAmount(0,treasure,72,0,0);//[宝物ID]设置[站立图像2](0)给大地之母
    xsEffectAmount(0,treasure,73,0,0);//[宝物ID]设置[濒死图像](0)给大地之母
    xsEffectAmount(0,treasure,75,0,0);//[宝物ID]设置[行走图像](0)给大地之母
    xsEffectAmount(0,treasure,76,0,0);//[宝物ID]设置[奔跑图像](0)给大地之母
    xsEffectAmount(0,treasure,70,0,0);//[宝物ID]设置[攻击图像](0)给大地之母
    xsEffectAmount(0,treasure,57, -1,0);//[宝物ID]设置[死亡单位ID](-1)给大地之母
    xsEffectAmount(0,treasure,66,-1,0);//[宝物ID]设置[血迹单位ID](-1)给大地之母
}

rule Rule1740471899
    active
    minInterval 1
    group DefaultG
    priority 1
{
    for(i=1;<=players)
    {
        int treasure_amt = xsGetObjectCount(1,treasure);
        int food = xsPlayerAttribute(i,0);
        if(treasure_amt>0)
        {
            xsSetTriggerVariable(i,1);//击杀信号
            xsSetPlayerAttribute(i,0,food+1);
            xsChatData("p="+"i"+" num="+treasure_amt);
        }
    }
}

