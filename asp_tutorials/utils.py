import os, re, json
from AoE2ScenarioParser.scenarios.aoe2_de_scenario import AoE2DEScenario
# from utils import load_const, load_function, Dict2Json


def load_const(path: str):
    '''
    Load consts from external XS file.

    Args:
        path: Relative or absolute path of external XS file.

    Returns:
        The text which storage XS constants.
    '''
    with open(path, mode='r', encoding='utf-8') as fp:
        consts = fp.read()
    return consts


def load_function(path: str, sep: str = '\n\n\n'):
    '''
    Load XS functions from external XS file, read it into a list..

    Args:
        path: Relative or absolute path of external XS file.
        sep: split file content with the sep string. Default sep is '\n\n\n', and you can redefine it customed.

    Returns:
        A tuple contains fn_ist, fn_ist_clean.(Usually, you only need to received the fn_list_clean as your return results, by call
        `src_fns, des_fns = load_function(path, sep='\n\n\n')`
            `fn_list`: A list of separated file contents by `sep` sign.
            `fn_ist_clean`: A list of fn_ist after reg-expression filtering.
    '''
    context = None
    with open(path, mode='r', encoding='utf-8') as fp:
        context = fp.read()
        fp.close()
    fn_list = context.split(sep)
    fn_list_clean = []
    for fn in fn_list:
        # Ignore empty code
        if fn in {'', '\r', '\n', '\r\n', '\t', None} or fn.strip(' ') == '':
            continue
        # Filter doc-comments
        res = re.sub('/\*\*(.*)\*\*/', '', fn, count=0, flags=re.S)
        # print("Remove doc-comments: \n", res)
        # print("-----------------------------")
        # Filter single/multi line comment
        res = re.sub('/\*(.*)\*/', '', res, count=0, flags=re.S)
        # print("Remove multi-line comment: \n", res)
        # print("-----------------------------")
        res = re.sub('//(.*)', '', res, count=0)
        # print("Remove single-line comment: \n", res)
        # print("-----------------------------")
        # Filter space letters
        res = res.replace('    ', '').replace(' || ', '||').replace('\t', '').replace(', ', ',').replace('\n', '')
        if fn in {'', '\r', '\n', '\r\n', '\t', None} or fn.strip(' ') == '':
            continue
        fn_list_clean.append(res)
    return fn_list, fn_list_clean


def Dict2Json(obj, path, mode='w+', encoding='utf-8', ensure_ascii=True):
    '''
    Storage an dict-like Object in to JSON file.

    Args:
        obj: object in python like-dict.
        path: Relative or absolute path of JSON file.
        mode: File opening method. Default 'w+' .
        encoding: the encode of JSON file.
        ensure_ascii: if set to True, other language content in the script can be previewed correctly.

    Returns:
        The text which storage XS constants.
    '''
    with open(path, mode=mode, encoding=encoding) as fp:
        json.dump(obj, fp, ensure_ascii=ensure_ascii)
        fp.close()


def import_XS(scx_infos: dict, sep: str='\n\n\n'):
    '''
    Import XS constants and functions from external files.

    Args:
        scx_infos: A dictionary containing player infors and scenario infors.
        sep: split file content with the sep string. Default sep is '\n\n\n', and you can redefine it customed.

    Returns:
        Return True if XS scripts import success, else return False
    '''

    SRC_PATH = scx_infos.get('src_path', None)
    if SRC_PATH in {None, '', ' ', '\n', '\t'}:
        print("Source scenario path is not exists.")
        return False
    
    # load scenario from src_path
    scenario = AoE2DEScenario.from_file(SRC_PATH)
    # trigger manager
    trigger_mgr = scenario.trigger_manager
    #print("Trigger amounts in SRC scenario: ", trigger_mgr.triggers.__len__())
    SCX_TITLE = scx_infos.get('scx_title', None)
    if SCX_TITLE not in {None, '', '\n', '\t'}:
        # Create a new trigger and set Scenario Name 
        title_trigger = trigger_mgr.add_trigger(str(SCX_TITLE), enabled=False)
        print("Set scenario title: ", title_trigger.name)
    
    # Create a new trigger and named as XS_FUNC_TITLE, to storage XS scripts.
    XS_FUNC_TITLE = scx_infos.get('script_title', None)
    if XS_FUNC_TITLE in {None, '', '\n', '\t'}:
        XS_FUNC_TITLE = 'XS Functions'
    # XS_CONST, BASE_FN, UDF_FN = (None, None, None)
    if len(scx_infos['xs_files']) >= 1:
        # Import XS constants
        #【Note】:When importing XS script as a condition into the scenario, the trigger status must be turned off, 
        # and the parameter `enabled` must be set to False 
        fn_trigger = trigger_mgr.add_trigger(XS_FUNC_TITLE, enabled=False)
        XS_CONST = scx_infos['xs_files'][0]
        fn_trigger.new_condition.script_call( load_const(XS_CONST) )
        print("XS constants import successed.")
        if len(scx_infos['xs_files']) >= 2:
            # Import base functions from files and storage them into a list
            BASE_FN = scx_infos['xs_files'][1]
            _, fn_list = load_function(BASE_FN, sep=sep)
            # Iterate the fn_list, receives each fn by create `new_conditon` in fn_trigger
            for fn in fn_list:
                fn_trigger.new_condition.script_call(fn)
            print("XS base functions import successed.")
            if len(scx_infos['xs_files']) >= 3:
                # Import UDF-functions into scenario
                UDF_FN = scx_infos['xs_files'][2]
                _, udf_list = load_function(UDF_FN, sep=sep)
                for trigger in trigger_mgr.triggers:
                    if trigger.name == XS_FUNC_TITLE:
                        for udf in udf_list:
                            trigger.new_condition.script_call(udf)
                print("UDF functions import successed.")
    else: 
        return False
    # Save scenario into file.
    DES_PATH = scx_infos['des_path']
    scenario.write_to_file(DES_PATH)
    print("The final scenario had save to: ", DES_PATH)
    return True

