import sys
from AoE2ScenarioParser.scenarios.aoe2_de_scenario import AoE2DEScenario


def reorder_scx_triggers(scx_path: str, output_path: str, show_order: bool=True):
    '''
    Args: 
        scx_path: The absolute/relative path of your scenario which need to reorder triggers.
        output_path: The absolute/relative save path of reorded scenario.
        show_order: If set True, will show trigger's `display_orders` and `create_orders`
    '''
    scenario = AoE2DEScenario.from_file(scx_path)
    trigger_mgr = scenario.trigger_manager
    trigger_amt = trigger_mgr.triggers.__len__()
    if trigger_amt == 0:
        print("Scenario cantains 0 triggers, need not reorder triggers.")
        return None
    elif trigger_amt == 1:
        print("Scenario cantains 1 triggers, need not reorder triggers.")
        return None
    else:
        # Get display_orders and create_orders
        display_orders = []
        create_orders = []
        for idx,tid in enumerate(trigger_mgr.trigger_display_order):
            display_orders.append(idx)
            create_orders.append(tid)
        if show_order:
            print("Show Order\tTrigger ID\tTrigger Name")
            print("------------------------------")
            for idx,tid in zip(display_orders, create_orders):
                trigger = trigger_mgr.triggers[tid]
                print(idx, "\t", tid, '\t', trigger.name)
        
        if display_orders == create_orders:
            # don't reorder trigger
            print("Trigger displayer_orders are equal to create_orders, need not reorder triggers.")
            return None
        else:
            print("Start reorder triggers ......")
            trigger_mgr.reorder_triggers(trigger_mgr.trigger_display_order)
            # save scenario
            scenario.write_to_file(output_path)
            print("Reorder triggers finished !")


if __name__ =='__main__':
    SCX_PATH = input("请输入要排序的场景文件路径：")
    OUTPUT_PATH = input("请输入排序后的场景文件路径：")
    S = input("是否显示原触发器顺序？ [Y]/N").strip()
    show = True if (S in {'','Y'}) else False
    reorder_scx_triggers(SCX_PATH, OUTPUT_PATH, show_order=show)