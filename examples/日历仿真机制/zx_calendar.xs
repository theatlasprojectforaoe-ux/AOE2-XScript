/*
【“颛顼历”使用说明】：
1.修改该日历函数 zx_calendar 中的 year, month, day, hour 的初始值（TODO标记部分）；并在场景中加载该XS脚本

2.在场景中，修改触发变量101 ~ 105的名称分别为：year, month, day, hour, leap；初始值设置为0

3.新建 触发B，用于显示日历信息
    条件0： 玩家被击败：盖亚（此条件永不满足）
    触发状态：开启
    触发循环：关闭
    开启按钮“在屏幕上显示”，在文本路框添加以下内容之一：
// YYYY-MM-DD-HH 格式日期：
<year>年<month>月<day>日<hour>时
//      MM-DD-HH 格式日期：
<month>月<day>日<hour>时
// YYYY-MM-DD    格式日期：
<year>年<month>月<day>日

4.新建 触发器C，用于更新日期
  条件0：定时器：S秒 （表示每间隔S秒，更新日历中的最小时间单位 hour或day）
  效果0：脚本调用：
int update_calendar(){return (zx_calendar("hour"));}
  触发状态：关闭
  触发循环：开启

激活触发器C即可更新日历时间。将以S秒（游戏时间），的周期，更新日历时间“1小时”。（若要更新“1天”，请将脚本调用中的"hour"改为"day"）

【创意】可以在特定的日期值出现时，加入你自己的代码逻辑，实现想要的效果。
例如：
    208年的赤壁之战
    根据日出（卯时）和日落（酉时），添加昼夜交替效果
    ...
*/


/**
 * @brief 判断一个年份year是否为“颛顼历”闰年，是闰年返回1，否则返回0。
 * @param year: 此处根据“颛顼历”（采用19年7闰的规则）判断闰年：计算year和19取余[%]的结果，若结果在集合 {3,6,9,11,14,17,19} 中，则年份year是颛顼历的闰年。
 * @return <Int>返回闰年标识0或1
**/
int is_zxLeap(int year=1000) 
{
    int leap_ = 0;
    int mod19 = year%19;
    if(mod19==00 || mod19==03 || mod19==06 || mod19==09 || mod19==11 || mod19==14 || mod19==17) {leap_=1;}
    return (leap_);
}

//存储日期的触发器变量
const int TV_year = 101;
const int TV_month = 102;
const int TV_day = 103;
const int TV_hour = 104;
const int TV_leap = 105;
/**
 * @brief 【颛顼历】（中国古六历之一）。各时辰对应关系如下： {子:0, 丑:1, 寅:2, 卯:3, 辰:4, 巳:5, 午:6, 未:7, 申:8, 酉:9, 戌:10, 亥:11}
 * @param update: 日历时间更新方式。 可能的取值有：{"hour":小时, "day":天}。"hour"表示每次执行日历，时间更新“1小时”；"day"表示每次执行日历，时间更新“1天”。此处的“小时”和“天”是游戏中的虚拟时间，它的时长由 循环触发的定时器秒数/Rule最小执行周期（minInterval）决定
 * @param year: 年份初始值。取值范围 (-∞, +∞)
 * @param month: 月份初始值。取值范围 [1, 13]
 * @param day: 月内天数初始值。取值范围 [1, 30]
 * @param hour: 十二时辰起始值。取值范围 [1, 12)
 * @param leap: 闰年标识符。它由 is_zxLeap 函数确定
 * @param runs: 日历累计运行次数
 * @param months_in_year: 当前年份拥有的最大月份数。颛顼历平年（leap=0）有12个月，颛顼历闰年（leap=1）有13个月
 * @param days_in_month: 当前月份拥有的最大天数。在颛顼历中，采用大小月交替的方式，大月有30天，小月有29天。 1月~13月拥有的天数分别是：[(1,30), (2,29), (3,30), (4,29), (5,30), (6,29), (7,30), (8,29), (9,30), (10,29), (11,30), (12,29), (13,30)]，最后的(13,30)代表颛顼历闰年第13个月的天数，平年没有该项。
 * @return <Int>返回日历累计执行次数。成功更新日历返回runs，否则返回 -1 
**/
int zx_calendar(string update="hour") 
{
    static int year = -240;  //TODO: 设置年份初值
    static int month = 1;  //TODO: 设置月份初值
    static int day = 1;  //TODO: 设置月内天数初值
    static int hour = 0;  //TODO: 设置时辰初值
    static int leap = 0;
    static int runs = 0;
    
    if(is_zxLeap(year)==1 && runs==0) {leap=1;}
    //获取当前年份的最大月份数
    int months_in_year = (12+leap);
    //获取当前月份的最大天数
    int days_in_month = (month%2+29);
    //更新hour|day值
    if(update=="hour") {hour++; if(hour>=12){hour=0; day++;}}
    else if(update=="day") {day++;}
    else {return (-1);}
    //更新月份值
    if(day > days_in_month) {day=1; month++;}
    //更新年份值
    if(month > months_in_year) {
        month=1;
        year++;
        leap = is_zxLeap(year);
    }
    //更新日期相关触发器变量
    xsSetTriggerVariable(TV_year, year);
    xsSetTriggerVariable(TV_month, month);
    xsSetTriggerVariable(TV_day, day);
    xsSetTriggerVariable(TV_hour, hour);
    xsSetTriggerVariable(TV_leap, leap);
    /*
    在此处加入你的创意
    */
    runs++;
    return (runs);
}

