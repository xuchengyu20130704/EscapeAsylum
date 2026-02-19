extends Node

var game_state = null
var main = null

func enter(entry_point: String):
	match entry_point:
		"branch_hide":
			隐居开端()
		"回归线":
			普通生活()

func 隐居开端():
	main.show_dialogue("系统", "你选择隐姓埋名")
	main.show_dialogue("系统", "在郊区租了间小屋")
	
	var choices = [
		{"text": "彻底忘记过去", "next": "普通生活", "effect": {"理智值": 20}},
		{"text": "暗中调查", "next": "branch_police", "effect": {"线索": ["暗中调查"]}},
		{"text": "联系家人", "next": "家人", "effect": {"道德值": 10}}
	]
	main.show_choices(choices)

func 普通生活():
	main.show_dialogue("系统", "一年后")
	main.show_dialogue("系统", "你有了稳定的工作")
	
	if main.check_conditions({"有线索": "暗中调查"}):
		main.show_dialogue("系统", "但记忆一直困扰着你")
	
	var choices = [
		{"text": "安于现状", "next": "回归结局", "effect": {}},
		{"text": "心理治疗", "next": "治疗", "effect": {"理智值": 30}},
		{"text": "回去复仇", "next": "branch_criminal", "effect": {"道德值": -30}}
	]
	main.show_choices(choices)

func 回归结局():
	if main.check_conditions({"理智值": 70}):
		main.show_dialogue("结局", "TRUE END - 平凡幸福")
	elif main.check_conditions({"理智值": 40}):
		main.show_dialogue("结局", "NORMAL END - 平淡生活")
	else:
		main.show_dialogue("结局", "BAD END - 边缘人")

func 家人():
	main.show_dialogue("家人", "我们一直在找你！")
	main.show_dialogue("系统", "原来你被陷害，家人一直在寻找真相")
	main.apply_effect({"道德值": 20, "理智值": 30})
	普通生活()

func 治疗():
	main.show_dialogue("心理医生", "你有创伤后应激障碍")
	main.show_dialogue("系统", "经过治疗，你慢慢康复")
	回归结局()

func on_choice_selected(choice):
	main.apply_effect(choice.get("effect", {}))
	
	match choice.get("next"):
		"普通生活":
			普通生活()
		"回归结局":
			回归结局()
		"家人":
			家人()
		"治疗":
			治疗()
		_:
			if choice.get("next") in ["branch_police", "branch_criminal"]:
				var module_map = {
					"branch_police": "正派线",
					"branch_criminal": "反派线"
				}
				main.switch_module(module_map[choice.get("next")], choice.get("next"))