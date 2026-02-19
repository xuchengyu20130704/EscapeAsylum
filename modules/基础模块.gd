extends Node

var game_state = null
var main = null

func enter(entry_point: String):
	match entry_point:
		"escape":
			escape_sequence()

func escape_sequence():
	main.show_dialogue("你", "终于逃出来了...")
	main.show_dialogue("系统", "你站在精神病院后门")
	main.show_dialogue("系统", "突然听到身后有脚步声")
	
	var choices = [
		{
			"text": "回头看看是谁",
			"next": "回头",
			"effect": {"flag_被发现": true}
		},
		{
			"text": "头也不回地跑",
			"next": "逃跑",
			"effect": {"理智值": -5}
		},
		{
			"text": "躲进灌木丛",
			"next": "躲藏",
			"effect": {"flag_被发现": false}
		}
	]
	main.show_choices(choices)

func on_choice_selected(choice):
	main.apply_effect(choice.get("effect", {}))
	
	match choice.get("next"):
		"回头":
			回头剧情()
		"逃跑":
			逃跑剧情()
		"躲藏":
			躲藏剧情()
		"听护士说":
			听护士说()
		"质问":
			质问()
		"跟踪":
			跟踪()
		"branch_police":
			main.switch_module("正派线", "branch_police")
		"branch_hide":
			main.switch_module("回归线", "branch_hide")
		"branch_criminal":
			main.switch_module("反派线", "branch_criminal")

func 回头剧情():
	main.show_dialogue("护士", "等等！你不能走！")
	main.show_dialogue("护士", "你的治疗还没完成...")
	
	var choices = [
		{
			"text": "推开她逃跑",
			"next": "逃跑",
			"effect": {"道德值": -10, "理智值": -5}
		},
		{
			"text": "听她说",
			"next": "听护士说",
			"effect": {}
		},
		{
			"text": "质问她",
			"next": "质问",
			"effect": {"理智值": 5}
		}
	]
	main.show_choices(choices)

func 逃跑剧情():
	main.show_dialogue("系统", "你跑到城市边缘")
	
	var choices = [
		{
			"text": "去警察局报案",
			"next": "branch_police",
			"effect": {"道德值": 10}
		},
		{
			"text": "躲起来",
			"next": "branch_hide",
			"effect": {"理智值": -10}
		},
		{
			"text": "联系以前同伙",
			"next": "branch_criminal",
			"effect": {"道德值": -20}
		}
	]
	main.show_choices(choices)

func 躲藏剧情():
	main.show_dialogue("系统", "你躲在灌木丛中")
	main.show_dialogue("系统", "看见两个人跑过去")
	main.apply_effect({"线索": ["神秘对话"]})
	
	var choices = [
		{
			"text": "继续逃跑",
			"next": "逃跑",
			"effect": {}
		},
		{
			"text": "跟踪他们",
			"next": "跟踪",
			"effect": {"理智值": -15, "线索": ["跟踪线"]}
		}
	]
	main.show_choices(choices)

func 听护士说():
	main.show_dialogue("护士", "其实...院长在利用病人做非法实验")
	main.show_dialogue("护士", "你逃跑是对的，要小心")
	main.apply_effect({"线索": ["护士的警告"], "flag_被发现": false})
	逃跑剧情()

func 质问():
	main.show_dialogue("你", "为什么关着我？我没病！")
	main.show_dialogue("护士", "...其实你是被陷害的")
	main.apply_effect({"线索": ["被陷害的真相"]})
	逃跑剧情()

func 跟踪():
	main.show_dialogue("系统", "你跟踪他们到了废弃仓库")
	main.show_dialogue("系统", "听到他们在讨论\"器官贩卖计划\"")
	main.apply_effect({"线索": ["器官贩卖"], "道德值": 10})
	main.switch_module("正派线", "branch_police")