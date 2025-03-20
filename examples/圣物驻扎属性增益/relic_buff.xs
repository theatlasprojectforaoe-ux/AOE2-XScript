/// 圣物驻扎属性增益机制 ///
/*
案例，在玩家src_p(玩家1)修道院中驻扎圣物，每个圣物为玩家target_p(2)的以下单位，提供相应的属性增益：
增益详情：
    东方剑士[894]：  生命值+5，移动速度 +0.03
    年轻的雅德维嘉[1732]：  近战攻击+1 | 近战防御 +1
*/
const int src_p = 1;
const int target_p = 2;
const int interval = 1;
const int TV_relic = 7;    //圣物同步的触发器变量
/**
 * @brief 圣物驻扎属性增益机制。在玩家src_p的修道院驻扎圣物，玩家target_p 的指定单位享受属性增益
 * @param src_p: 驻扎圣物的玩家
 * @param target_p: 圣物加成的目标玩家
   Rule参数说明：
 * @param interval: rule执行间隔秒数，默认1秒检查一次
 * @param minInterval/maxInterval: rule的最小/最大执行间隔
 * @param priority: rule执行优先级，取值范围[1, 100]；priority数值越大，rule优先级越高
**/
rule RelicBuffs
    inactive
    group Buffs
    minInterval 0    //0表示立即执行
    priority 100     //最高优先级
{
    static int runs = 0;    //rule累计运行次数
    static int relic_pre = 0;    //上一时刻圣物驻扎数
    static int wave_ = 0;    // 当前时刻圣物变化数量
    //Rule首次执行后，重置执行间隔为interval
    if(runs==0) {xsSetRuleMinIntervalSelf(interval);}
    // 获取驻扎源玩家的圣物数
    int relic_cur = xsPlayerAttribute(src_p, 7);
    if((relic_cur > 0) && (relic_cur == relic_pre)) {}
    else if(relic_cur == 0) 
    {// 当前拥有圣物数量为0（修道院被摧毁），清空圣物增益
        xsEffectAmount(4, 894, 0, -5*relic_pre, target_p);
        xsEffectAmount(4, 894, 5, -0.03*relic_pre, target_p);
        //攻击力+-1 | 护甲 +-1  /圣物
        //xsEffectAmount(mod, unit, uAttack, T*256+X, p);
        xsEffectAmount(4, 1732, 9, 4*256-relic_pre, target_p);
        xsEffectAmount(4, 1732, 8, 4*256-relic_pre, target_p);
        relic_pre = relic_cur;
        //同步圣物捕获数至触发器变量TV_relic
        xsSetTriggerVariable(TV_relic, relic_pre);
    }
    else 
    {//修道院圣物数量变动时，计算波动量 wave_
        wave_ = relic_cur - relic_pre;
        //设置单位属性（非攻防）
        xsEffectAmount(4, 894, 0, 5*wave_, target_p);
        xsEffectAmount(4, 894, 5, 0.03*wave_, target_p);
        //攻防 标志位WS：wave_>0时WS=1，wave_<0时WS=-1 
        int WS = wave_/abs(wave_);
        xsEffectAmount(4, 1275, 9, WS*4*256+wave_, target_p);
        xsEffectAmount(4, 1275, 8, WS*4*256+wave_, target_p);
        relic_pre = relic_cur;
        //将圣物夺取数同步更新到触发器变量TV_relic
        xsSetTriggerVariable(TV_relic, relic_pre);
    }
    runs++;
}

// 触发A: 玩家src_p拥有圣物数>0时调用该函数，同时激活触发B
void  openRelicBuffs(){xsEnableRule("RelicBuffs");}
// 触发B: 玩家src_p拥有圣物数<=0时调用该函数，同时激活触发A
void closeRelicBuffs(){xsDisableRule("RelicBuffs");}
