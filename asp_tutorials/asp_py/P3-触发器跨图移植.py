from asp_tools import migrate_triggers

r"""
    该脚本用于场景触发器的跨图移植

"""

USER = "babycat"    # TODO: 你的计算机用户名
GameId = 76561198386517457    # TODO: 你的AOE2DE游戏ID
SCX1 = "TEST2"    # TODO: 进行触发移植的源场景
SCX2 = "TEST2_clean"    # TODO: 进行触发移植的目标场景
OUTPUT_SCX = "TEST2_OUT"    # TODO: 移植输出目标场景名称
infos = {
    "scn1_path": f"C:/Users/{USER}/Games/Age of Empires 2 DE/{GameId}/resources/_common/scenario/{SCX1}.aoe2scenario",
    "scn2_path": f"C:/Users/{USER}/Games/Age of Empires 2 DE/{GameId}/resources/_common/scenario/{SCX2}.aoe2scenario",
    "output_path": f"C:/Users/{USER}/Games/Age of Empires 2 DE/{GameId}/resources/_common/scenario/{OUTPUT_SCX}.aoe2scenario",
    # 源场景中，要移植的触发器列表
    "migrate_triggers": ['T1', 'T3', 'T5', 'T7', 'T9'],  # TODO: 要移植的触发器名称的列表
    # ["***** 日历+季节系统 *****",
    #                   "[S] 显示日历",
    #                   "春季 UI",
    #                   "夏季 UI",
    #                   "秋季 UI",
    #                   "冬季 UI",
    #                   "季节交替（春季）Entrance",
    #                   "季节交替（夏季）",
    #                   "季节交替（秋季）",
    #                   "季节交替（冬季）",
    #                   "日历更新系统（2s/day）"],
    "insert_pos": -1,    # TODO: 移植触发器列表的插入位置，默认在尾部插入
}


if __name__ == "__main__":
    migrate_triggers(scx_infos=infos)
