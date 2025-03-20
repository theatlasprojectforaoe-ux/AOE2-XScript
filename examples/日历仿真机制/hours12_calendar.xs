/**
 * @brief "古代十二时辰日历" 将一天划分为十二时辰，时辰有十二种取值情况，分别是：
          {1:"子时", 2:"丑时", 3:"寅时",
           4:"卯时", 5:"辰时", 6:"巳时",
           7:"午时", 8:"未时", 9:"申时",
           10:"酉时", 11:"戌时", 12:"亥时",}
 * @param HT: 单个时辰的时长间隔（秒数），以此参数设置规则的最小运行周期minInterval
 * @param TV_month: 存储month的触发器变量
 * @param TV_day: 存储day的触发器变量
 * @param TV_hour: 存储hour的触发器变量
 * @param TV_hour12: 存储hour12值的触发器变量
**/
const int TV_year = 101;
const int TV_month = 102;
const int TV_day = 103;
const int TV_hour = 104;
const int TV_hour12 = 105;
const int HT = 30;
rule Hours12Calendar
    inactive
    group Date
    minInterval 0
    priority 100
{
  //static int year = 1000;    //年份初始值
    static int month = 2;    //月份初始值
    static int day = 27;    //天数初始值
    static int hour = 23;    //小时初始值
    static int hour12 = 1;    //十二时辰初始值
    static int runs = 0;    //规则运行次数
    if(runs==0) {//规则首次运行时，同步起始日期到触发器变量
        xsSetRuleMinIntervalSelf(HT/2);
        xsSetTriggerVariable(TV_month, month);
        xsSetTriggerVariable(TV_day, day);
        xsSetTriggerVariable(TV_hour, hour);
        xsSetTriggerVariable(TV_hour12, hour12);
    }
    else {
        hour++;    //hour以周期T自动增加1
        if(hour >= 24) {hour = 0;}
        if(hour%2 == 1) {
            hour12++;
            if(hour12 > 12) 
            {
                hour12=1;  day++;
                if((day > 30 && month != 2)||(day > 28 && month == 2)) 
                {
                    day = 1;  month++;
                    if(month > 12) {
                        month=1;
                      //year++;
                      //xsSetTriggerVariable(TV_year, year);
                    }
                    xsSetTriggerVariable(TV_month, month);
                }
                xsSetTriggerVariable(TV_day, day);
            }
            xsSetTriggerVariable(TV_hour12, hour12);
        }
        xsSetTriggerVariable(TV_hour, hour);
    }
    runs++;
}
void open_calendar() {xsEnableRule("Hours12Calendar");}
void close_calendar(){xsDisableRule("Hours12Calendar");}
