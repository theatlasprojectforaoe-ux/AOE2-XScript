from asp_tools import del_triggers

r"""
    该脚本用于删除场景中的部分或全部触发器（当触发器数量数以千计时）。

"""

USER = "babycat"    # TODO: 你的计算机用户名
GameId = 76561198386517457    # TODO: 你的AOE2DE游戏ID
SCX_NAME = "TEST2"    # TODO: 要导入XS脚本的源场景名称（不含扩展名）
infos = {
    "src_path": f"C:/Users/{USER}/Games/Age of Empires 2 DE/{GameId}/resources/_common/scenario/{SCX_NAME}.aoe2scenario",
    "des_path": f"C:/Users/{USER}/Games/Age of Empires 2 DE/{GameId}/resources/_common/scenario/{SCX_NAME}_clean.aoe2scenario",
    "del_range": (0, -1),    # TODO: 要删除触发器的范围，取值为 [0, 场景触发器总数) -1代表最后一个触发器
}


if __name__ == "__main__":
    del_triggers(scx_infos=infos)