def del_triggers(scx_infos: dict):
    '''
    Delete some/all triggers on your scenario.

    Args:
        scx_infos: A dictionary containing player infors and scenario infors.

    Returns:
        Return True if delete triggers succesfully, else return False
    '''
    # Load scenario from src_path
    SRC_PATH = scx_infos.get('src_path', None)
    if SRC_PATH in {None, '', ' ', '\n', '\t'}:
        print("Source scenario path is not exists.")
        return False
    DES_PATH = scx_infos.get('des_path', None)
    if DES_PATH in {None, '', ' ', '\n', '\t'}:
        print("Destination scenario path is not exists.")
        return False

    scenario = AoE2DEScenario.from_file(SRC_PATH)
    # copy all triggers
    trigger_mgr = scenario.trigger_manager
    copy_triggers = trigger_mgr.triggers
    trigger_counts = copy_triggers.__len__()
    print("Trigger count in this scenario: ", trigger_counts)

    def _del_range(si, ei):
        if si < 0:
            si = 0
        elif si >= trigger_counts:
            si = trigger_counts - 1
        else:
            pass

        if (ei == -1 or ei > trigger_counts):
            ei = trigger_counts
        elif ei == 0:
            ei += 1
        else:
            pass
        if si > ei:
            si, ei = ei, si
        return si, ei

    start_idx, end_idx = _del_range(scx_infos['del_range'][0], scx_infos['del_range'][1])
    if start_idx==0 and end_idx==trigger_counts:
        # delete all triggers, set trigger_manager.triggers to an empty list
        trigger_mgr.triggers = []
        scenario.write_to_file(DES_PATH)
        print("\nDelete all triggers successed.")
    else:
        # delete trigger range: [start_idx, end_idx)
        trigger_mgr.triggers = copy_triggers[0:start_idx] + copy_triggers[end_idx: ]
        scenario.write_to_file(DES_PATH)
        print(f"\nDelete triggers between [{start_idx},{end_idx}) successed.")
    return True


def migrate_triggers(scx_infos: dict):
    '''
    Migrate triggers from src_map to des_map.

    Args:
        scx_infos: A dictionary containing player infors and scenario infors.

    Returns:
        Return True if migrate triggers succesfully, else return False
    '''

    scn1 = AoE2DEScenario.from_file(scx_infos.get('scn1_path', ''))
    scn2 = AoE2DEScenario.from_file(scx_infos.get('scn2_path', ''))
    # trigger_manages for scn1 and scn2
    trigger_mgr1 = scn1.trigger_manager
    trigger_mgr2 = scn2.trigger_manager
    # The number of triggers included in the scenarios
    print("Trigger counts in map1: ", trigger_mgr1.triggers.__len__())
    print("Trigger counts in map2: ", trigger_mgr2.triggers.__len__())
    # Iterate the scn1 triggers, filter the trigger that trigger.name is in scx_infos["migrate_triggers"]
    migrate_indices = []
    migrate_triggers = []
    for t1 in trigger_mgr1.triggers:
        if t1.name in scx_infos["migrate_triggers"]:
            migrate_indices.append(t1.trigger_id)
            migrate_triggers.append(t1)
    print("Need to migrate trigger ids: ", migrate_indices)
    # Set the pos_start=migrate_indices[0], and pos_end=migrate_indices[-1]
    # pos_start = migrate_indices[0]
    # pos_end = migrate_indices[-1]+1
    # Migrate `migrate_triggers` list to trigger_mgr2
    trigger_mgr2.import_triggers(triggers=migrate_triggers, index=scx_infos.get('insert_pos', -1))
    # Reorder trigger according to display_order
    trigger_mgr2.reorder_triggers(trigger_mgr2.trigger_display_order)
    # Save scenario to "output_path"
    scn2.write_to_file(scx_infos.get('output_path', ''))


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
        print("触发器数量为0，无需重排。")
        return None
    elif trigger_amt == 1:
        print("触发器数量为1，无需重排。")
        return None
    else:
        # Get display_orders and create_orders
        display_orders = []
        create_orders = []
        for idx,tid in enumerate(trigger_mgr.trigger_display_order):
            display_orders.append(idx)
            create_orders.append(tid)
        if show_order:
            print("显示序\t触发ID\t触发名称")
            print("------------------------------")
            for idx,tid in zip(display_orders, create_orders):
                trigger = trigger_mgr.triggers[tid]
                print(idx, "\t", tid, '\t', trigger.name)
        
        if display_orders == create_orders:
            # don't reorder trigger
            print("触发器顺序未打乱，无需重排。")
            return None
        else:
            print("开始根据显示序重排触发器 ......")
            trigger_mgr.reorder_triggers(trigger_mgr.trigger_display_order)
            # save scenario
            scenario.write_to_file(output_path)
            print("触发器重排完成！")


if __name__ == "__main__":
    pass

