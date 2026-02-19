extends Node

var game_state = null
var main = null

func enter(entry_point: String):
	match entry_point:
		"branch_police":
			警局开端()
		"police_1":
			调查开始()

func 警局开端():
	main.show_dialogue("警察", "你说被非法关押？有证据吗？")
	
	if main.check_conditions({"有线索": "神秘对话"}):
		main.show_dialogue("你", "我听到神秘人的对话...")
		调查开始()
	else:
		var choices = [
			{"text": "回精神病院找证据", "next": "回去取证", "effect": {"理智值": -20}},
			{"text": "找律师", "next": "找律师", "effect": {"道德值": 5}},
			{"text": "放弃", "next": "branch_hide", "effect": {}}
		]
		main.show_choices(choices)

func 调查开始():
	main.show_dialogue("系统", "警方开始调查精神病院")
	
	if main.check_conditions({"信任的人": ["警察"]}):
		main.apply_effect({"线索": ["内部档案"]})
	
	var choices = [
		{"text": "继续调查", "next": "发现真相", "effect": {"道德值": 10, "理智值": -10}},
		{"text": "退缩", "next": "branch_hide", "effect": {"道德值": -20}},
		{"text": "找媒体", "next": "发现真相", "effect": {"线索": ["媒体"]}}
	]
	main.show_choices(choices)

func 发现真相():
	main.show_dialogue("系统", "发现惊人的真相")
	main.show_dialogue("系统", "精神病院在非法贩卖器官")
	
	var choices = [
		{"text": "彻底揭露", "next": "正派结局", "effect": {"道德值": 30}},
		{"text": "隐姓埋名", "next": "回归线", "effect": {}},
		{"text": "自己去复仇", "next": "复仇", "effect": {"道德值": -10, "理智值": -20}}
	]
	main.show_choices(choices)

func 正派结局():
	main.show_dialogue("系统", "犯罪团伙全部落网")
	main.show_dialogue("系统", "你成了英雄")
	
	if main.check_conditions({"道德值": 80}):
		main.show_dialogue("结局", "TRUE END - 正义之光")
	else:
		main.show_dialogue("结局", "GOOD END - 沉冤得雪")

func on_choice_selected(choice):
	main.apply_effect(choice.get("effect", {}))
	
	match choice.get("next"):
		"发现真相":
			发现真相()
		"正派结局":
			正派结局()
		_:
			if choice.get("next") in ["branch_hide", "回归线"]:
				main.switch_module("回归线", choice.get("next"))