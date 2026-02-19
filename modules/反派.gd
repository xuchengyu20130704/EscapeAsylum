extends Node

var game_state = null
var main = null

func enter(entry_point: String):
	match entry_point:
		"branch_criminal":
			犯罪开端()

func 犯罪开端():
	main.show_dialogue("系统", "你联系上以前的同伙-黑狼")
	main.show_dialogue("黑狼", "哈哈！我就知道你会出来！")
	
	if main.check_conditions({"道德值": 30}):
		main.show_dialogue("你", "我不想再犯罪了...")
		var choices = [
			{"text": "拒绝离开", "next": "branch_hide", "effect": {"道德值": 15}},
			{"text": "犹豫", "next": "criminal_1", "effect": {}}
		]
		main.show_choices(choices)
	else:
		犯罪第一章()

func 犯罪第一章():
	main.show_dialogue("黑狼", "城北金库，干一票大的")
	
	var choices = [
		{"text": "加入", "next": "criminal_2", "effect": {"道德值": -20, "信任的人": ["黑狼"]}},
		{"text": "表面答应实际报警", "next": "branch_police", "effect": {"道德值": 20, "flag_卧底": true}},
		{"text": "拒绝", "next": "回归线", "effect": {"道德值": 10}}
	]
	main.show_choices(choices)

func 犯罪第二章():
	if main.check_conditions({"flag_卧底": true}):
		卧底剧情()
		return
	
	main.show_dialogue("系统", "你们成功抢到金库")
	main.show_dialogue("系统", "但分钱时出了问题")
	
	if main.check_conditions({"道德值": 10}):
		反派结局_背叛()
	else:
		反派结局_成功()

func 卧底剧情():
	main.show_dialogue("系统", "你悄悄报警")
	main.show_dialogue("系统", "黑狼一伙落网")
	main.show_dialogue("警察", "谢谢你立功了！")
	main.switch_module("正派线", "police_1")

func 反派结局_成功():
	main.show_dialogue("系统", "你带着钱远走高飞")
	main.show_dialogue("系统", "但每晚做噩梦")
	
	if main.check_conditions({"理智值": 30}):
		main.show_dialogue("系统", "你精神崩溃，又被送回精神病院")
		main.show_dialogue("结局", "BAD END - 循环疯癫")
	else:
		main.show_dialogue("系统", "你在国外过着奢华生活")
		main.show_dialogue("结局", "NORMAL END - 逃亡者")

func 反派结局_背叛():
	main.show_dialogue("系统", "黑狼想独吞钱财，开枪打伤了你")
	main.show_dialogue("系统", "你倒在血泊中...")
	main.show_dialogue("结局", "BAD END - 被背叛")

func on_choice_selected(choice):
	main.apply_effect(choice.get("effect", {}))
	
	match choice.get("next"):
		"criminal_1":
			犯罪第一章()
		"criminal_2":
			犯罪第二章()
		_:
			if choice.get("next") in ["branch_hide", "branch_police", "回归线"]:
				var module_map = {
					"branch_hide": "回归线",
					"branch_police": "正派线", 
					"回归线": "回归线"
				}
				main.switch_module(module_map[choice.get("next")], choice.get("next"))